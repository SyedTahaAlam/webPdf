// lib/features/history/presentation/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webpdf/core/router/app_router.dart';
import 'package:webpdf/core/theme/app_spacing.dart';
import 'package:webpdf/core/utils/file_size_formatter.dart';
import 'package:webpdf/core/widgets/app_snackbar.dart';
import 'package:webpdf/core/widgets/empty_state.dart';
import 'package:webpdf/core/widgets/error_state.dart';
import 'package:webpdf/core/widgets/loading_shimmer.dart';
import 'package:webpdf/features/ads/presentation/widgets/banner_ad_widget.dart';
import 'package:webpdf/features/history/application/history_controller.dart';
import 'package:webpdf/features/history/domain/pdf_document.dart';
import 'package:webpdf/features/history/presentation/widgets/pdf_list_item.dart';

/// Displays the list of previously generated PDFs.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Column(
        children: [
          Expanded(
            child: state.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: ShimmerList(),
              ),
              error: (msg, _) => ErrorState(
                message: msg.toString(),
                onRetry: () =>
                    ref.read(historyControllerProvider.notifier).load(),
              ),
              data: (docs) {
                if (docs.isEmpty) {
                  return const EmptyState(
                    title: 'No PDFs yet',
                    message:
                        'Convert a website to PDF and it will appear here.',
                    icon: Icons.picture_as_pdf_outlined,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (ctx, i) {
                    final doc = docs[i];
                    return PdfListItem(
                      doc: doc,
                      onTap: () => Navigator.of(ctx).pushNamed(
                        AppRoutes.pdfPreview,
                        arguments: doc.filePath,
                      ),
                      onDelete: () async {
                        await ref
                            .read(historyControllerProvider.notifier)
                            .delete(doc.id);
                        if (ctx.mounted) {
                          AppSnackbar.showInfo(ctx, 'PDF deleted.');
                        }
                      },
                      onRename: () async {
                        final name = await _showRenameDialog(ctx, doc.name);
                        if (name != null && ctx.mounted) {
                          await ref
                              .read(historyControllerProvider.notifier)
                              .rename(doc.id, name);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Future<String?> _showRenameDialog(BuildContext ctx, String currentName) {
    final controller = TextEditingController(text: currentName);
    return showDialog<String>(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Rename PDF'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }
}
