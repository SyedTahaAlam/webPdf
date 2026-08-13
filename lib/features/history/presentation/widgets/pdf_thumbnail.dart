// lib/features/history/presentation/widgets/pdf_thumbnail.dart

import 'package:flutter/material.dart';
import 'package:webpdf/core/theme/app_spacing.dart';

/// Placeholder thumbnail for a PDF document.
class PdfThumbnail extends StatelessWidget {
  const PdfThumbnail({super.key, this.size = 56});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size * 1.3,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Icon(
        Icons.picture_as_pdf,
        color: theme.colorScheme.onPrimaryContainer,
        size: size * 0.6,
      ),
    );
  }
}
