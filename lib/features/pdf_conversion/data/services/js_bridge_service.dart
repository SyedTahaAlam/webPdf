// lib/features/pdf_conversion/data/services/js_bridge_service.dart
//
// Isolates all JavaScript injected into the WebView for section selection.
// All DOM-interaction logic lives here so it is independently testable.

/// Provides JavaScript snippets for the in-app WebView.
class JsBridgeService {
  const JsBridgeService();

  // ── Drag-box selection ───────────────────────────────────────────────────

  /// JS that injects a drag-to-draw selection rectangle on touch devices.
  static const String injectSelectionListener = r'''
(function() {
  const OVERLAY_ID = '__webpdf_drag_overlay__';
  const ROOT = document.documentElement;
  const BODY = document.body;

  if (window.__webpdfSelectionInstalled__) return;
  window.__webpdfSelectionInstalled__ = true;

  let startX = 0;
  let startY = 0;
  let dragging = false;
  let overlay = null;
  let previousRootOverflow = '';
  let previousBodyOverflow = '';

  function lockScroll() {
    previousRootOverflow = ROOT.style.overflow;
    previousBodyOverflow = BODY.style.overflow;
    ROOT.style.overflow = 'hidden';
    BODY.style.overflow = 'hidden';
  }

  function unlockScroll() {
    ROOT.style.overflow = previousRootOverflow;
    BODY.style.overflow = previousBodyOverflow;
  }

  function cleanupOverlay() {
    const old = document.getElementById(OVERLAY_ID);
    if (old) old.remove();
    overlay = null;
  }

  function ensureOverlay() {
    cleanupOverlay();
    overlay = document.createElement('div');
    overlay.id = OVERLAY_ID;
    overlay.style.cssText = [
      'position:fixed',
      'pointer-events:none',
      'z-index:2147483647',
      'box-sizing:border-box',
      'border:2px dashed #1A73E8',
      'background:rgba(26,115,232,0.15)',
      'border-radius:2px',
    ].join(';');
    document.body.appendChild(overlay);
  }

  function updateOverlayRect(currentX, currentY) {
    if (!overlay) return;
    const left = Math.min(startX, currentX);
    const top = Math.min(startY, currentY);
    const width = Math.abs(currentX - startX);
    const height = Math.abs(currentY - startY);
    overlay.style.left = left + 'px';
    overlay.style.top = top + 'px';
    overlay.style.width = width + 'px';
    overlay.style.height = height + 'px';
  }

  function getPoint(evt) {
    if (!evt.touches || evt.touches.length === 0) return null;
    return evt.touches[0];
  }

  document.addEventListener('touchstart', function(evt) {
    const point = getPoint(evt);
    if (!point) return;

    dragging = true;
    startX = point.clientX;
    startY = point.clientY;
    ensureOverlay();
    updateOverlayRect(startX, startY);
    lockScroll();
    evt.preventDefault();
    evt.stopPropagation();
  }, { capture: true, passive: false });

  document.addEventListener('touchmove', function(evt) {
    if (!dragging) return;
    const point = getPoint(evt);
    if (!point) return;
    updateOverlayRect(point.clientX, point.clientY);
    evt.preventDefault();
    evt.stopPropagation();
  }, { capture: true, passive: false });

  document.addEventListener('touchend', function(evt) {
    if (!dragging) return;
    dragging = false;
    unlockScroll();

    const rect = overlay ? overlay.getBoundingClientRect() : null;
    if (rect && window.flutter_inappwebview) {
      window.flutter_inappwebview.callHandler(
        'onBoxSelected',
        JSON.stringify({
          x: rect.left,
          y: rect.top,
          width: rect.width,
          height: rect.height,
          dpr: window.devicePixelRatio || 1,
          scrollX: window.scrollX || 0,
          scrollY: window.scrollY || 0,
          viewportWidth: window.innerWidth || document.documentElement.clientWidth || 0,
          viewportHeight: window.innerHeight || document.documentElement.clientHeight || 0
        })
      );
    }

    cleanupOverlay();
    evt.preventDefault();
    evt.stopPropagation();
  }, { capture: true, passive: false });
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

  /// Removes any drag selection overlay.
  static const String clearSelectionHighlight = r'''
(function() {
  const el = document.getElementById('__webpdf_drag_overlay__');
  if (el) el.remove();
})();
''';
}
