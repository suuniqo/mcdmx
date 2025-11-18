import 'package:flutter/material.dart';

class ColorTheme {
  static const seed = Color.fromRGBO(251, 73, 28, 1.0);

  static ThemeData get light {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: baseScheme.copyWith(outline: baseScheme.primary),
    );
  }

  static ThemeData get dark {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: baseScheme.copyWith(
        primaryContainer: Colors.black87,
        outline: baseScheme.primary,
      ),
    );
  }

  static ThemeData get base => light;

  static bool get baseIsDark => base.brightness == Brightness.light;
}
