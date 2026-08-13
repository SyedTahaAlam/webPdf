// lib/features/pdf_conversion/domain/entities/conversion_mode.dart

/// The two PDF conversion modes supported by the app.
enum ConversionMode {
  /// Capture the entire rendered page (including scrollable content).
  fullPage,

  /// Capture only a user-selected section / DOM element.
  selectSection,
}
