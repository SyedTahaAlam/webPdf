// test/unit/url_validator_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:webpdf/core/utils/url_validator.dart';

void main() {
  group('UrlValidator.check', () {
    test('returns valid for https url', () {
      expect(
        UrlValidator.check('https://example.com'),
        UrlValidationStatus.valid,
      );
    });

    test('returns valid for http url', () {
      expect(
        UrlValidator.check('http://example.com'),
        UrlValidationStatus.valid,
      );
    });

    test('returns empty for blank input', () {
      expect(UrlValidator.check(''), UrlValidationStatus.empty);
      expect(UrlValidator.check('   '), UrlValidationStatus.empty);
    });

    test('returns invalidFormat when host has no dot', () {
      expect(
        UrlValidator.check('https://localhost'),
        UrlValidationStatus.invalidFormat,
      );
    });

    test('returns invalidScheme for ftp url', () {
      expect(
        UrlValidator.check('ftp://example.com'),
        UrlValidationStatus.invalidScheme,
      );
    });

    test('returns invalidFormat for random text', () {
      expect(
        UrlValidator.check('not a url'),
        UrlValidationStatus.invalidFormat,
      );
    });
  });

  group('UrlValidator.normalise', () {
    test('prepends https:// when scheme is missing', () {
      expect(
        UrlValidator.normalise('example.com'),
        'https://example.com',
      );
    });

    test('does not modify url that already has https://', () {
      expect(
        UrlValidator.normalise('https://example.com'),
        'https://example.com',
      );
    });

    test('does not modify url that has http://', () {
      expect(
        UrlValidator.normalise('http://example.com'),
        'http://example.com',
      );
    });

    test('trims whitespace', () {
      expect(
        UrlValidator.normalise('  https://example.com  '),
        'https://example.com',
      );
    });
  });

  group('UrlValidator.validate', () {
    test('returns null for valid url', () {
      expect(UrlValidator.validate('https://flutter.dev'), isNull);
    });

    test('returns non-null message for empty input', () {
      expect(UrlValidator.validate(''), isNotNull);
    });
  });
}
