// lib/features/history/application/history_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webpdf/core/error/error_logger.dart';
import 'package:webpdf/features/history/data/history_repository_impl.dart';
import 'package:webpdf/features/history/domain/pdf_document.dart';

/// Manages the list of saved PDF documents.
class HistoryController extends StateNotifier<AsyncValue<List<PdfDocument>>> {
  HistoryController(this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  final Ref _ref;

  Future<void> load() async {
    state = const AsyncValue.loading();
    final repo = _ref.read(historyRepositoryProvider);
    final result = await repo.getAll();
    result.fold(
      (e) {
        ErrorLogger.instance.logException(e);
        state = AsyncValue.error(e.message, StackTrace.current);
      },
      (docs) => state = AsyncValue.data(docs),
    );
  }

  Future<void> delete(String id) async {
    final repo = _ref.read(historyRepositoryProvider);
    await repo.deleteDocument(id);
    await load();
  }

  Future<void> rename(String id, String newName) async {
    final repo = _ref.read(historyRepositoryProvider);
    await repo.renameDocument(id, newName);
    await load();
  }
}

final historyControllerProvider =
    StateNotifierProvider<HistoryController, AsyncValue<List<PdfDocument>>>(
  (ref) => HistoryController(ref),
);
