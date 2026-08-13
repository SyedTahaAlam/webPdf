// lib/core/utils/url_validator.dart

import 'package:webpdf/core/config/app_constants.dart';

/// Result of a URL validation check.
enum UrlValidationStatus {
  valid,
  empty,
  tooLong,
  invalidScheme,
  invalidFormat,
}

/// Validates and normalises user-supplied URLs.
class UrlValidator {
  const UrlValidator._();

  static const List<String> _allowedSchemes = ['http', 'https'];

  /// Auto-prepends `https://` if the input has no scheme.
  static String normalise(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return trimmed;
    final hasScheme =
        _allowedSchemes.any((s) => trimmed.toLowerCase().startsWith('$s://'));
    return hasScheme ? trimmed : 'https://$trimmed';
  }

  /// Returns null on success or a human-readable error message.
  static String? validate(String raw) {
    final status = check(raw);
    return switch (status) {
      UrlValidationStatus.valid => null,
      UrlValidationStatus.empty => 'Please enter a URL.',
      UrlValidationStatus.tooLong =>
        'URL must be shorter than ${AppConstants.maxUrlLength} characters.',
      UrlValidationStatus.invalidScheme =>
        'Only http:// and https:// URLs are supported.',
      UrlValidationStatus.invalidFormat => 'Please enter a valid URL.',
    };
  }

  /// Returns the [UrlValidationStatus] for [raw] (normalisation is NOT applied).
  static UrlValidationStatus check(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return UrlValidationStatus.empty;
    if (trimmed.length > AppConstants.maxUrlLength) {
      return UrlValidationStatus.tooLong;
    }

    final Uri? uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasAuthority) return UrlValidationStatus.invalidFormat;

    if (!_allowedSchemes.contains(uri.scheme.toLowerCase())) {
      return UrlValidationStatus.invalidScheme;
    }

    // Require at least one dot in host (e.g. 'example.com').
    if (!uri.host.contains('.')) return UrlValidationStatus.invalidFormat;

    return UrlValidationStatus.valid;
  }
}
