// lib/core/widgets/app_snackbar.dart

import 'package:flutter/material.dart';
import 'package:webpdf/core/theme/app_colors.dart';

/// Convenience methods for showing themed SnackBars.
class AppSnackbar {
  AppSnackbar._();

  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message,
      icon: Icons.check_circle_outline,
      backgroundColor: AppColors.success,
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message,
      icon: Icons.error_outline,
      backgroundColor: AppColors.error,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message,
      icon: Icons.info_outline,
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    IconData? icon,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
