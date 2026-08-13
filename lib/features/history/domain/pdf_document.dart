// lib/features/history/domain/pdf_document.dart

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'pdf_document.g.dart';

/// Represents a saved PDF document in the history list.
@HiveType(typeId: 0)
class PdfDocument extends Equatable {
  PdfDocument({
    required this.id,
    required this.name,
    required this.filePath,
    required this.createdAt,
    required this.sizeBytes,
    required this.sourceUrl,
  });

  /// Creates a [PdfDocument] from an existing file path.
  factory PdfDocument.fromPath(String filePath, {String? sourceUrl}) {
    final file = File(filePath);
    final name = filePath.split('/').last.replaceAll('.pdf', '');
    return PdfDocument(
      id: const Uuid().v4(),
      name: name,
      filePath: filePath,
      createdAt: DateTime.now(),
      sizeBytes: file.existsSync() ? file.lengthSync() : 0,
      sourceUrl: sourceUrl ?? '',
    );
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String filePath;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final int sizeBytes;

  @HiveField(5)
  final String sourceUrl;

  PdfDocument copyWith({String? name}) => PdfDocument(
        id: id,
        name: name ?? this.name,
        filePath: filePath,
        createdAt: createdAt,
        sizeBytes: sizeBytes,
        sourceUrl: sourceUrl,
      );

  @override
  List<Object?> get props => [id, filePath];
}
