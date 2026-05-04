import 'package:flutter/material.dart';

/// Centralized color palette for Bachelor Foods.
/// All colors are static const — zero runtime cost.
class AppColors {
  AppColors._(); // prevent instantiation

  // ── Brand ────────────────────────────────────
  /// Signature orange — buttons, highlights, AppBar
  static const Color primary = Color(0xFFFF6B2C);

  /// Deep orange-red — pressed states, gradients, accents
  static const Color secondary = Color(0xFFE84C0B);

  /// Warm amber — soft highlights, shimmer, badges
  static const Color accent = Color(0xFFFFAB40);

  // ── Backgrounds ──────────────────────────────
  /// Main screen background
  static const Color background = Color(0xFFFFFFFF);

  /// Subtle off-white — cards, input fills, sections
  static const Color backgroundSoft = Color(0xFFFAFAFA);

  /// Light orange tint — selected states, OTP field, chips
  static const Color backgroundOrange = Color(0xFFFFF0EB);

  // ── Text ─────────────────────────────────────
  /// Primary text — headings, labels
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// Secondary text — subtitles, descriptions
  static const Color textSecondary = Color(0xFF6B6B6B);

  /// Hint / placeholder text
  static const Color textHint = Color(0xFFB0B0B0);

  /// Inverse text — on dark/orange backgrounds
  static const Color textInverse = Color(0xFFFFFFFF);

  // ── Borders & Dividers ───────────────────────
  /// Default input and card borders
  static const Color border = Color(0xFFE8E8E8);

  /// Focused / active border (orange tint)
  static const Color borderFocus = Color(0xFFFFD4C2);

  // ── Semantic ─────────────────────────────────
  /// Success — order confirmed, verified, delivered
  static const Color success = Color(0xFF2ECC71);

  /// Success background tint
  static const Color successLight = Color(0xFFEAFAF1);

  /// Warning — pending, preparing
  static const Color warning = Color(0xFFF39C12);

  /// Warning background tint
  static const Color warningLight = Color(0xFFFEF9EC);

  /// Error — validation failures, cancellations
  static const Color error = Color(0xFFE74C3C);

  /// Error background tint
  static const Color errorLight = Color(0xFFFDECEB);

  // ── Shadows ──────────────────────────────────
  /// Card and container drop shadow
  static const Color shadow = Color(0x14000000);

  /// Orange-tinted glow shadow — buttons, logo badge
  static const Color shadowOrange = Color(0x33FF6B2C);
}