// lib/features/ads/presentation/widgets/consent_dialog.dart

import 'package:flutter/material.dart';
import 'package:webpdf/core/router/app_router.dart';
import 'package:webpdf/core/theme/app_spacing.dart';
import 'package:webpdf/core/widgets/app_button.dart';

/// Simple GDPR consent notice linking to the privacy policy.
class ConsentDialog extends StatelessWidget {
  const ConsentDialog({super.key});

  static Future<void> showIfNeeded(BuildContext context) async {
    // In production, integrate Google UMP SDK here.
    // For now we show a one-time notice.
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ConsentDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Privacy & Ads'),
      content: const Text(
        'WebPdf shows ads to support free access. '
        'We use Google AdMob which may personalise ads '
        'based on your interests. You can review our privacy policy below.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context)
              .pushNamed(AppRoutes.privacyPolicy),
          child: const Text('Privacy Policy'),
        ),
        AppButton(
          label: 'Accept',
          onPressed: () => Navigator.of(context).pop(),
          width: 120,
        ),
      ],
    );
  }
}
