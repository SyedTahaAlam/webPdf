// lib/features/ads/application/interstitial_frequency_capper.dart
//
// Persists a conversion counter and decides when to show an interstitial.
// Logic is isolated here so it can be unit-tested without the AdMob SDK.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webpdf/core/config/ad_config.dart';
import 'package:webpdf/core/config/app_constants.dart';

/// Tracks successful conversions and exposes [shouldShowInterstitial].
///
/// The counter is persisted in [SharedPreferences] so it survives app restarts.
class InterstitialFrequencyCapper {
  InterstitialFrequencyCapper(this._prefs);

  final SharedPreferences _prefs;

  int get _counter =>
      _prefs.getInt(AppConstants.interstitialCounterKey) ?? 0;

  /// Increments the conversion counter by 1 and persists it.
  Future<void> increment() async {
    await _prefs.setInt(AppConstants.interstitialCounterKey, _counter + 1);
  }

  /// Returns `true` when the counter has reached the configured frequency.
  bool get shouldShowInterstitial =>
      _counter > 0 && _counter % AdConfig.interstitialFrequency == 0;

  /// Resets the counter (called after an interstitial is successfully shown).
  Future<void> reset() async {
    await _prefs.setInt(AppConstants.interstitialCounterKey, 0);
  }
}

final interstitialFrequencyCapperProvider =
    Provider<InterstitialFrequencyCapper>(
  (ref) => throw UnimplementedError('Override in ProviderScope overrides'),
);
