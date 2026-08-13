// lib/features/history/data/history_repository_impl.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webpdf/core/error/app_exception.dart';
import 'package:webpdf/core/error/result.dart';
import 'package:webpdf/features/history/data/hive_history_datasource.dart';
import 'package:webpdf/features/history/domain/history_repository.dart';
import 'package:webpdf/features/history/domain/pdf_document.dart';

/// Hive-backed implementation of [HistoryRepository].
class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl(this._ds);

  final HiveHistoryDatasource _ds;

  @override
  Future<Result<List<PdfDocument>>> getAll() async {
    try {
      return success(_ds.getAll());
    } catch (e) {
      return failure(UnexpectedException(cause: e));
    }
  }

  @override
  Future<Result<void>> addDocument(PdfDocument doc) async {
    try {
      await _ds.add(doc);
      return success(null);
    } catch (e) {
      return failure(UnexpectedException(cause: e));
    }
  }

  @override
  Future<Result<void>> deleteDocument(String id) async {
    try {
      await _ds.delete(id);
      return success(null);
    } catch (e) {
      return failure(UnexpectedException(cause: e));
    }
  }

  @override
  Future<Result<void>> renameDocument(String id, String newName) async {
    try {
      final docs = _ds.getAll();
      final doc = docs.where((d) => d.id == id).firstOrNull;
      if (doc == null) {
        return failure(FileSystemException('Document not found'));
      }
      await _ds.update(doc.copyWith(name: newName));
      return success(null);
    } catch (e) {
      return failure(UnexpectedException(cause: e));
    }
  }
}

/// Provider — requires [HiveHistoryDatasource] to be initialised first.
final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => throw UnimplementedError('Override in ProviderScope overrides'),
);
