# Changelog

All notable changes to WebPdf will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] – Initial Release

### Added
- **Full Page to PDF** mode: captures entire scrollable page via viewport stitching.
- **Select Section to PDF** mode: JS-injected tap-to-select with element bounding-box capture.
- URL input screen with validation and auto-prepend of `https://`.
- In-app WebView (flutter_inappwebview) with load progress indicator.
- Mode toggle (segmented control) between Full Page and Select Section.
- PDF generation using the `pdf` + `printing` packages.
- Local PDF storage with custom naming, preview (PdfPreview), and share (share_plus).
- History screen: list, rename, delete, re-share saved PDFs (Hive persistence).
- Material 3 design system: colour palette, typography scale (Poppins + Roboto), 4-pt spacing grid.
- Dark mode with system-detection and manual override in Settings.
- Shimmer loading placeholders (shimmer package).
- Smooth page transitions and micro-interactions.
- Empty states and error states with retry buttons.
- 3-slide onboarding for first-time users.
- Banner ads (AdMob) on Home and History screens — no ads in WebView.
- Frequency-capped interstitial ads (every 3 conversions, 3-second delay).
- GDPR consent notice linking to the Privacy Policy screen.
- Firebase Crashlytics and Firebase Analytics integration.
- Global error boundary via `runZonedGuarded` + `FlutterError.onError`.
- Centralised `Result<T>` / `AppException` error-handling pattern.
- Connectivity check before WebView loads / conversions.
- Clean Architecture with feature-based folder structure.
- Riverpod state management.
- Unit tests: URL validator, frequency capper, file size formatter.
- `analysis_options.yaml` configured with `very_good_analysis`.
- Environment-based configuration (`--dart-define=ENV=dev|staging|prod`).
- Android `AndroidManifest.xml` with AdMob App ID and storage permissions.
- iOS `Info.plist` with `GADApplicationIdentifier`, ATT usage description, and WebView ATS settings.
- README with setup, architecture notes, and AdMob swap instructions.
