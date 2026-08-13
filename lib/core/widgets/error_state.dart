// lib/core/widgets/error_state.dart

import 'package:flutter/material.dart';
import 'package:webpdf/core/theme/app_spacing.dart';
import 'package:webpdf/core/widgets/app_button.dart';

/// Error state widget with retry button.
class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.message,
    super.key,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Something went wrong',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Retry',
                onPressed: onRetry,
                width: 180,
                leading: const Icon(Icons.refresh),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
