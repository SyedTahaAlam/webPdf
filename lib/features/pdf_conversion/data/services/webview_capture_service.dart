// lib/features/pdf_conversion/data/services/webview_capture_service.dart

import 'dart:typed_data';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webpdf/core/error/app_exception.dart';
import 'package:webpdf/core/error/result.dart';

/// Handles taking screenshots from the WebView controller.
class WebViewCaptureService {
  const WebViewCaptureService();

  /// Captures a screenshot of the current visible viewport.
  ///
  /// The caller is responsible for scrolling the page to the desired position
  /// before calling this method.
  Future<Result<Uint8List>> captureViewport(
    InAppWebViewController controller,
  ) async {
    try {
      final bytes = await controller.takeScreenshot(
        screenshotConfiguration: ScreenshotConfiguration(
          compressFormat: CompressFormat.PNG,
          quality: 100,
        ),
      );
      if (bytes == null || bytes.isEmpty) {
        return failure(const CaptureException());
      }
      return success(bytes);
    } catch (e) {
      return failure(CaptureException(cause: e));
    }
  }

  /// Evaluates [js] on [controller] and returns the raw result string.
  ///
  /// Returns [JsBridgeException] on script failure.
  Future<Result<String>> evaluateJs(
    InAppWebViewController controller,
    String js,
  ) async {
    try {
      final result = await controller.evaluateJavascript(source: js);
      if (result == null) {
        return failure(const JsBridgeException());
      }
      return success(result.toString());
    } catch (e) {
      return failure(JsBridgeException(cause: e));
    }
  }
}
