// lib/core/themes.dart

import 'package:flutter/material.dart';

/// Tema baseado em Material 3 com esquema de cores calmante.
/// Usa verde-água como seed para passar sensação de tranquilidade.

/// Tema claro
final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF64B6AC), // verde-água suave
    brightness: Brightness.light,
  ),
  focusColor: const Color(0xFF64B6AC).withOpacity(0.12),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
  ),
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF64B6AC), width: 3),
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
  ),
);

/// Tema escuro
final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF64B6AC),
    brightness: Brightness.dark,
  ),
  focusColor: const Color(0xFF64B6AC).withOpacity(0.15),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.grey.shade900,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF64B6AC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade800,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF64B6AC), width: 3),
    ),
    hintStyle: TextStyle(color: Colors.grey.shade400),
  ),
  textTheme: TextTheme(
    titleLarge: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    titleMedium: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white70,
    ),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.grey.shade200),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.grey.shade300),
  ),
);

/// Tema de alto contraste
final highContrastTheme = ThemeData(
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
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
    titleLarge: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
  ),
);
