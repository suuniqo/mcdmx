import 'package:flutter/material.dart';

import 'package:mcdmx/style/palette.dart';

class ColorTheme {
  final double hue;

  ColorTheme(this.hue);

  ThemeData _themefromPalette(Palette pltt) {
    return ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: pltt.primary,
          ).copyWith(
            primary: pltt.primary,
            surface: pltt.backgroundDark,

            primaryContainer: pltt.backgroundLight,
            secondaryContainer: pltt.secondary,

            surfaceTint: pltt.border,
            surfaceContainerLowest: pltt.background,
            surfaceContainerLow: pltt.backgroundLight,
            surfaceContainer: pltt.backgroundLight,
            surfaceContainerHigh: pltt.backgroundLight,
            surfaceContainerHighest: pltt.backgroundLight,

            surfaceDim: pltt.backgroundDim,

            onPrimary: pltt.backgroundLight,
            onSurface: pltt.text,
            onSurfaceVariant: pltt.textMuted,

            outline: pltt.primary,
          ),
    );
  }

  ThemeData get light {
    final Palette pltt = PaletteLight.fromHue(hue);

    return _themefromPalette(pltt);
  }

  ThemeData get dark {
    final Palette pltt = PaletteDark.fromHue(hue);

    return _themefromPalette(pltt);
  }
}
