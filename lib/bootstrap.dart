// lib/bootstrap.dart
//
// Initialises all services before runApp. Called from main.dart.

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webpdf/app.dart';
import 'package:webpdf/core/config/env_config.dart';
import 'package:webpdf/core/error/error_logger.dart';
import 'package:webpdf/features/ads/application/interstitial_frequency_capper.dart';
import 'package:webpdf/features/ads/data/admob_service.dart';
import 'package:webpdf/features/history/data/hive_history_datasource.dart';
import 'package:webpdf/features/history/data/history_repository_impl.dart';
import 'package:webpdf/features/history/domain/pdf_document.dart';
import 'package:webpdf/features/settings/application/settings_controller.dart';
import 'package:webpdf/firebase_options.dart';

/// Bootstraps all singletons and returns the [ProviderScope]-wrapped app.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Preferred orientation ─────────────────────────────────────────────────
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // ── Firebase ──────────────────────────────────────────────────────────────
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // ── Global error boundary ─────────────────────────────────────────────────
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (EnvConfig.isProd) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }
    ErrorLogger.instance.error(
      details.exceptionAsString(),
      stackTrace: details.stack,
    );
  };

  // ── Hive ──────────────────────────────────────────────────────────────────
  await Hive.initFlutter();
  Hive.registerAdapter(PdfDocumentAdapter());
  final historyDs = await HiveHistoryDatasource.open();
  final historyRepo = HistoryRepositoryImpl(historyDs);

  // ── SharedPreferences ─────────────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();

  // ── AdMob ─────────────────────────────────────────────────────────────────
  await AdmobService.instance.initialize();

  // ── Run app ───────────────────────────────────────────────────────────────
  runZonedGuarded(
    () => runApp(
      ProviderScope(
        overrides: [
          historyRepositoryProvider
              .overrideWithValue(historyRepo),
          interstitialFrequencyCapperProvider
              .overrideWithValue(InterstitialFrequencyCapper(prefs)),
          settingsControllerProvider.overrideWith(
            (ref) => SettingsController(prefs),
          ),
        ],
        child: const WebPdfApp(),
      ),
    ),
    (error, stack) {
      // ErrorLogger.instance.error('Uncaught error', error: error, stackTrace: stack);
      // if (EnvConfig.isProd) {
      //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // }
    },
  );
}
