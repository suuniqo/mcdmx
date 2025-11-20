import 'package:flutter/material.dart';

class PaletteLight {
  static var backgroundDark = HSLColor.fromAHSL(1.0, 19, 0.09, 0.87).toColor();
  static var background = HSLColor.fromAHSL(1.0, 19, 0.13, 0.93).toColor();
  static var backgroundLight = HSLColor.fromAHSL(1.0, 19, 0.25, 0.99).toColor();

  static var text = HSLColor.fromAHSL(1.0, 18, 0.31, 0.04).toColor();
  static var textMuted = HSLColor.fromAHSL(1.0, 19, 0.07, 0.28).toColor();

  static var highlight = HSLColor.fromAHSL(1.0, 19, 1.00, 1.00).toColor();
  static var border = HSLColor.fromAHSL(1.0, 19, 0.04, 0.50).toColor();
  static var borderMuted = HSLColor.fromAHSL(1.0, 19, 0.06, 0.62).toColor();

  static var primary = HSLColor.fromAHSL(1.0, 20, 1.0, 0.69).toColor();
  static var secondary = HSLColor.fromAHSL(1.0, 20, 1.0, 0.78).toColor();

  static var danger = HSLColor.fromAHSL(1.0, 9, 0.21, 0.41).toColor();
  static var warning = HSLColor.fromAHSL(1.0, 52, 0.23, 0.34).toColor();
  static var success = HSLColor.fromAHSL(1.0, 147, 0.19, 0.36).toColor();
  static var info = HSLColor.fromAHSL(1.0, 217, 0.22, 0.41).toColor();
}

class PaletteDark {
  static var backgroundDark = HSLColor.fromAHSL(1.0, 230, 0.36, 0.02).toColor();
  static var background = HSLColor.fromAHSL(1.0, 228, 0.23, 0.09).toColor();
  static var backgroundLight = HSLColor.fromAHSL(1.0, 227, 0.17, 0.16).toColor();

  static var text = HSLColor.fromAHSL(1.0, 226, 0.27, 0.89).toColor();
  static var textMuted = HSLColor.fromAHSL(1.0, 227, 0.12, 0.71).toColor();

  static var highlight = HSLColor.fromAHSL(1.0, 227, 0.05, 0.39).toColor();
  static var border = HSLColor.fromAHSL(1.0, 227, 0.07, 0.28).toColor();
  static var borderMuted = HSLColor.fromAHSL(1.0, 227, 0.09, 0.18).toColor();

  static var primary = HSLColor.fromAHSL(1.0, 20, 1.0, 0.78).toColor();
  static var secondary = HSLColor.fromAHSL(1.0, 20, 1.0, 0.69).toColor();

  static var danger = HSLColor.fromAHSL(1.0, 9, 0.26, 0.64).toColor();
  static var warning = HSLColor.fromAHSL(1.0, 52, 0.19, 0.57).toColor();
  static var success = HSLColor.fromAHSL(1.0, 146, 0.17, 0.59).toColor();
  static var info = HSLColor.fromAHSL(1.0, 217, 0.28, 0.65).toColor();
}

class ColorTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: PaletteLight.primary,
          ).copyWith(
            primary: PaletteLight.primary,
            surface: PaletteLight.backgroundDark,

            primaryContainer: PaletteLight.backgroundLight,
            secondaryContainer: PaletteLight.secondary,

            surfaceTint: PaletteLight.backgroundDark,
            surfaceContainerLowest: PaletteLight.background,
            surfaceContainerLow: PaletteLight.backgroundLight,
            surfaceContainer: PaletteLight.backgroundLight,
            surfaceContainerHigh: PaletteLight.backgroundLight,
            surfaceContainerHighest: PaletteLight.backgroundLight,

            onPrimary: PaletteLight.backgroundLight,
            onSurface: PaletteLight.text,
            onSurfaceVariant: PaletteLight.textMuted,

            outline: PaletteLight.primary,
          ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: PaletteDark.primary,
          ).copyWith(
            primary: PaletteDark.primary,
            surface: PaletteDark.backgroundDark,

            primaryContainer: PaletteDark.backgroundLight,
            secondaryContainer: PaletteDark.secondary,

            surfaceTint: PaletteDark.backgroundLight,
            surfaceContainerLowest: PaletteDark.backgroundLight,
            surfaceContainerLow: PaletteDark.background,
            surfaceContainer: PaletteDark.background,
            surfaceContainerHigh: PaletteDark.background,
            surfaceContainerHighest: PaletteDark.background,

            onPrimary: PaletteDark.backgroundLight,
            onSurface: PaletteDark.text,
            onSurfaceVariant: PaletteDark.textMuted,

            outline: PaletteLight.primary,
          ),
    );
  }

  static ThemeData get base => light;

  static bool get baseIsDark => base.brightness == Brightness.light;
}
