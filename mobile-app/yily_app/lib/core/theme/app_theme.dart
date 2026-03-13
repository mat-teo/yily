import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF9EAA),
      primary: const Color(0xFFFF9EAA),
      secondary: const Color(0xFFF06292),
      background: const Color(0xFFFFF5F8), // rosa chiarissimo
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: const Color(0xFF2D2D2D),
      displayColor: const Color(0xFF2D2D2D),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.08),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color(0xFFFF9EAA),
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF9EAA),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF1A0F14),
    cardTheme: CardThemeData(
      color: const Color(0xFF2A1A20),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
  );
}