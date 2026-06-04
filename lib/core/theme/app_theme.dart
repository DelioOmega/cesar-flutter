import 'package:flutter/material.dart';

class AppTheme {
  // ── Colors ──────────────────────────────────────────────
  static const Color background = Color(0xFFFAF0EE);
  static const Color accent = Color(0xFFC4856A);
  static const Color darkButton = Color(0xFF2D2D2D);
  static const Color white = Colors.white;
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textGrey = Color(0xFF8E8E93);
  static const Color cardBg = Colors.white;
  static const Color divider = Color(0xFFF0F0F0);

  // Status colors
  static const Color blueStatus = Color(0xFF4A90D9);
  static const Color orangeStatus = Color(0xFFF5A623);
  static const Color greenStatus = Color(0xFF7ED321);

  // ── ThemeData ───────────────────────────────────────────
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: background,
      fontFamily: 'sans-serif',
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        primary: accent,
        surface: white,
        surfaceContainerHighest: background,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: textDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkButton,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: const BorderSide(color: accent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textGrey, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: white,
        elevation: 4,
      ),
    );
  }
}
