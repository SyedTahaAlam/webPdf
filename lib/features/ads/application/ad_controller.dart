// lib/features/ads/application/ad_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webpdf/core/config/ad_config.dart';
import 'package:webpdf/features/ads/application/interstitial_frequency_capper.dart';
import 'package:webpdf/features/ads/data/admob_service.dart';

/// Manages interstitial ad lifecycle: pre-loading, frequency cap, and showing.
class AdController extends StateNotifier<InterstitialAd?> {
  AdController(this._ref) : super(null) {
    _preload();
  }

  final Ref _ref;

  void _preload() {
    AdmobService.instance.loadInterstitial(
      onLoaded: (ad) {
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (_) {
            state = null;
            _preload(); // pre-load next
          },
          onAdFailedToShowFullScreenContent: (ad, _) {
            ad.dispose();
            state = null;
            _preload();
          },
        );
        state = ad;
      },
    );
  }

  /// Shows the interstitial if loaded and frequency cap permits it.
  ///
  /// Includes a [AdConfig.interstitialMinDelaySeconds]-second delay to prevent
  /// accidental taps immediately after conversion.
  Future<void> maybeShow() async {
    final capper = _ref.read(interstitialFrequencyCapperProvider);
    if (!capper.shouldShowInterstitial) return;

    final ad = state;
    if (ad == null) return;

    await Future<void>.delayed(
      Duration(seconds: AdConfig.interstitialMinDelaySeconds),
    );

    await ad.show();
    await capper.reset();
  }

  @override
  void dispose() {
    state?.dispose();
    super.dispose();
  }
}

final adControllerProvider = StateNotifierProvider<AdController, InterstitialAd?>(
  (ref) => AdController(ref),
);
