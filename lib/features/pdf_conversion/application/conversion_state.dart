// lib/features/pdf_conversion/application/conversion_state.dart

import 'package:equatable/equatable.dart';
import 'package:webpdf/features/pdf_conversion/domain/entities/selection_rect.dart';

/// States of the PDF conversion workflow.
abstract class ConversionState extends Equatable {
  const ConversionState();
}

/// Idle — waiting for user input.
class ConversionIdle extends ConversionState {
  const ConversionIdle();
  @override
  List<Object?> get props => [];
}

/// The WebView is loading the target URL.
class ConversionLoadingPage extends ConversionState {
  const ConversionLoadingPage();
  @override
  List<Object?> get props => [];
}

/// Waiting for the user to select a page section.
class ConversionAwaitingSelection extends ConversionState {
  const ConversionAwaitingSelection({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Waiting for user to confirm or retry a selected area.
class ConversionSelectionPending extends ConversionState {
  const ConversionSelectionPending(this.rect);

  final SelectionRect rect;

  @override
  List<Object?> get props => [rect];
}

/// The PDF is being generated.
class ConversionGenerating extends ConversionState {
  const ConversionGenerating({this.progress = 0});
  final double progress;
  @override
  List<Object?> get props => [progress];
}

/// PDF generation succeeded.
class ConversionSuccess extends ConversionState {
  const ConversionSuccess(this.filePath);
  final String filePath;
  @override
  List<Object?> get props => [filePath];
}

/// PDF generation failed.
class ConversionFailure extends ConversionState {
  const ConversionFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
