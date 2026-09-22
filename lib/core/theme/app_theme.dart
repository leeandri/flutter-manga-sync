import 'package:flutter/material.dart';

class AppTheme {
  static const Color sakuraPink = Color(0xFFFFB7C5);
  static const Color sumiBlack = Color(0xFF121212);
  static const Color darkSlate = Color(0xFF1E1E24);
  static const Color toriiRed = Color(0xFFD32F2F);
  static const Color washiPaper = Color(0xFFF5F5F0);

  static ThemeData get japaneseDarkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: sumiBlack,

      colorScheme: const ColorScheme.dark(
        primary: sakuraPink,
        secondary: sakuraPink,
        surface: darkSlate,
        error: toriiRed,
        onPrimary: sumiBlack,
        onSurface: washiPaper,
      ),

      // Style de l'AppBar (Barre supérieure)
      appBarTheme: const AppBarTheme(
        backgroundColor: sumiBlack,
        foregroundColor: washiPaper,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: sakuraPink,
          letterSpacing: 1.2,
        ),
      ),

      cardTheme: CardThemeData(
        color: darkSlate,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: sakuraPink.withOpacity(0.2), width: 1),
        ),
      ),
    );
  }
}
