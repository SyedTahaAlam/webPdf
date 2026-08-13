// lib/core/utils/debouncer.dart

import 'dart:async';

/// Delays execution of [callback] until [duration] has elapsed since the last call.
class Debouncer {
  Debouncer({this.duration = const Duration(milliseconds: 400)});

  final Duration duration;
  Timer? _timer;

  void call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  void dispose() => _timer?.cancel();
}
