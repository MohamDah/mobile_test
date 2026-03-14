import 'package:flutter/material.dart';

/// Central palette for FitLife. All colour references throughout the app
/// should come from here so restyling requires only one-file edits.
class AppColors {
  AppColors._(); // prevent instantiation

  // ── Brand ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF0D47A1); // deep-blue gym energy
  static const Color primaryLight = Color(0xFF5472D3);
  static const Color primaryDark = Color(0xFF002171);
  static const Color accent = Color(0xFFFF6F00); // energetic amber accent

  // ── Backgrounds ────────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color darkBackground = Color(0xFF121212);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF1E1E1E);

  // ── Text ───────────────────────────────────────────────────────────────
  static const Color lightText = Color(0xFF1A1A2E);
  static const Color darkText = Color(0xFFECEFF1);
  static const Color subtitleLight = Color(0xFF607D8B);
  static const Color subtitleDark = Color(0xFF90A4AE);

  // ── Status ─────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);

  // ── District badge colours ──────────────────────────────────────────────
  static const Color gasaboChip = Color(0xFF1565C0);
  static const Color kicukiroChip = Color(0xFF2E7D32);
  static const Color nyarugengeChip = Color(0xFF6A1B9A);
}
