// lib/features/settings/presentation/screens/privacy_policy_screen.dart

import 'package:flutter/material.dart';
import 'package:webpdf/core/theme/app_spacing.dart';

/// Inline privacy policy screen.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenHPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Last updated: ${DateTime.now().year}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            _section(
              context,
              'Data Collection',
              'WebPdf does not collect personally identifiable information. '
                  'PDFs are stored locally on your device and are never uploaded '
                  'to any server.',
            ),
            _section(
              context,
              'Advertising',
              'WebPdf uses Google AdMob to display advertisements. '
                  'AdMob may use cookies or device identifiers to serve '
                  'personalised ads. You can opt out via your device ad settings.',
            ),
            _section(
              context,
              'Analytics',
              'We use Firebase Analytics to understand how the app is used. '
                  'No personally identifiable data is collected.',
            ),
            _section(
              context,
              'Crash Reporting',
              'Firebase Crashlytics collects anonymous crash reports to help us '
                  'improve app stability.',
            ),
            _section(
              context,
              'Contact',
              'For privacy questions, contact: privacy@taha.dev',
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(body, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
