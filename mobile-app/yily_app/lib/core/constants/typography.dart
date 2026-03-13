import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTypography {
  static TextTheme get textTheme => GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w700),
        displayMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
        headlineLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.poppins(fontSize: 16),
        bodyMedium: GoogleFonts.poppins(fontSize: 14),
        labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
      );
}