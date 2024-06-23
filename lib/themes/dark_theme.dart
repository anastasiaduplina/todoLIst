import 'package:flutter/material.dart';

ThemeData darkTheme() {
  return ThemeData(
      primaryColor: const Color(0xff252528),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white,
        brightness: Brightness.dark,
        surface: const Color(0xff252528),
      ),
      cardColor: const Color(0xff252528),
      scaffoldBackgroundColor: const Color(0xFF161618),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF0484ff), foregroundColor: Colors.white));
}
