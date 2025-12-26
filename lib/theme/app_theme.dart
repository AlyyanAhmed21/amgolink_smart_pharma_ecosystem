import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryPurple = Color(0xFFB026FF);
  static const Color primaryPink = Color(0xFF2979FF); // <--- Change this
  static const Color secondaryCyan = Color(0xFF00E5FF);
  static const Color success = Color(0xFF00E676);
  static const Color secondaryPink = primaryPink; // Backward compatibility

  static const LinearGradient neonGradient = LinearGradient(
    colors: [primaryPurple, primaryPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light Mode Palette
  static const Color lightBackground = Color(0xFFF3F4F6);
  static const Color _lightSurface = Colors.white;
  static const Color _lightTextPrimary = Color(0xFF1F2937);
  static const Color _lightTextSecondary = Color(0xFF6B7280);

  // Dark Mode Palette
  static const Color darkBackground = Color(0xFF050505);
  static const Color _darkSurface = Color(0xFF121212);
  static const Color _darkTextPrimary = Colors.white;
  static const Color _darkTextSecondary = Color(0xFF9CA3AF);

  // Helper for Glows
  static List<BoxShadow> neonGlow({required Color color, double blur = 15}) {
    return [
      BoxShadow(
          color: color.withOpacity(0.6), blurRadius: blur, spreadRadius: 1)
    ];
  }

  static List<BoxShadow> softGlow({required Color color}) {
    return [
      BoxShadow(color: color.withOpacity(0.2), blurRadius: 10, spreadRadius: 2)
    ];
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: primaryPurple,
      colorScheme: const ColorScheme.light(
        surface: _lightSurface,
        onSurface: _lightTextPrimary,
        primary: primaryPurple,
        secondary: secondaryCyan,
        onSurfaceVariant: _lightTextSecondary,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: _lightTextPrimary,
        displayColor: _lightTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _lightTextPrimary),
        titleTextStyle: TextStyle(
            color: _lightTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryPurple,
      colorScheme: const ColorScheme.dark(
        surface: _darkSurface,
        onSurface: _darkTextPrimary,
        primary: primaryPurple,
        secondary: secondaryCyan,
        onSurfaceVariant: _darkTextSecondary,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: _darkTextPrimary,
        displayColor: _darkTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _darkTextPrimary),
        titleTextStyle: TextStyle(
            color: _darkTextPrimary, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      useMaterial3: true,
    );
  }
}
