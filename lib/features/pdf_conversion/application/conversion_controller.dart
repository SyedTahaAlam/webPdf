// lib/features/pdf_conversion/application/conversion_controller.dart

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webpdf/core/error/error_logger.dart';
import 'package:webpdf/core/network/connectivity_service.dart';
import 'package:webpdf/features/ads/application/interstitial_frequency_capper.dart';
import 'package:webpdf/features/history/data/history_repository_impl.dart';
import 'package:webpdf/features/history/domain/pdf_document.dart';
import 'package:webpdf/features/pdf_conversion/application/conversion_state.dart';
import 'package:webpdf/features/pdf_conversion/data/repositories/pdf_repository_impl.dart';
import 'package:webpdf/features/pdf_conversion/domain/entities/conversion_mode.dart';
import 'package:webpdf/features/pdf_conversion/domain/entities/conversion_request.dart';
import 'package:webpdf/features/pdf_conversion/domain/entities/selection_rect.dart';

/// Controls the full PDF conversion workflow.
class ConversionController extends StateNotifier<ConversionState> {
  ConversionController(this._ref) : super(const ConversionIdle());

  final Ref _ref;

  InAppWebViewController? _webController;
  ConversionMode _mode = ConversionMode.selectSection;
  SelectionRect? _selectedRect;
  SelectionRect? _pendingRect;

  // ── Public API ────────────────────────────────────────────────────────────

  ConversionMode get mode => _mode;

  void setMode(ConversionMode mode) {
    _mode = mode;
    _selectedRect = null;
    _pendingRect = null;
  }

  void onWebViewReady(InAppWebViewController controller) {
    _webController = controller;
  }

  void onPageLoadStarted() => state = const ConversionLoadingPage();

  void onPageLoadFinished() {
    if (_mode == ConversionMode.selectSection) {
      state = const ConversionAwaitingSelection();
    } else {
      state = const ConversionIdle();
    }
  }

  void onSectionSelected(SelectionRect rect) {
    if (!rect.hasValidSize) {
      state = const ConversionAwaitingSelection(
        message: 'Please drag to select a valid area.',
      );
      return;
    }

    if (!rect.isWithinViewport) {
      state = const ConversionAwaitingSelection(
        message: 'Selection must stay within the visible area. Scroll first, then reselect.',
      );
      return;
    }

    _pendingRect = rect;
    state = ConversionSelectionPending(rect);
  }

  void confirmSectionSelection() {
    if (_pendingRect == null) return;
    _selectedRect = _pendingRect;
    _pendingRect = null;
    state = const ConversionIdle();
  }

  void reselectSection() {
    _selectedRect = null;
    _pendingRect = null;
    state = const ConversionAwaitingSelection();
  }

  Future<void> startConversion({String? customName}) async {
    final controller = _webController;
    if (controller == null) {
      state = const ConversionFailure('WebView not ready. Please load a URL first.');
      return;
    }

    if (_mode == ConversionMode.selectSection) {
      if (_pendingRect != null) {
        state = const ConversionAwaitingSelection(
          message: 'Confirm your selected area before converting.',
        );
        return;
      }
      if (_selectedRect == null) {
        state = const ConversionAwaitingSelection(
          message: 'Drag to select an area first.',
        );
        return;
      }
    }

    // ── Connectivity check ─────────────────────────────────────────────────
    final connectivity = _ref.read(connectivityServiceProvider);
    if (!await connectivity.isConnected) {
      state = const ConversionFailure(
        'No internet connection. Please check your network settings.',
      );
      return;
    }

    state = const ConversionGenerating();

    final request = ConversionRequest(
      url: '', // URL already loaded in WebView
      mode: _mode,
      selectedRect: _selectedRect,
      customName: customName,
    );

    final repo = _ref.read(pdfRepositoryProvider(controller));
    final result = await repo.convertToPdf(request);

    result.fold(
      (error) {
        ErrorLogger.instance.logException(error);
        state = ConversionFailure(error.message);
      },
      (filePath) async {
        // Save to history.
        await _saveToHistory(filePath);
        // Increment interstitial counter.
        await _ref.read(interstitialFrequencyCapperProvider).increment();
        state = ConversionSuccess(filePath);
      },
    );
  }

  void reset() {
    _selectedRect = null;
    _pendingRect = null;
    state = const ConversionIdle();
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  Future<void> _saveToHistory(String filePath) async {
    try {
      final repo = _ref.read(historyRepositoryProvider);
      final doc = PdfDocument.fromPath(filePath);
      await repo.addDocument(doc);
    } catch (e) {
      ErrorLogger.instance.error('Failed to save to history', error: e);
    }
  }
}

/// Riverpod provider.
final conversionControllerProvider =
    StateNotifierProvider<ConversionController, ConversionState>(
  (ref) => ConversionController(ref),
);
