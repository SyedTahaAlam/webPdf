// lib/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webpdf/core/config/app_constants.dart';
import 'package:webpdf/core/router/app_router.dart';
import 'package:webpdf/core/theme/app_theme.dart';
import 'package:webpdf/core/theme/app_theme_extension.dart';
import 'package:webpdf/features/settings/application/settings_controller.dart';

/// Root [MaterialApp] wired to Riverpod providers.
class WebPdfApp extends ConsumerWidget {
  const WebPdfApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsControllerProvider);

    final lightTheme = AppTheme.light.copyWith(
      extensions: const [AppThemeExtension.light],
    );
    final darkTheme = AppTheme.dark.copyWith(
      extensions: const [AppThemeExtension.dark],
    );

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
