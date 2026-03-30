import 'package:flutter/material.dart';

ThemeData buildNabdTheme() {
  const base = Color(0xFF0F766E);
  const accent = Color(0xFFF59E0B);
  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: base,
        brightness: Brightness.dark,
      ).copyWith(
        primary: const Color(0xFF14B8A6),
        secondary: accent,
        surface: const Color(0xFF102132),
        surfaceContainerHighest: const Color(0xFF17324A),
      );

  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(22),
    borderSide: const BorderSide(color: Color(0xFF24415D)),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF11273A),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: accent, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF102132),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF11273A),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF17324A),
      selectedColor: accent,
      labelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
