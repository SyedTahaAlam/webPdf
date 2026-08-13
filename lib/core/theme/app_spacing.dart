// lib/core/theme/app_spacing.dart

/// 4-pt base spacing grid used throughout the design system.
abstract class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  /// Horizontal screen padding.
  static const double screenHPadding = 16;

  /// Vertical screen padding.
  static const double screenVPadding = 24;

  /// Card border radius.
  static const double cardRadius = 12;

  /// Button border radius.
  static const double buttonRadius = 10;

  /// Input field border radius.
  static const double inputRadius = 10;

  /// Icon sizes.
  static const double iconSm = 18;
  static const double iconMd = 24;
  static const double iconLg = 32;

  /// Bottom banner ad height reservation.
  static const double bannerAdHeight = 60;
}
