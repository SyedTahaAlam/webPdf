# WebPdf

Convert any website into a PDF document — right on your phone.

---

## Table of Contents

- [Features](#features)
- [Architecture Overview](#architecture-overview)
- [Folder Structure](#folder-structure)
- [Getting Started](#getting-started)
- [Environment Configuration](#environment-configuration)
- [Swapping AdMob IDs](#swapping-admob-ids)
- [Running Tests](#running-tests)
- [Build & Release](#build--release)

---

## Features

| Mode | Description |
|---|---|
| **Full Page** | Loads the URL, scrolls through the entire page, stitches viewport screenshots into a single PDF |
| **Select Section** | Injects a tap-to-select script into the WebView; only the tapped element is converted |

Additional capabilities:
- History screen (list, preview, rename, share, delete)
- Dark mode with manual override in Settings
- 3-slide onboarding for first-time users
- Bottom-banner AdMob ads on Home + History screens
- Frequency-capped interstitials (every 3 conversions) after successful PDF generation
- Firebase Crashlytics + Analytics integration
- Offline-first resilience with connectivity checks and retry logic

---

## Architecture Overview

The project follows **Clean Architecture** with a feature-based folder layout:

```
Presentation ──► Application (Riverpod controllers/state)
                     │
                     ▼
              Domain (entities, repository interfaces)
                     │
                     ▼
               Data (repository impls, services)
```

State management is handled exclusively by **Riverpod** (`StateNotifier` + `Provider`).

Dependency injection is done via **Riverpod `ProviderScope` overrides** in `bootstrap.dart`.

---

## Folder Structure

```
lib/
├── main.dart                    # Entry point → bootstrap()
├── app.dart                     # MaterialApp with theme + router
├── bootstrap.dart               # Service init, ProviderScope overrides, runZonedGuarded
├── core/
│   ├── config/                  # env_config, ad_config, app_constants
│   ├── error/                   # app_exception, result, error_logger
│   ├── network/                 # connectivity_service
│   ├── theme/                   # app_colors, app_typography, app_spacing, app_theme
│   ├── widgets/                 # Shared design-system widgets
│   ├── router/                  # app_router (named routes)
│   └── utils/                   # url_validator, file_size_formatter, debouncer
└── features/
    ├── onboarding/              # 3-slide intro
    ├── pdf_conversion/          # URL input, WebView, JS bridge, PDF generator
    ├── history/                 # Hive-backed PDF history
    ├── ads/                     # AdMob banner + interstitial, frequency capper
    └── settings/                # Theme override, Privacy Policy
```

---

## Getting Started

### Prerequisites

- Flutter ≥ 3.22.0
- Dart ≥ 3.4.0
- A Firebase project (for Crashlytics + Analytics)
- An AdMob account (ads use test IDs by default)

### Setup

```bash
# 1. Clone
git clone https://github.com/SyedTahaAlam/webPdf.git
cd webPdf

# 2. Install dependencies
flutter pub get

# 3. Generate Hive adapters (already committed; re-run if models change)
dart run build_runner build --delete-conflicting-outputs

# 4. Add your google-services.json (Android) and GoogleService-Info.plist (iOS)
#    to android/app/ and ios/Runner/ respectively.

# 5. Run
flutter run --dart-define=ENV=dev
```

---

## Environment Configuration

Pass `--dart-define=ENV=<value>` at build time:

| Value | Effect |
|---|---|
| `dev` | Test AdMob IDs, verbose logging |
| `staging` | Test AdMob IDs, warning-level logging |
| `prod` | Real AdMob IDs, Crashlytics errors forwarded, minimal logging |

---

## Swapping AdMob IDs

1. Open `lib/core/config/ad_config.dart`.
2. Replace the `_androidBannerProd`, `_androidInterstitialProd`, `_iosBannerProd`, `_iosInterstitialProd` constants with your real AdMob unit IDs.
3. Update `androidAppId` and `iosAppId` with your real App IDs.
4. Update the `GADApplicationIdentifier` in `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist`.
5. Build with `--dart-define=ENV=prod`.

---

## Running Tests

```bash
# All tests
flutter test

# Unit tests only
flutter test test/unit/

# Widget tests
flutter test test/widget/
```

---

## Build & Release

```bash
# Android release APK
flutter build apk --release --dart-define=ENV=prod

# Android App Bundle (Play Store)
flutter build appbundle --release --dart-define=ENV=prod

# iOS
flutter build ipa --release --dart-define=ENV=prod
```