import 'package:flutter/material.dart';
import 'package:okcolor/models/extensions.dart';
import 'package:okcolor/models/oklch.dart';

class Palette {
  final Brightness brightness;

  final Color backgroundDark;
  final Color background;
  final Color backgroundLight;

  final Color backgroundDim;

  final Color text;
  final Color textMuted;

  final Color border;

  final Color primary;
  final Color secondary;

  final Color danger;
  final Color warning;
  final Color success;
  final Color info;

  const Palette({
    required this.brightness,

    required this.backgroundDark,
    required this.background,
    required this.backgroundLight,

    required this.backgroundDim,

    required this.text,
    required this.textMuted,

    required this.border,

    required this.primary,
    required this.secondary,

    required this.danger,
    required this.warning,
    required this.success,
    required this.info,
  });

  static Color hsl(double hue, double saturation, double lightness) {
    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  static Color lch(double lightness, double chroma, double hue) {
    return OkLch(lightness, chroma, hue).toColor();
  }
}

class PaletteLight {
  static Palette fromHue(double hue) {
    const chromaLo = 0.02;
    const chromaHi = 0.005;

    return Palette(
      brightness: Brightness.light,
  
      backgroundDark: Palette.lch(0.90, chromaHi, hue),
      background: Palette.lch(0.94, chromaHi, hue),
      backgroundLight: Palette.lch(0.99, chromaHi, hue),

      backgroundDim: Palette.lch(0.94, chromaHi, hue).darker(0.2),

      text: Palette.lch(0.15, chromaLo, hue),
      textMuted: Palette.lch(0.40, chromaLo, hue),

      border: Palette.lch(0.92, chromaHi, hue),

      primary: Palette.lch(0.75, 0.17, hue),
      secondary: Palette.lch(0.80, 0.14, hue),

      danger: Palette.lch(0.50, chromaHi, 30),
      warning: Palette.lch(0.50, chromaHi, 100),
      success: Palette.lch(0.50, chromaHi, 160),
      info: Palette.lch(0.50, chromaHi, 260),
    );
  }
}

class PaletteDark {
  static Palette fromHue(double hue) {
    const chromaLo = 0.001;
    const chromaHi = 0.015;

    return Palette(
      brightness: Brightness.dark,

      backgroundDark: Palette.lch(0.10, chromaLo, hue),
      background: Palette.lch(0.25, chromaLo, hue),
      backgroundLight: Palette.lch(0.20, chromaLo, hue),

      text: Palette.lch(0.88, chromaHi, hue),
      textMuted: Palette.lch(0.58, chromaHi, hue),

      backgroundDim: Palette.lch(0.23, chromaLo, hue).lighter(0.15),

      border: Palette.lch(0.30, chromaLo, hue),

      primary: Palette.lch(0.80, 0.14, hue),
      secondary: Palette.lch(0.75, 0.15, hue),

      danger: Palette.lch(0.70, chromaLo, 30),
      warning: Palette.lch(0.70, chromaLo, 100),
      success: Palette.lch(0.70, chromaLo, 160),
      info: Palette.lch(0.70, chromaLo, 260),
    );
  }
}
