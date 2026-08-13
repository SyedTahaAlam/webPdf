// lib/features/pdf_conversion/data/services/pdf_generator_service.dart

import 'dart:io' as io;
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:webpdf/core/config/app_constants.dart';
import 'package:webpdf/core/error/app_exception.dart';
import 'package:webpdf/core/error/result.dart';

/// Assembles one or more screenshot bytes into a PDF document and saves it.
class PdfGeneratorService {
  const PdfGeneratorService();

  static const _uuid = Uuid();

  /// Builds a PDF from [imagePages] (one PNG [Uint8List] per page/strip)
  /// and saves it to the app documents directory.
  ///
  /// Returns the absolute file path on success.
  Future<Result<String>> generatePdf({
    required List<Uint8List> imagePages,
    String? customName,
  }) async {
    // ── Permission guard ──────────────────────────────────────────────────
    if (io.Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        return failure(const PermissionDeniedException());
      }
    }

    try {
      final doc = pw.Document();

      for (final imageBytes in imagePages) {
        final image = pw.MemoryImage(imageBytes);
        doc.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (_) => pw.Center(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            ),
          ),
        );
      }

      // ── Save ────────────────────────────────────────────────────────────
      final dir = await getApplicationDocumentsDirectory();
      final name = customName != null && customName.isNotEmpty
          ? customName
          : '${AppConstants.pdfFilePrefix}${_uuid.v4().substring(0, 8)}';
      final filePath = '${dir.path}/$name${AppConstants.pdfExtension}';

      final file = io.File(filePath);
      await file.writeAsBytes(await doc.save());

      return success(filePath);
    } on io.FileSystemException catch (e) {
      return failure(
        FileSystemException(e.message, cause: e),
      );
    } catch (e) {
      return failure(PdfGenerationException(cause: e));
    }
  }
}
