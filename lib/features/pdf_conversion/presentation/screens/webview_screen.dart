// lib/features/pdf_conversion/presentation/screens/webview_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webpdf/core/theme/app_spacing.dart';
import 'package:webpdf/core/widgets/app_snackbar.dart';
import 'package:webpdf/features/ads/application/ad_controller.dart';
import 'package:webpdf/features/pdf_conversion/application/conversion_controller.dart';
import 'package:webpdf/features/pdf_conversion/application/conversion_state.dart';
import 'package:webpdf/features/pdf_conversion/data/services/js_bridge_service.dart';
import 'package:webpdf/features/pdf_conversion/domain/entities/conversion_mode.dart';
import 'package:webpdf/features/pdf_conversion/presentation/widgets/conversion_progress_dialog.dart';

/// Screen that renders the target URL in an in-app WebView and allows the user
/// to trigger full-page or section-based PDF conversion.
class WebViewScreen extends ConsumerStatefulWidget {
  const WebViewScreen({required this.url, super.key});

  final String url;

  @override
  ConsumerState<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  InAppWebViewController? _webViewController;
  double _progress = 0;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    // Watch conversion state changes for side-effects.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(conversionControllerProvider, _onStateChange);
    });
  }

  void _onStateChange(ConversionState? prev, ConversionState next) {
    if (next is ConversionGenerating && !_dialogShown) {
      _dialogShown = true;
      ConversionProgressDialog.show(context);
    }

    if (next is ConversionSuccess) {
      if (_dialogShown) {
        Navigator.of(context).pop(); // dismiss progress dialog
        _dialogShown = false;
      }
      AppSnackbar.showSuccess(context, 'PDF saved successfully!');
      // Maybe show interstitial (fires after delay, frequency capped).
      ref.read(adControllerProvider.notifier).maybeShow();
      Navigator.of(context).pop(); // back to home
    }

    if (next is ConversionFailure) {
      if (_dialogShown) {
        Navigator.of(context).pop();
        _dialogShown = false;
      }
      AppSnackbar.showError(context, next.message);
    }
  }

  Future<void> _injectSelectionScript() async {
    final ctrl = _webViewController;
    if (ctrl == null) return;
    await ctrl.evaluateJavascript(
      source: JsBridgeService.injectSelectionListener,
    );
  }

  @override
  Widget build(BuildContext context) {
    final convCtrl = ref.read(conversionControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.url,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Convert to PDF',
            onPressed: () async => convCtrl.startConversion(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: _progress < 1
              ? LinearProgressIndicator(value: _progress)
              : const SizedBox.shrink(),
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          supportZoom: true,
          useWideViewPort: true,
          loadWithOverviewMode: true,
          domStorageEnabled: true,
          databaseEnabled: true,
        ),
        onWebViewCreated: (ctrl) {
          _webViewController = ctrl;
          convCtrl.onWebViewReady(ctrl);

          // Register JS→Flutter handler for element selection.
          ctrl.addJavaScriptHandler(
            handlerName: 'onElementSelected',
            callback: (args) {
              try {
                final json =
                    jsonDecode(args.first.toString()) as Map<String, dynamic>;
                convCtrl.onSectionSelected({
                  'top': (json['top'] as num).toDouble(),
                  'left': (json['left'] as num).toDouble(),
                  'width': (json['width'] as num).toDouble(),
                  'height': (json['height'] as num).toDouble(),
                });
              } catch (_) {
                // Defensive: ignore malformed JS payload.
              }
              return null;
            },
          );

          ctrl.addJavaScriptHandler(
            handlerName: 'onSelectionReady',
            callback: (_) => null,
          );
        },
        onLoadStart: (_, __) => convCtrl.onPageLoadStarted(),
        onLoadStop: (ctrl, __) async {
          convCtrl.onPageLoadFinished();
          final mode = convCtrl.mode;
          if (mode == ConversionMode.selectSection) {
            await _injectSelectionScript();
          }
          setState(() => _progress = 1);
        },
        onProgressChanged: (_, progress) {
          setState(() => _progress = progress / 100);
        },
        onReceivedError: (_, __, error) {
          AppSnackbar.showError(
            context,
            'Failed to load page: ${error.description}',
          );
        },
      ),
    );
  }
}
