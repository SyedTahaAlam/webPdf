// lib/core/widgets/app_button.dart

import 'package:flutter/material.dart';
import 'package:webpdf/core/theme/app_spacing.dart';

enum AppButtonVariant { filled, outlined, text }

/// Design-system button with press-feedback animation.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.filled,
    this.leading,
    this.isLoading = false,
    this.width,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? leading;
  final bool isLoading;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label),
            ],
          );

    Widget button = switch (variant) {
      AppButtonVariant.filled => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      AppButtonVariant.outlined => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
    };

    if (width != null) {
      button = SizedBox(width: width, child: button);
    }

    return button;
  }
}
