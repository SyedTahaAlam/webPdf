// lib/core/config/env_config.dart
// Reads --dart-define=ENV=dev|staging|prod at build time.

/// Environment configuration read from --dart-define at compile time.
class EnvConfig {
  EnvConfig._();

  static const String _env =
      String.fromEnvironment('ENV', defaultValue: 'dev');

  static bool get isDev => _env == 'dev';
  static bool get isStaging => _env == 'staging';
  static bool get isProd => _env == 'prod';

  static String get envName => _env;

  /// Logging verbosity: verbose in dev, warnings only in prod.
  static bool get verboseLogging => isDev || isStaging;
}
