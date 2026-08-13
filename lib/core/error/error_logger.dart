// lib/core/error/error_logger.dart

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';
import 'package:webpdf/core/config/env_config.dart';
import 'package:webpdf/core/error/app_exception.dart';

/// Centralised error and diagnostic logger.
///
/// - In dev/staging: pretty-prints to console.
/// - In prod: forwards to Firebase Crashlytics (non-fatal).
class ErrorLogger {
  ErrorLogger._()
      : _logger = Logger(
          printer: EnvConfig.verboseLogging
              ? PrettyPrinter(methodCount: 3)
              : SimplePrinter(),
          level: EnvConfig.verboseLogging ? Level.trace : Level.warning,
        );

  static final ErrorLogger instance = ErrorLogger._();

  final Logger _logger;

  /// Log an informational message.
  void info(String message) => _logger.i(message);

  /// Log a warning.
  void warning(String message) => _logger.w(message);

  /// Log a non-fatal error with optional stack trace.
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    if (EnvConfig.isProd) {
      FirebaseCrashlytics.instance.recordError(
        error ?? Exception(message),
        stackTrace,
        reason: message,
        fatal: false,
      );
    }
  }

  /// Log an [AppException] — convenience overload.
  void logException(AppException exception, {StackTrace? stackTrace}) {
    error(exception.message, error: exception.cause, stackTrace: stackTrace);
  }

  /// Silently log an ad failure — never surfaced as a user-facing error.
  void logAdFailure(String adUnitId, Object? error) {
    _logger.w('Ad failed to load [$adUnitId]: $error');
    // Intentionally not forwarded to Crashlytics to keep ad noise separate.
  }
}
