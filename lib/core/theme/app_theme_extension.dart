// lib/core/theme/app_theme_extension.dart

import 'package:flutter/material.dart';
import 'package:webpdf/core/theme/app_colors.dart';

/// Custom theme extension to expose semantic colours not covered by [ColorScheme].
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.success,
    required this.warning,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  final Color success;
  final Color warning;
  final Color shimmerBase;
  final Color shimmerHighlight;

  static const light = AppThemeExtension(
    success: AppColors.success,
    warning: AppColors.warning,
    shimmerBase: AppColors.shimmerBase,
    shimmerHighlight: AppColors.shimmerHighlight,
  );

  static const dark = AppThemeExtension(
    success: AppColors.success,
    warning: AppColors.warning,
    shimmerBase: AppColors.shimmerBaseDark,
    shimmerHighlight: AppColors.shimmerHighlightDark,
  );

  @override
  AppThemeExtension copyWith({
    Color? success,
    Color? warning,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) =>
      AppThemeExtension(
        success: success ?? this.success,
        warning: warning ?? this.warning,
        shimmerBase: shimmerBase ?? this.shimmerBase,
        shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      );

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other == null) return this;
    return AppThemeExtension(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
    );
  }
}

/// Extension on [BuildContext] for convenient access.
extension AppThemeX on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
}
