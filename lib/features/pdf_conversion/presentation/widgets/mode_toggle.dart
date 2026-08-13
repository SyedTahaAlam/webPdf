// lib/features/pdf_conversion/presentation/widgets/mode_toggle.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webpdf/features/pdf_conversion/application/conversion_controller.dart';
import 'package:webpdf/features/pdf_conversion/domain/entities/conversion_mode.dart';

/// Segmented control to switch between Full Page and Select Section modes.
class ModeToggle extends ConsumerWidget {
  const ModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(conversionControllerProvider.notifier);
    final currentMode = controller.mode;
    final theme = Theme.of(context);

    return SegmentedButton<ConversionMode>(
      segments: const [
        ButtonSegment(
          value: ConversionMode.fullPage,
          label: Text('Full Page'),
          icon: Icon(Icons.open_in_full),
        ),
        ButtonSegment(
          value: ConversionMode.selectSection,
          label: Text('Select Section'),
          icon: Icon(Icons.crop_free),
        ),
      ],
      selected: {currentMode},
      onSelectionChanged: (modes) {
        controller.setMode(modes.first);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? theme.colorScheme.primaryContainer
              : null,
        ),
      ),
    );
  }
}
