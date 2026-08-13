// lib/core/router/app_router.dart

import 'package:flutter/material.dart';
import 'package:webpdf/features/history/presentation/screens/history_screen.dart';
import 'package:webpdf/features/history/presentation/screens/pdf_preview_screen.dart';
import 'package:webpdf/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:webpdf/features/pdf_conversion/presentation/screens/url_input_screen.dart';
import 'package:webpdf/features/pdf_conversion/presentation/screens/webview_screen.dart';
import 'package:webpdf/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:webpdf/features/settings/presentation/screens/settings_screen.dart';

/// Named route constants.
class AppRoutes {
  AppRoutes._();

  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String webview = '/webview';
  static const String history = '/history';
  static const String pdfPreview = '/pdf-preview';
  static const String settings = '/settings';
  static const String privacyPolicy = '/privacy-policy';
}

/// Application route generator.
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return _fadeRoute(const OnboardingScreen(), settings);

      case AppRoutes.home:
        return _fadeRoute(const UrlInputScreen(), settings);

      case AppRoutes.webview:
        final url = settings.arguments as String;
        return _slideRoute(WebViewScreen(url: url), settings);

      case AppRoutes.history:
        return _fadeRoute(const HistoryScreen(), settings);

      case AppRoutes.pdfPreview:
        final path = settings.arguments as String;
        return _slideRoute(PdfPreviewScreen(filePath: path), settings);

      case AppRoutes.settings:
        return _slideRoute(const SettingsScreen(), settings);

      case AppRoutes.privacyPolicy:
        return _slideRoute(const PrivacyPolicyScreen(), settings);

      default:
        return _fadeRoute(const UrlInputScreen(), settings);
    }
  }

  static PageRouteBuilder<T> _fadeRoute<T>(
    Widget page,
    RouteSettings settings,
  ) =>
      PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      );

  static PageRouteBuilder<T> _slideRoute<T>(
    Widget page,
    RouteSettings settings,
  ) =>
      PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      );
}
