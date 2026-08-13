// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

/// Design-system colour palette for WebPdf.
///
/// Uses Material 3 seed colours with hand-tuned accent values.
abstract class AppColors {
  // ── Primary brand ────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryVariant = Color(0xFF0D47A1);
  static const Color onPrimary = Colors.white;

  // ── Secondary ────────────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF03DAC6);
  static const Color onSecondary = Color(0xFF000000);

  // ── Accent / tertiary ────────────────────────────────────────────────────
  static const Color accent = Color(0xFFFF6D00);

  // ── Backgrounds (light) ──────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceVariantLight = Color(0xFFE8EAED);

  // ── Backgrounds (dark) ───────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariantDark = Color(0xFF2C2C2C);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color onBackgroundLight = Color(0xFF202124);
  static const Color onBackgroundDark = Color(0xFFE8EAED);
  static const Color onSurfaceLight = Color(0xFF3C4043);
  static const Color onSurfaceDark = Color(0xFFBDC1C6);

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFB00020);
  static const Color onError = Colors.white;
  static const Color success = Color(0xFF188038);
  static const Color warning = Color(0xFFE37400);

  // ── Borders / dividers ────────────────────────────────────────────────────
  static const Color dividerLight = Color(0xFFDADCE0);
  static const Color dividerDark = Color(0xFF3C4043);

  // ── Shimmer ──────────────────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF2C2C2C);
  static const Color shimmerHighlightDark = Color(0xFF3C3C3C);
}
