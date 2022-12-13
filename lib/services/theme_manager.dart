import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeManager {
  final darkTheme = ThemeData(
    primarySwatch: Colors.brown,
  );

  final lightTheme = ThemeData(
      scaffoldBackgroundColor: Color(0xff082032),
      primarySwatch: Colors.amber,
      textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white)),
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.brown,
          onPrimary: Colors.white,
          secondary: Colors.amber.shade700,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.brown.shade900,
          onBackground: Colors.white,
          surface: Colors.brown.shade500,
          onSurface: Colors.white));
}
