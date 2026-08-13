// test/unit/interstitial_frequency_capper_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webpdf/features/ads/application/interstitial_frequency_capper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InterstitialFrequencyCapper', () {
    late SharedPreferences prefs;
    late InterstitialFrequencyCapper capper;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      capper = InterstitialFrequencyCapper(prefs);
    });

    test('shouldShowInterstitial is false when counter is 0', () {
      expect(capper.shouldShowInterstitial, isFalse);
    });

    test('shouldShowInterstitial is false before reaching frequency', () async {
      await capper.increment();
      await capper.increment();
      expect(capper.shouldShowInterstitial, isFalse);
    });

    test('shouldShowInterstitial is true at frequency boundary', () async {
      // AdConfig.interstitialFrequency == 3
      await capper.increment();
      await capper.increment();
      await capper.increment();
      expect(capper.shouldShowInterstitial, isTrue);
    });

    test('reset sets counter back to 0', () async {
      await capper.increment();
      await capper.increment();
      await capper.increment();
      await capper.reset();
      expect(capper.shouldShowInterstitial, isFalse);
    });
  });
}
