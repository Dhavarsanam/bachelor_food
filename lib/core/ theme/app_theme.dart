import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Centralized theme configuration for Bachelor Foods.
class AppTheme {
  AppTheme._(); // prevent instantiation

  // ── Shared radius tokens ─────────────────────
  static const double _radiusSm = 10.0;
  static const double _radiusMd = 14.0;
  static const double _radiusLg = 16.0;
  static const double _radiusXl = 20.0;

  // ── Light theme ──────────────────────────────
  static ThemeData get lightTheme {
    // Base text theme using Poppins
    final textTheme = _buildTextTheme();
    final colorScheme = _buildColorScheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // ── Scaffold ────────────────────────────
      scaffoldBackgroundColor: AppColors.background,

      // ── Primary ─────────────────────────────
      primaryColor: AppColors.primary,

      // ── Text ────────────────────────────────
      textTheme: textTheme,
      fontFamily: GoogleFonts.poppins().fontFamily,

      // ── AppBar ──────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textInverse,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.textInverse,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textInverse,
          size: 24,
        ),
        actionsIconTheme: const IconThemeData(
          color: AppColors.textInverse,
          size: 24,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // ── ElevatedButton ──────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textInverse,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.55),
          disabledForegroundColor: AppColors.textInverse.withValues(alpha: 0.7),
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusMd),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ── OutlinedButton ──────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.6),
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusMd),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // ── TextButton ──────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusSm),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // ── InputDecoration ─────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

        // Borders
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
          borderSide: const BorderSide(color: AppColors.border, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 1.8),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
          borderSide:
          BorderSide(color: AppColors.border.withValues(alpha: 0.6)),
        ),

        // Labels & hints
        labelStyle: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.poppins(
          color: AppColors.textHint,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.poppins(
          color: AppColors.error,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: GoogleFonts.poppins(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),

        // Icons
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
      ),

      // ── Card ────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.background,
        elevation: 0,
        shadowColor: AppColors.shadow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusLg),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      ),

      // ── Chip ────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundSoft,
        selectedColor: AppColors.backgroundOrange,
        labelStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        secondaryLabelStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ── BottomNavigationBar ──────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        elevation: 12,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),

      // ── Divider ─────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // ── SnackBar ────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: GoogleFonts.poppins(
          color: AppColors.textInverse,
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusSm),
        ),
        elevation: 4,
      ),

      // ── Dialog ──────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusXl),
        ),
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      ),

      // ── FloatingActionButton ─────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textInverse,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ── ProgressIndicator ────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.backgroundOrange,
        circularTrackColor: AppColors.backgroundOrange,
      ),

      // ── Switch ──────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.textHint;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.backgroundOrange
              : AppColors.border;
        }),
      ),
    );
  }

  // ── ColorScheme ─────────────────────────────
  static ColorScheme _buildColorScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.textInverse,
      primaryContainer: AppColors.backgroundOrange,
      onPrimaryContainer: AppColors.secondary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textInverse,
      secondaryContainer: AppColors.backgroundOrange,
      onSecondaryContainer: AppColors.secondary,
      tertiary: AppColors.accent,
      onTertiary: AppColors.textInverse,
      error: AppColors.error,
      onError: AppColors.textInverse,
      errorContainer: AppColors.errorLight,
      onErrorContainer: AppColors.error,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.border,
      outlineVariant: AppColors.borderFocus,
      shadow: AppColors.shadow,
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.textInverse,
      inversePrimary: AppColors.accent,
    );
  }

  // ── TextTheme ────────────────────────────────
  static TextTheme _buildTextTheme() {
    return TextTheme(
      // Display — hero banners, splash text
      displayLarge: GoogleFonts.poppins(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
        height: 1.1,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.3,
        height: 1.15,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
        height: 1.2,
      ),

      // Headline — screen titles, section headers
      headlineLarge: GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.0,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
        height: 1.35,
      ),

      // Title — card titles, list headers, app bar
      titleLarge: GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
        height: 1.35,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.2,
        height: 1.4,
      ),

      // Body — descriptions, paragraphs
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
        height: 1.55,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        letterSpacing: 0.1,
        height: 1.55,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        letterSpacing: 0.2,
        height: 1.5,
      ),

      // Label — buttons, chips, badges, captions
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.3,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.4,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.textHint,
        letterSpacing: 0.5,
        height: 1.4,
      ),
    );
  }
}