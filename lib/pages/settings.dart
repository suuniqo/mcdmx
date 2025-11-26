import 'package:mcdmx/style/theme_hue.dart';
import 'package:mcdmx/widgets/icon_desc.dart';
import 'package:mcdmx/widgets/icon_title.dart';
import 'package:mcdmx/widgets/titled_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:mcdmx/state/scheme.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/style/font_mul.dart';

class SettingsPage extends StatelessWidget {
  Switch _darkModeSwitch(ThemeData theme, SchemeState schemeState) {
    return Switch(
      trackOutlineWidth: WidgetStateProperty.resolveWith<double?>((_) {
        return Format.borderWidth;
      }),
      inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
      inactiveThumbColor: theme.colorScheme.primary,
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((_) {
        return theme.colorScheme.primary;
      }),
      value: schemeState.isDarkMode,
      onChanged: (_) => schemeState.toggleThemeMode(),
    );
  }

  Slider _fontSizeSlider(ThemeData theme, SchemeState schemeState) {
    return Slider(
      inactiveColor: theme.colorScheme.surfaceContainerLowest,
      value: schemeState.fontMul,
      min: FontMul.min,
      max: FontMul.max,
      onChanged: (value) {
        if ((value - FontMul.base).abs() <= FontMul.baseThreshold) {
          schemeState.setFontMul(FontMul.base);
        } else {
          schemeState.setFontMul(value);
        }
      },
    );
  }

  Slider _themeHueSlider(ThemeData theme, SchemeState schemeState) {
    double realFromTransform(double value) {
        return value >= 0.0 ? value : ThemeHue.max + value;
    }

    double transformFromReal(double value) {
        return value <= ThemeHue.base + ThemeHue.max / 2 ? value : value - ThemeHue.max;
    }

    return Slider(
      inactiveColor: theme.colorScheme.surfaceContainerLowest,
      value: transformFromReal(schemeState.themeHue),
      min: ThemeHue.base - ThemeHue.max / 2 + 0.1,
      max: ThemeHue.base + ThemeHue.max / 2,
      onChanged: (value) {
        var realValue = realFromTransform(value);

        if ((realValue - ThemeHue.base).abs() <= ThemeHue.baseThreshold) {
          schemeState.setThemeHue(ThemeHue.base);
        } else {
          schemeState.setThemeHue(realValue);
        }
      },
    );
  }

  Widget _resetDataButton(
    BuildContext context,
    ThemeData theme,
    SchemeState schemeState,
    ContentStyle contentStyle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                side: BorderSide(
                  color: theme.colorScheme.surfaceTint,
                  width: Format.borderWidth,
                ),
                iconSize: 24,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Format.borderRadius),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 8),
              ).copyWith(animationDuration: Duration(milliseconds: 1)),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('¿Estás seguro?'),
                    content: const Text(
                      'Todos los datos de la aplicación se restablecerán a sus valores por defecto. Esta acción es irreversible.',
                    ),
                    alignment: Alignment.center,
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Borrar'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  schemeState.restore();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.restart_alt_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: Format.separatorIconTitle),
                  Text(
                    'Borrar Datos',
                    style: contentStyle.titleItem.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final contentStyle = ContentStyle.fromTheme(theme);
    final schemeState = context.watch<SchemeState>();

    final settings = [
      SettingsSection(
        children: [
          IconTitle(title: 'Apariencia', icon: Icons.color_lens),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconDesc(icon: Icons.dark_mode_rounded, title: 'Modo Oscuro'),
                Spacer(),
                _darkModeSwitch(theme, schemeState),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsetsGeometry.only(left: 16, right: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconDesc(icon: Icons.format_size_rounded, title: 'Tamaño'),
                Spacer(),
                _fontSizeSlider(theme, schemeState),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsetsGeometry.only(left: 16, right: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconDesc(icon: Icons.gradient_rounded, title: 'Tono'),
                Spacer(),
                _themeHueSlider(theme, schemeState),
              ],
            ),
          ),
        ],
      ),
      SettingsSection(
        children: [
          IconTitle(title: 'Almacenamiento', icon: Icons.folder_rounded),
          _resetDataButton(context, theme, schemeState, contentStyle),
          SizedBox(height: 8),
        ],
      ),
    ];

    return TitledPage(
      title: 'Ajustes',
      child: ListView(
        children: [
          for (var i = 0; i < settings.length; i++)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : Format.marginPrimary),
              child: settings[i],
            ),
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final List<Widget> children;

  SettingsSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: Format.elevation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
