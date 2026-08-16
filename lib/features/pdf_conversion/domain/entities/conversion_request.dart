// lib/features/pdf_conversion/domain/entities/conversion_request.dart

import 'package:equatable/equatable.dart';
import 'package:webpdf/features/pdf_conversion/domain/entities/conversion_mode.dart';
import 'package:webpdf/features/pdf_conversion/domain/entities/selection_rect.dart';

/// Describes everything needed to perform a conversion.
class ConversionRequest extends Equatable {
  const ConversionRequest({
    required this.url,
    required this.mode,
    this.selectedRect,
    this.customName,
  });

  final String url;
  final ConversionMode mode;

  /// The selection rectangle for [ConversionMode.selectSection].
  /// Must be non-null when [mode] == [ConversionMode.selectSection].
  final SelectionRect? selectedRect;

  /// Optional custom file name (without extension).
  final String? customName;

  @override
  List<Object?> get props => [url, mode, selectedRect, customName];
}
