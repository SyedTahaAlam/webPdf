// lib/core/config/app_constants.dart

/// Application-wide constant values.
class AppConstants {
  AppConstants._();

  static const String appName = 'WebPdf';
  static const String packageName = 'com.taha.webpdf';

  /// Default file name prefix for saved PDFs.
  static const String pdfFilePrefix = 'webpdf_';

  /// PDF file extension.
  static const String pdfExtension = '.pdf';

  /// SharedPreferences / Hive key for onboarding completion flag.
  static const String onboardingCompleteKey = 'onboarding_complete';

  /// SharedPreferences key for manual theme override.
  static const String themeModeKey = 'theme_mode';

  /// Hive box name for PDF history.
  static const String historyBoxName = 'pdf_history';

  /// SharedPreferences key for interstitial counter.
  static const String interstitialCounterKey = 'interstitial_counter';

  /// Timeout in seconds for WebView page load.
  static const int webViewTimeoutSeconds = 30;

  /// Maximum URL length accepted by the input field.
  static const int maxUrlLength = 2048;

  /// Exponential backoff: base delay in milliseconds for retries.
  static const int retryBaseDelayMs = 500;

  /// Maximum number of automatic retries.
  static const int maxRetries = 3;
}
