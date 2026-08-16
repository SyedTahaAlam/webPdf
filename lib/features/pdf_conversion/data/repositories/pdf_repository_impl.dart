// lib/features/pdf_conversion/data/repositories/pdf_repository_impl.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:webpdf/core/error/app_exception.dart';
import 'package:webpdf/core/error/error_logger.dart';
import 'package:webpdf/core/error/result.dart';
import 'package:webpdf/features/pdf_conversion/data/services/js_bridge_service.dart';
import 'package:webpdf/features/pdf_conversion/data/services/pdf_generator_service.dart';
import 'package:webpdf/features/pdf_conversion/data/services/webview_capture_service.dart';
import 'package:webpdf/features/pdf_conversion/domain/entities/conversion_mode.dart';
import 'package:webpdf/features/pdf_conversion/domain/entities/conversion_request.dart';
import 'package:webpdf/features/pdf_conversion/domain/entities/selection_rect.dart';
import 'package:webpdf/features/pdf_conversion/domain/repositories/pdf_repository.dart';

/// Concrete implementation backed by WebView screenshot + pdf package.
class PdfRepositoryImpl implements PdfRepository {
  PdfRepositoryImpl({
    required InAppWebViewController webController,
    WebViewCaptureService? captureService,
    PdfGeneratorService? generatorService,
  })  : _webController = webController,
        _capture = captureService ?? const WebViewCaptureService(),
        _generator = generatorService ?? const PdfGeneratorService();

  final InAppWebViewController _webController;
  final WebViewCaptureService _capture;
  final PdfGeneratorService _generator;

  @override
  Future<Result<String>> convertToPdf(ConversionRequest request) async {
    return switch (request.mode) {
      ConversionMode.fullPage => _convertFullPage(request),
      ConversionMode.selectSection => _convertSection(request),
    };
  }

  // ── Full-page conversion ──────────────────────────────────────────────────

  Future<Result<String>> _convertFullPage(ConversionRequest request) async {
    // 1. Get total page height and viewport height via JS.
    final dimResult = await _capture.evaluateJs(
      _webController,
      JsBridgeService.getFullPageDimensions,
    );

    int pageHeight = 0;
    int viewportHeight = 0;

    if (dimResult.isRight()) {
      try {
        final Map<String, dynamic> dims =
            jsonDecode(dimResult.getOrElse(() => '{}')) as Map<String, dynamic>;
        pageHeight = (dims['height'] as num?)?.toInt() ?? 0;
        viewportHeight = (dims['viewportHeight'] as num?)?.toInt() ?? 0;
      } catch (_) {}
    }

    // Fallback to 812 (common viewport) only if JS fails.
    if (viewportHeight <= 0) viewportHeight = 812;
    if (pageHeight <= 0) pageHeight = viewportHeight;

    final List<Uint8List> strips = [];
    int scrollY = 0;

    // 2. Scroll and screenshot until the full page is captured.
    while (scrollY < pageHeight) {
      await _capture.evaluateJs(
        _webController,
        JsBridgeService.scrollToY(scrollY),
      );
      // Small delay to let the page repaint.
      await Future<void>.delayed(const Duration(milliseconds: 200));

      final shotResult = await _capture.captureViewport(_webController);
      if (shotResult.isLeft()) {
        return failure(shotResult.fold((exception) => exception, (_) => const CaptureException()));
      }
      strips.add(shotResult.getOrElse(() => Uint8List(0)));

      scrollY += viewportHeight;
    }

    // 3. Build PDF.
    return _generator.generatePdf(
      imagePages: strips,
      customName: request.customName,
    );
  }

  // ── Section conversion ────────────────────────────────────────────────────

  Future<Result<String>> _convertSection(ConversionRequest request) async {
    final rect = request.selectedRect;
    if (rect == null) {
      return failure(
        const CaptureException(cause: 'No selection rectangle provided'),
      );
    }

    if (!rect.hasValidSize) {
      return failure(
        const CaptureException(cause: 'Invalid selection size'),
      );
    }
    if (!rect.isWithinViewport) {
      return failure(
        const CaptureException(
          cause: 'Selection extends beyond visible viewport. Scroll and reselect.',
        ),
      );
    }

    // Capture viewport and crop it to the selected CSS-pixel rectangle.
    final shotResult = await _capture.captureViewport(_webController);
    if (shotResult.isLeft()) {
      return failure(shotResult.fold((exception) => exception, (_) => const CaptureException()));
    }

    final screenshot = shotResult.getOrElse(() => Uint8List(0));
    final cropResult = _cropSelectionScreenshot(
      screenshotBytes: screenshot,
      rect: rect,
    );
    if (cropResult.isLeft()) {
      return failure(cropResult.fold((exception) => exception, (_) => const CaptureException()));
    }
    final croppedPng = cropResult.getOrElse(() => Uint8List(0));

    // Build a single-page PDF.
    return _generator.generatePdf(
      imagePages: [croppedPng],
      customName: request.customName,
    );
  }

  Result<Uint8List> _cropSelectionScreenshot({
    required Uint8List screenshotBytes,
    required SelectionRect rect,
  }) {
    try {
      final decoded = img.decodeImage(screenshotBytes);
      if (decoded == null) {
        return failure(const CaptureException(cause: 'Failed to decode screenshot'));
      }

      final dpr = rect.dpr <= 0 ? 1.0 : rect.dpr;
      final cropX = (rect.x * dpr).round();
      final cropY = (rect.y * dpr).round();
      final cropWidth = (rect.width * dpr).round();
      final cropHeight = (rect.height * dpr).round();

      ErrorLogger.instance.info(
        'Section capture debug: '
        'dpr=$dpr viewport=${rect.viewportWidth}x${rect.viewportHeight} '
        'cssRect=(${rect.x},${rect.y},${rect.width},${rect.height}) '
        'deviceRect=($cropX,$cropY,$cropWidth,$cropHeight) '
        'image=${decoded.width}x${decoded.height}',
      );

      final safeX = cropX.clamp(0, decoded.width - 1).toInt();
      final safeY = cropY.clamp(0, decoded.height - 1).toInt();
      final maxWidth = decoded.width - safeX;
      final maxHeight = decoded.height - safeY;
      final safeWidth = cropWidth.clamp(0, maxWidth).toInt();
      final safeHeight = cropHeight.clamp(0, maxHeight).toInt();

      if (safeWidth <= 0 || safeHeight <= 0) {
        return failure(
          const CaptureException(cause: 'Selection produced an empty crop area'),
        );
      }

      final cropped = img.copyCrop(
        decoded,
        x: safeX,
        y: safeY,
        width: safeWidth,
        height: safeHeight,
      );
      return success(Uint8List.fromList(img.encodePng(cropped)));
    } catch (e) {
      return failure(CaptureException(cause: e));
    }
  }
}

/// Riverpod provider — callers must supply a [InAppWebViewController].
final pdfRepositoryProvider = Provider.family<PdfRepository, InAppWebViewController>(
  (ref, controller) => PdfRepositoryImpl(webController: controller),
);
