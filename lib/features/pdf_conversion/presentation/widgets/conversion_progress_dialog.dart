// lib/features/pdf_conversion/presentation/widgets/conversion_progress_dialog.dart

import 'package:flutter/material.dart';
import 'package:webpdf/core/theme/app_spacing.dart';

/// Modal progress dialog shown during PDF generation.
class ConversionProgressDialog extends StatelessWidget {
  const ConversionProgressDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ConversionProgressDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Generating PDF…',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'This may take a moment for long pages.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
