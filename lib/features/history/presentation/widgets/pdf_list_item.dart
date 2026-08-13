// lib/features/history/presentation/widgets/pdf_list_item.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webpdf/core/theme/app_spacing.dart';
import 'package:webpdf/core/utils/file_size_formatter.dart';
import 'package:webpdf/features/history/domain/pdf_document.dart';

/// A single row in the history list.
class PdfListItem extends StatelessWidget {
  const PdfListItem({
    required this.doc,
    required this.onTap,
    required this.onDelete,
    required this.onRename,
    super.key,
  });

  final PdfDocument doc;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onRename;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr =
        DateFormat('MMM d, y · HH:mm').format(doc.createdAt.toLocal());
    final sizeStr = FileSizeFormatter.format(doc.sizeBytes);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 56,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.picture_as_pdf,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.name,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$dateStr  ·  $sizeStr',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_Action>(
                onSelected: (action) {
                  switch (action) {
                    case _Action.rename:
                      onRename();
                    case _Action.delete:
                      onDelete();
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: _Action.rename,
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Rename'),
                    ),
                  ),
                  PopupMenuItem(
                    value: _Action.delete,
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _Action { rename, delete }
