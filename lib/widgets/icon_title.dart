import 'package:flutter/material.dart';
import 'package:mcdmx/style/content.dart';

class IconTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  IconTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(theme);

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurface),
      title: Text(title, style: contentStyle.titleSecondary),
    );
  }
}
