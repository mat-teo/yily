import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ──────────────────────────────── LIGHT THEME ────────────────────────────────
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF9EAA),
      primary: const Color(0xFFFF9EAA),
      onPrimary: Colors.white,
      secondary: const Color(0xFFF06292),
      onSecondary: Colors.white,
      background: const Color(0xFFFFF5F8),
      surface: Colors.white,
      onSurface: const Color(0xFF2D2D2D),
      error: Colors.redAccent,
      outline: Colors.grey[400],
    ),
    scaffoldBackgroundColor: const Color(0xFFFFF5F8),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D2D2D),
      ),
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

    // ──────────────────────────────── TESTO GLOBALE LIGHT ────────────────────────────────
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(fontSize: 57, fontWeight: FontWeight.w400, color: const Color(0xFF2D2D2D), decoration: TextDecoration.none),
      displayMedium: GoogleFonts.poppins(fontSize: 45, fontWeight: FontWeight.w400, color: const Color(0xFF2D2D2D), decoration: TextDecoration.none),
      displaySmall: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w400, color: const Color(0xFF2D2D2D), decoration: TextDecoration.none),
      headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w400, color: const Color(0xFF2D2D2D), decoration: TextDecoration.none),
      headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w400, color: const Color(0xFF2D2D2D), decoration: TextDecoration.none),
      headlineSmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w400, color: const Color(0xFF2D2D2D), decoration: TextDecoration.none),
      titleLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500, color: const Color(0xFF2D2D2D), decoration: TextDecoration.none),
      titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF2D2D2D), decoration: TextDecoration.none),
      titleSmall: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF2D2D2D), decoration: TextDecoration.none),
      bodyLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xFF2D2D2D), decoration: TextDecoration.none),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF2D2D2D), decoration: TextDecoration.none),
      bodySmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xFF2D2D2D), decoration: TextDecoration.none),
      labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF2D2D2D), decoration: TextDecoration.none),
      labelMedium: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF2D2D2D), decoration: TextDecoration.none),
      labelSmall: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF2D2D2D), decoration: TextDecoration.none),
    ),
  );

  // ──────────────────────────────── DARK THEME ────────────────────────────────
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF9EAA),
      brightness: Brightness.dark,
      primary: const Color(0xFFFF9EAA),
      onPrimary: Colors.black87,
      secondary: const Color(0xFFF06292),
      onSecondary: Colors.black87,
      background: const Color(0xFF1A0F14),
      surface: const Color(0xFF2A1A20),
      onSurface: Colors.white,
      error: Colors.redAccent,
      outline: Colors.grey[600],
    ),
    scaffoldBackgroundColor: const Color(0xFF1A0F14),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF2A1A20),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      shadowColor: Colors.black.withOpacity(0.4),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color(0xFFFF9EAA),
      foregroundColor: Colors.black87,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // ──────────────────────────────── TESTO GLOBALE DARK ────────────────────────────────
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(fontSize: 57, fontWeight: FontWeight.w400, color: Colors.white, decoration: TextDecoration.none),
      displayMedium: GoogleFonts.poppins(fontSize: 45, fontWeight: FontWeight.w400, color: Colors.white, decoration: TextDecoration.none),
      displaySmall: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w400, color: Colors.white, decoration: TextDecoration.none),
      headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w400, color: Colors.white, decoration: TextDecoration.none),
      headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w400, color: Colors.white, decoration: TextDecoration.none),
      headlineSmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white, decoration: TextDecoration.none),
      titleLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white, decoration: TextDecoration.none),
      titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white, decoration: TextDecoration.none),
      titleSmall: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white, decoration: TextDecoration.none),
      bodyLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white, decoration: TextDecoration.none),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white, decoration: TextDecoration.none),
      bodySmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white, decoration: TextDecoration.none),
      labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white, decoration: TextDecoration.none),
      labelMedium: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white, decoration: TextDecoration.none),
      labelSmall: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white, decoration: TextDecoration.none),
    ),
  );
}