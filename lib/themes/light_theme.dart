import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    primaryColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white,
      brightness: Brightness.light,
      primary: const Color(0xFF007aff),
      onPrimary: Colors.white,
    ),
    cardColor: Colors.white,
    scaffoldBackgroundColor: const Color(0xFFF7f6f2),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF007aff), foregroundColor: Colors.white),
  );
}
