// lib/features/history/domain/history_repository.dart

import 'package:webpdf/core/error/result.dart';
import 'package:webpdf/features/history/domain/pdf_document.dart';

/// Repository interface for PDF history.
abstract interface class HistoryRepository {
  Future<Result<List<PdfDocument>>> getAll();
  Future<Result<void>> addDocument(PdfDocument doc);
  Future<Result<void>> deleteDocument(String id);
  Future<Result<void>> renameDocument(String id, String newName);
}
