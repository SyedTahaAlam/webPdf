// test/unit/file_size_formatter_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:webpdf/core/utils/file_size_formatter.dart';

void main() {
  group('FileSizeFormatter.format', () {
    test('formats bytes', () {
      expect(FileSizeFormatter.format(512), '512 B');
    });

    test('formats kilobytes', () {
      expect(FileSizeFormatter.format(2048), '2.0 KB');
    });

    test('formats megabytes', () {
      expect(FileSizeFormatter.format(1024 * 1024), '1.0 MB');
    });

    test('formats gigabytes', () {
      expect(FileSizeFormatter.format(1024 * 1024 * 1024), '1.0 GB');
    });
  });
}
