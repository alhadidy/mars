import 'package:flutter/material.dart';

class Prefs {
  final ThemeData theme;

  Prefs({required this.theme});

  Prefs copyWith({ThemeData? theme}) {
    return Prefs(
      theme: theme ?? this.theme,
    );
  }
}
