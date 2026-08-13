// lib/features/pdf_conversion/data/services/js_bridge_service.dart
//
// Isolates all JavaScript injected into the WebView for section selection.
// All DOM-interaction logic lives here so it is independently testable.

/// Provides JavaScript snippets for the in-app WebView.
class JsBridgeService {
  const JsBridgeService();

  // ── Selection highlight ──────────────────────────────────────────────────

  /// JS that injects a tap-to-select listener onto every visible element.
  ///
  /// When the user taps an element the script posts a JSON message back via
  /// `window.flutter_inappwebview.callHandler('onElementSelected', payload)`.
  static const String injectSelectionListener = r'''
(function() {
  const HIGHLIGHT_ID = '__webpdf_highlight__';

  function clearHighlight() {
    const old = document.getElementById(HIGHLIGHT_ID);
    if (old) old.remove();
  }

  function highlightElement(el) {
    clearHighlight();
    const rect = el.getBoundingClientRect();
    const overlay = document.createElement('div');
    overlay.id = HIGHLIGHT_ID;
    overlay.style.cssText = [
      'position:fixed',
      'pointer-events:none',
      'z-index:2147483647',
      'box-sizing:border-box',
      'border:2px solid #1A73E8',
      'background:rgba(26,115,232,0.12)',
      'border-radius:2px',
      'top:'    + rect.top    + 'px',
      'left:'   + rect.left   + 'px',
      'width:'  + rect.width  + 'px',
      'height:' + rect.height + 'px',
    ].join(';');
    document.body.appendChild(overlay);
    return {
      top:    rect.top    + window.scrollY,
      left:   rect.left   + window.scrollX,
      width:  rect.width,
      height: rect.height,
    };
  }

  document.addEventListener('click', function(e) {
    e.preventDefault();
    e.stopPropagation();
    const rect = highlightElement(e.target);
    if (window.flutter_inappwebview) {
      window.flutter_inappwebview.callHandler(
        'onElementSelected',
        JSON.stringify(rect)
      );
    }
  }, true);

  // Signal to Flutter that the script loaded successfully.
  if (window.flutter_inappwebview) {
    window.flutter_inappwebview.callHandler('onSelectionReady', 'true');
  }
})();
''';

  // ── Full-page dimensions ─────────────────────────────────────────────────

  /// Returns the full scrollable dimensions of the current page as JSON:
  /// `{ "width": <px>, "height": <px>, "viewportHeight": <px> }`.
  static const String getFullPageDimensions = r'''
(function() {
  return JSON.stringify({
    width:          Math.max(document.body.scrollWidth,  document.documentElement.scrollWidth),
    height:         Math.max(document.body.scrollHeight, document.documentElement.scrollHeight),
    viewportHeight: window.innerHeight || document.documentElement.clientHeight,
  });
})();
''';

  // ── Scroll-to position ────────────────────────────────────────────────────

  /// Scrolls the page to the given [y] offset (integer, in pixels).
  static String scrollToY(int y) => 'window.scrollTo(0, $y);';

  // ── Cleanup ───────────────────────────────────────────────────────────────

  /// Removes the selection highlight overlay.
  static const String clearSelectionHighlight = r'''
(function() {
  const el = document.getElementById('__webpdf_highlight__');
  if (el) el.remove();
})();
''';
}
