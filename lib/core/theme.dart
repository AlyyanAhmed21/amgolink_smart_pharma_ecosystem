import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const neonPurple = Color(0xFFB026FF);
  static const neonPink = Color(0xFFFF4081);
  static const darkBg = Color(0xFF050505);
  static const darkSurface = Color(0xFF121212);
  static const lightBg = Color(0xFFF3F4F6);
  static const lightSurface = Colors.white;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBg,
    primaryColor: neonPurple,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
    colorScheme: const ColorScheme.light(
      surface: lightSurface,
      onSurface: Color(0xFF1F2937), // Dark Grey Text
      primary: neonPurple,
      secondary: neonPink,
    ),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    primaryColor: neonPurple,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
    colorScheme: const ColorScheme.dark(
      surface: darkSurface,
      onSurface: Colors.white, // White Text
      primary: neonPurple,
      secondary: neonPink,
    ),
    useMaterial3: true,
  );
}
