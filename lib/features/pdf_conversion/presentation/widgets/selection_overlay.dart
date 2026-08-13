// lib/features/pdf_conversion/presentation/widgets/selection_overlay.dart

import 'package:flutter/material.dart';

/// Transparent overlay that shows the user-selected bounding box.
class SelectionOverlay extends StatelessWidget {
  const SelectionOverlay({
    required this.rect,
    super.key,
  });

  final Rect rect;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
            color:
                Theme.of(context).colorScheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
