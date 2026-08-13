// lib/core/error/result.dart
//
// Thin type-alias around dartz Either so the rest of the codebase can use
// the more expressive `Result<S>` syntax.

import 'package:dartz/dartz.dart';
import 'package:webpdf/core/error/app_exception.dart';

/// A computation that may fail with an [AppException] or succeed with [S].
typedef Result<S> = Either<AppException, S>;

/// Convenience helpers to construct [Result] values without importing dartz.
Result<S> success<S>(S value) => Right(value);
Result<S> failure<S>(AppException exception) => Left(exception);

/// Unwrap the success value, or return [fallback] on failure.
S resultOr<S>(Result<S> result, S fallback) =>
    result.fold((_) => fallback, (v) => v);

/// Execute [fn] and wrap any thrown [Exception] in an [UnexpectedException].
/// Use this at the boundary between infrastructure and domain code.
Future<Result<S>> runCatching<S>(Future<S> Function() fn) async {
  try {
    return success(await fn());
  } on AppException catch (e) {
    return failure(e);
  } catch (e, st) {
    return failure(UnexpectedException(cause: e));
  }
}
