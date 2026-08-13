// lib/features/ads/domain/ad_placement.dart

/// Identifies where in the app an ad is displayed.
enum AdPlacement {
  /// Bottom-anchored banner on the Home / URL-input screen.
  homeBanner,

  /// Bottom-anchored banner on the History screen.
  historyBanner,

  /// Full-screen interstitial shown after a successful conversion.
  postConversionInterstitial,
}
