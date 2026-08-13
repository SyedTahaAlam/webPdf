// lib/features/ads/data/admob_service.dart

import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webpdf/core/config/ad_config.dart';
import 'package:webpdf/core/error/error_logger.dart';

/// Thin wrapper around Google Mobile Ads SDK.
///
/// Ad failures are always silently logged — they never bubble up as user errors.
class AdmobService {
  AdmobService._();
  static final AdmobService instance = AdmobService._();

  // ── Initialisation ────────────────────────────────────────────────────────

  /// Initialises the AdMob SDK. Should be called once from [bootstrap].
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // ── Banner ────────────────────────────────────────────────────────────────

  /// Creates and loads a banner ad.
  ///
  /// Returns null if the ad fails to load — callers must handle null gracefully.
  Future<BannerAd?> loadBanner({
    required void Function(BannerAd ad) onLoaded,
    required void Function(BannerAd ad, LoadAdError error) onFailed,
  }) async {
    final adUnitId =
        Platform.isAndroid ? AdConfig.androidBannerId : AdConfig.iosBannerId;

    final ad = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onLoaded(ad as BannerAd),
        onAdFailedToLoad: (ad, error) {
          ErrorLogger.instance.logAdFailure(adUnitId, error);
          onFailed(ad as BannerAd, error);
          ad.dispose();
        },
      ),
    );

    await ad.load();
    return ad;
  }

  // ── Interstitial ──────────────────────────────────────────────────────────

  /// Loads an interstitial ad. [onLoaded] is called when ready.
  Future<void> loadInterstitial({
    required void Function(InterstitialAd ad) onLoaded,
  }) async {
    final adUnitId = Platform.isAndroid
        ? AdConfig.androidInterstitialId
        : AdConfig.iosInterstitialId;

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: onLoaded,
        onAdFailedToLoad: (error) {
          ErrorLogger.instance.logAdFailure(adUnitId, error);
          // Silently ignored — not surfaced to the user.
        },
      ),
    );
  }
}
