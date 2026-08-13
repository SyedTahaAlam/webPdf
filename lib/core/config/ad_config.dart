// lib/core/config/ad_config.dart

import 'package:webpdf/core/config/env_config.dart';

/// AdMob unit IDs — test IDs used in dev/staging, real IDs in prod.
/// Replace prod values with your real AdMob unit IDs before release.
class AdConfig {
  AdConfig._();

  // ── Android IDs ────────────────────────────────────────────────────────────
  static const String _androidBannerTest =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _androidInterstitialTest =
      'ca-app-pub-3940256099942544/1033173712';

  // TODO(dev): Replace with real Android AdMob unit IDs for production.
  static const String _androidBannerProd = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String _androidInterstitialProd =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

  // ── iOS IDs ────────────────────────────────────────────────────────────────
  static const String _iosBannerTest =
      'ca-app-pub-3940256099942544/2934735716';
  static const String _iosInterstitialTest =
      'ca-app-pub-3940256099942544/4411468910';

  // TODO(dev): Replace with real iOS AdMob unit IDs for production.
  static const String _iosBannerProd = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String _iosInterstitialProd =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

  // ── Resolved IDs ──────────────────────────────────────────────────────────
  static String get androidBannerId =>
      EnvConfig.isProd ? _androidBannerProd : _androidBannerTest;

  static String get androidInterstitialId =>
      EnvConfig.isProd ? _androidInterstitialProd : _androidInterstitialTest;

  static String get iosBannerId =>
      EnvConfig.isProd ? _iosBannerProd : _iosBannerTest;

  static String get iosInterstitialId =>
      EnvConfig.isProd ? _iosInterstitialProd : _iosInterstitialTest;

  // ── App IDs ────────────────────────────────────────────────────────────────
  /// Test AdMob App ID (Android). Replace with real App ID for production.
  static const String androidAppId = 'ca-app-pub-3940256099942544~3347511713';

  /// Test AdMob App ID (iOS). Replace with real App ID for production.
  static const String iosAppId = 'ca-app-pub-3940256099942544~1458002511';

  // ── Frequency capping ─────────────────────────────────────────────────────
  /// Show an interstitial once every N successful conversions.
  static const int interstitialFrequency = 3;

  /// Minimum seconds the user must be on the result screen before
  /// an interstitial is eligible to show (prevents accidental taps).
  static const int interstitialMinDelaySeconds = 3;
}
