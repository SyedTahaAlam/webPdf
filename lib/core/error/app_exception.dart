// lib/core/error/app_exception.dart

import 'package:equatable/equatable.dart';

/// Sealed hierarchy of domain exceptions.
///
/// Every repository / service wraps raw errors into one of these subtypes
/// before propagating them upward via [Result].
abstract class AppException extends Equatable implements Exception {
  const AppException(this.message, {this.cause});

  /// Human-readable description of what went wrong.
  final String message;

  /// Optional underlying error / stack trace.
  final Object? cause;

  @override
  List<Object?> get props => [message, cause];

  @override
  String toString() => '$runtimeType: $message';
}

// ── Network ──────────────────────────────────────────────────────────────────

/// The device has no active network connection.
class NoConnectivityException extends AppException {
  const NoConnectivityException()
      : super('No internet connection. Please check your network settings.');
}

/// A remote request timed out.
class TimeoutException extends AppException {
  const TimeoutException({super.cause})
      : super('The request timed out. Please try again.');
}

/// The URL is syntactically invalid or unreachable.
class InvalidUrlException extends AppException {
  const InvalidUrlException(String url)
      : super('The URL "$url" is invalid or unreachable.');
}

/// The target site blocked automated access (bot detection).
class BotDetectedException extends AppException {
  const BotDetectedException()
      : super(
          'This website blocks automated access. Try a different URL.',
        );
}

// ── PDF ──────────────────────────────────────────────────────────────────────

/// Failed to capture the webpage content.
class CaptureException extends AppException {
  const CaptureException({super.cause})
      : super('Failed to capture the webpage. Please try again.');
}

/// Failed to generate the PDF document.
class PdfGenerationException extends AppException {
  const PdfGenerationException({super.cause})
      : super('Failed to generate the PDF. Please try again.');
}

// ── Storage ──────────────────────────────────────────────────────────────────

/// Not enough storage space on the device.
class InsufficientStorageException extends AppException {
  const InsufficientStorageException()
      : super('Not enough storage space to save the PDF.');
}

/// A required file-system permission was denied.
class PermissionDeniedException extends AppException {
  const PermissionDeniedException()
      : super('Storage permission is required to save PDFs.');
}

/// A file-system operation failed.
class FileSystemException extends AppException {
  const FileSystemException(String details, {super.cause})
      : super('File error: $details');
}

// ── JS Bridge ────────────────────────────────────────────────────────────────

/// The JavaScript injected into the WebView failed or returned unexpected data.
class JsBridgeException extends AppException {
  const JsBridgeException({super.cause})
      : super(
          'The page selection script failed. '
          'This site may use an unsupported structure.',
        );
}

// ── General ──────────────────────────────────────────────────────────────────

/// A catch-all for unexpected errors.
class UnexpectedException extends AppException {
  const UnexpectedException({super.cause})
      : super('An unexpected error occurred. Please try again.');
}
