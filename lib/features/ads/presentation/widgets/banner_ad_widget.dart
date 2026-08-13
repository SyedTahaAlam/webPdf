// lib/features/ads/presentation/widgets/banner_ad_widget.dart

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webpdf/core/theme/app_spacing.dart';
import 'package:webpdf/features/ads/data/admob_service.dart';

/// Bottom-anchored banner ad widget.
///
/// Loads silently — renders nothing if the ad fails to load.
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  Future<void> _loadAd() async {
    await AdmobService.instance.loadBanner(
      onLoaded: (ad) {
        if (!mounted) return;
        setState(() {
          _ad = ad;
          _loaded = true;
        });
      },
      onFailed: (_, __) {
        // Silently ignore — widget collapses to zero height.
      },
    );
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) return const SizedBox.shrink();

    return SizedBox(
      height: AppSpacing.bannerAdHeight,
      child: AdWidget(ad: _ad!),
    );
  }
}
