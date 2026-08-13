// lib/core/network/connectivity_service.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webpdf/core/error/app_exception.dart';
import 'package:webpdf/core/error/result.dart';

/// Exposes network connectivity state and a reachability guard.
class ConnectivityService {
  ConnectivityService(this._connectivity);

  final Connectivity _connectivity;

  /// Returns `true` when at least one non-none connectivity result is present.
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  /// Wraps [fn] with a connectivity pre-check.
  ///
  /// Returns [NoConnectivityException] immediately if offline.
  Future<Result<T>> guard<T>(Future<Result<T>> Function() fn) async {
    if (!await isConnected) {
      return failure(const NoConnectivityException());
    }
    return fn();
  }
}

/// Riverpod provider for [ConnectivityService].
final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityService(Connectivity()),
);
