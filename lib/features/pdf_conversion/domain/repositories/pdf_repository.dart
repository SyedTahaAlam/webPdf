// lib/features/pdf_conversion/domain/repositories/pdf_repository.dart

import 'package:webpdf/core/error/result.dart';
import 'package:webpdf/features/pdf_conversion/domain/entities/conversion_request.dart';

/// Repository interface for PDF conversion.
abstract interface class PdfRepository {
  /// Converts the page described by [request] to a PDF.
  ///
  /// Returns the absolute file path of the saved PDF on success.
  Future<Result<String>> convertToPdf(ConversionRequest request);
}
