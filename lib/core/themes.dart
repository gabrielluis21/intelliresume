// lib/core/themes.dart

import 'package:flutter/material.dart';
import 'package:intelliresume/core/providers/accessibility_provider.dart';

/// Tema baseado em Material 3 com esquema de cores calmante.
/// Usa verde-água como seed para passar sensação de tranquilidade.

/// Tema claro
final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF64B6AC), // verde-água suave
    brightness: Brightness.light,
  ),
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
      borderSide: BorderSide(color: const Color(0xFF64B6AC), width: 2),
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 18),
    bodyMedium: TextStyle(fontSize: 16),
  ),
);

/// Tema escuro
final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF64B6AC),
    brightness: Brightness.dark,
  ),
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
      borderSide: const BorderSide(color: Color(0xFF64B6AC), width: 2),
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
    bodyMedium: TextStyle(fontSize: 16, color: Colors.grey.shade400),
  ),
);

/// Tema acessível baseado nas preferências do usuário.
ThemeData buildAccessibleTheme(
  AccessibilityState state,
  Brightness brightness,
) {
  final isDark = brightness == Brightness.dark;

  if (state.readerMode) {
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
        bodyMedium: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.brown,
        brightness: brightness,
      ),
    );
  }

  if (state.highContrast) {
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? Colors.black : Colors.white,
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        bodyMedium: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 16,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.yellow,
        brightness: brightness,
      ).copyWith(
        primary: Colors.yellow[800],
        onPrimary: Colors.black,
        surface: isDark ? Colors.black : Colors.white,
        onSurface: isDark ? Colors.white : Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow[800],
          foregroundColor: Colors.black,
        ),
      ),
    );
  }

  // Tema padrão do app
  return ThemeData(
    brightness: brightness,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: brightness,
    ),
  );
}
