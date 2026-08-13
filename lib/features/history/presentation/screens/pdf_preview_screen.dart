// lib/features/history/presentation/screens/pdf_preview_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

/// Full-screen PDF preview + share screen.
class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({required this.filePath, super.key});

  final String filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          filePath.split('/').last,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share',
            onPressed: () => Share.shareXFiles(
              [XFile(filePath)],
              subject: 'PDF from WebPdf',
            ),
          ),
        ],
      ),
      body: PdfPreview(
        build: (_) => File(filePath).readAsBytes(),
        allowPrinting: true,
        allowSharing: true,
        canChangeOrientation: false,
      ),
    );
  }
}
