// GENERATED CODE - DO NOT MODIFY BY HAND
// Run build_runner to regenerate: dart run build_runner build

part of 'pdf_document.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PdfDocumentAdapter extends TypeAdapter<PdfDocument> {
  @override
  final int typeId = 0;

  @override
  PdfDocument read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PdfDocument(
      id: fields[0] as String,
      name: fields[1] as String,
      filePath: fields[2] as String,
      createdAt: fields[3] as DateTime,
      sizeBytes: fields[4] as int,
      sourceUrl: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PdfDocument obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.filePath)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.sizeBytes)
      ..writeByte(5)
      ..write(obj.sourceUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfDocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
