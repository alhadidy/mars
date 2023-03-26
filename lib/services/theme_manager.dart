import 'package:flutter/material.dart';

class ThemeManager {
  final darkTheme = ThemeData(
    primarySwatch: Colors.brown,
  );

  final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.amber,
      textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
          titleSmall: TextStyle(color: Colors.black)),
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xff1F3469),
          onPrimary: Colors.white,
          secondary: const Color(0xffF8CC15),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.brown.shade900,
          onBackground: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black),
      timePickerTheme:
          const TimePickerThemeData(dialHandColor: Color(0xff1F3469)));
}
