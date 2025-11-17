import 'package:mcdmx/widgets/titled_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:mcdmx/state/scheme.dart';
import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/scheme/font_size.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final contentStyle = ContentStyle.fromTheme(theme);
    final schemeState = context.watch<SchemeState>();

    return TitledPage(
        title: 'Settings',
        child: ListView(
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.color_lens,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        'Appearance',
                        style: contentStyle.titleSecondary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.dark_mode_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Dark Mode',
                            style: contentStyle.titleItem,
                          ),
                          Spacer(),
                          Switch(
                            inactiveTrackColor: theme.colorScheme.surface,
                            value: schemeState.darkMode,
                            onChanged: (_) => schemeState.toggleTheme(),
                          ),
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
                          Icon(
                            Icons.format_size_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Font Size',
                            style: contentStyle.titleItem,
                          ),
                          Spacer(),
                          Slider(
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.folder_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        'Storage',
                        style: contentStyle.titleSecondary,
                      ),
                    ),
                    Padding(
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
                                    title: Text('Clear Data?'),
                                    content: Text(
                                      'All app data will be erased.\nThis action cannot be undone.',
                                    ),
                                    alignment: Alignment.center,
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text('Clear'),
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
                                    'Clear Data',
                                    style: contentStyle.titleItem,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}
