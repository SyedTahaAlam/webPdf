// lib/features/pdf_conversion/data/repositories/pdf_repository_impl.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webpdf/core/error/app_exception.dart';
import 'package:webpdf/core/error/result.dart';
import 'package:webpdf/features/pdf_conversion/data/services/js_bridge_service.dart';
import 'package:webpdf/features/pdf_conversion/data/services/pdf_generator_service.dart';
import 'package:webpdf/features/pdf_conversion/data/services/webview_capture_service.dart';
import 'package:webpdf/features/pdf_conversion/domain/entities/conversion_mode.dart';
import 'package:webpdf/features/pdf_conversion/domain/entities/conversion_request.dart';
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

    // Scroll to the section position.
    final scrollY = rect['top']?.toInt() ?? 0;
    await _capture.evaluateJs(
      _webController,
      JsBridgeService.scrollToY(scrollY),
    );
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Capture viewport (the selected element should now be in view).
    final shotResult = await _capture.captureViewport(_webController);
    if (shotResult.isLeft()) {
      return failure(shotResult.fold((exception) => exception, (_) => const CaptureException()));
    }

    final screenshot = shotResult.getOrElse(() => Uint8List(0));

    // Build a single-page PDF.
    return _generator.generatePdf(
      imagePages: [screenshot],
      customName: request.customName,
    );
  }
}

/// Riverpod provider — callers must supply a [InAppWebViewController].
final pdfRepositoryProvider = Provider.family<PdfRepository, InAppWebViewController>(
  (ref, controller) => PdfRepositoryImpl(webController: controller),
);
