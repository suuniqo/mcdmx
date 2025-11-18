import 'package:mcdmx/widgets/icon_desc.dart';
import 'package:mcdmx/widgets/icon_title.dart';
import 'package:mcdmx/widgets/titled_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:mcdmx/state/scheme.dart';
import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/scheme/font_size.dart';

class SettingsPage extends StatelessWidget {
  Switch _darkModeSwitch(ThemeData theme, SchemeState schemeState) {
    return Switch(
      inactiveTrackColor: theme.colorScheme.surface,
      value: schemeState.darkMode,
      onChanged: (_) => schemeState.toggleTheme(),
    );
  }

  Slider _fontSizeSlider(ThemeData theme, SchemeState schemeState) {
    return Slider(
      value: schemeState.fontSize,
      min: FontSize.min,
      max: FontSize.max,
      onChanged: (value) {
        if ((value - FontSize.base).abs() <=
            FontSize.baseThreshold) {
          schemeState.setFontSize(FontSize.base);
        } else {
          schemeState.setFontSize(value);
        }
      },
    );
  }

  Widget _resetDataButton(BuildContext context, ThemeData theme, SchemeState schemeState, ContentStyle contentStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: FilledButton.styleFrom(
                side: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 1.8,
                ),
                iconColor: theme.colorScheme.primary,
                iconSize: 24,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                ),
              ),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('¿Estás seguro?'),
                    content: Text(
                      'Todos los datos de la aplicación se restablecerán a sus valores por defecto. Esta acción es irreversible.'
                    ),
                    alignment: Alignment.center,
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, false),
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, true),
                        child: Text('Borrar'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  schemeState.restore();
                }
              },
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.restart_alt_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Borrar Datos',
                    style: contentStyle.titleItem,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _settingsSection({required List<Widget> children}) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final contentStyle = ContentStyle.fromTheme(theme);
    final schemeState = context.watch<SchemeState>();

    return TitledPage(
        title: 'Ajustes',
        child: ListView(
          children: [
            _settingsSection(
              children: [
                IconTitle(title: 'Apariencia', icon: Icons.color_lens),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconDesc(
                        icon: Icons.dark_mode_rounded,
                        title: 'Modo Oscuro',
                      ),
                      Spacer(),
                      _darkModeSwitch(theme, schemeState),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsetsGeometry.only(
                    left: 16,
                    right: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconDesc(
                        icon: Icons.format_size_rounded,
                        title: 'Tamaño'
                      ),
                      Spacer(),
                      _fontSizeSlider(theme, schemeState),
                    ],
                  ),
                ),
              ],
            ),
            _settingsSection(
              children: [
                IconTitle(title: 'Almacenamiento', icon: Icons.folder_rounded),
                _resetDataButton(context, theme, schemeState, contentStyle),
                SizedBox(height: 8),
              ],
            ),
          ],
        ),
    );
  }
}
