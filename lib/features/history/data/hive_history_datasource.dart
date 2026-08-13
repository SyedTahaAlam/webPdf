// lib/features/history/data/hive_history_datasource.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:webpdf/core/config/app_constants.dart';
import 'package:webpdf/features/history/domain/pdf_document.dart';

/// Low-level Hive data source for [PdfDocument] persistence.
class HiveHistoryDatasource {
  HiveHistoryDatasource(this._box);

  static Future<HiveHistoryDatasource> open() async {
    final box = await Hive.openBox<PdfDocument>(AppConstants.historyBoxName);
    return HiveHistoryDatasource(box);
  }

  final Box<PdfDocument> _box;

  List<PdfDocument> getAll() =>
      _box.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Future<void> add(PdfDocument doc) => _box.put(doc.id, doc);

  Future<void> delete(String id) => _box.delete(id);

  Future<void> update(PdfDocument doc) => _box.put(doc.id, doc);
}
