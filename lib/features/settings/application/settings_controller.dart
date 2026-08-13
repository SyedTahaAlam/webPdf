// lib/features/settings/application/settings_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webpdf/core/config/app_constants.dart';

/// Manages user preferences (currently: theme mode override).
class SettingsController extends StateNotifier<ThemeMode> {
  SettingsController(this._prefs)
      : super(_readThemeMode(_prefs));

  final SharedPreferences _prefs;

  static ThemeMode _readThemeMode(SharedPreferences prefs) {
    final raw = prefs.getString(AppConstants.themeModeKey);
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(
      AppConstants.themeModeKey,
      switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      },
    );
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, ThemeMode>(
  (ref) =>
      throw UnimplementedError('Override in ProviderScope overrides'),
);
