// lib/core/themes.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  static ThemeData lightTheme(TextScaler textScaler) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF007BFF),
        brightness: Brightness.light,
      ),
      textTheme: _buildTextTheme(
        textScaler,
        Colors.black,
        Colors.black87,
        Colors.white,
      ),
    );
  }

  static ThemeData darkTheme(TextScaler textScaler) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF007BFF),
        brightness: Brightness.dark,
      ),
      textTheme: _buildTextTheme(
        textScaler,
        Colors.white,
        Colors.white70,
        Colors.white,
      ),
    );
  }

  static TextTheme _buildTextTheme(
    TextScaler textScaler,
    Color displayColor,
    Color bodyColor,
    Color labelColor,
  ) {
    return TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: textScaler.scale(57),
        fontWeight: FontWeight.bold,
        color: displayColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: textScaler.scale(28),
        fontWeight: FontWeight.w600,
        color: displayColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: textScaler.scale(16),
        fontWeight: FontWeight.w500,
        color: displayColor,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: textScaler.scale(16),
        color: bodyColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: textScaler.scale(14),
        color: bodyColor,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: textScaler.scale(14),
        fontWeight: FontWeight.w500,
        color: labelColor,
      ),
    );
  }

  static ThemeData highContrastTheme(TextScaler textScaler) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.highContrastDark(
        primary: Colors.yellow,
        secondary: Colors.cyan,
      ),
      focusColor: Colors.cyan.withOpacity(0.25),
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.black,
          shape: const BeveledRectangleBorder(),
          side: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.black,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow, width: 3),
        ),
        labelStyle: TextStyle(color: Colors.white),
      ),
      textTheme: _buildTextTheme(
        textScaler,
        Colors.white,
        Colors.white,
        Colors.yellow,
      ),
    );
  }
}
