// lib/features/pdf_conversion/presentation/screens/section_selector_screen.dart

import 'package:flutter/material.dart';
import 'package:webpdf/core/theme/app_spacing.dart';

/// Placeholder screen shown when the user has entered section-select mode.
/// The actual selection happens inside [WebViewScreen] via JS injection.
class SectionSelectorScreen extends StatelessWidget {
  const SectionSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Section')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.touch_app_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Touch and drag to draw a selection box over the page.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
