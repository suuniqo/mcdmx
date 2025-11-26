import 'package:flutter/material.dart';
import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/style/format.dart';

class IconDesc extends StatelessWidget {
  final IconData icon;
  final String title;

  IconDesc({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(theme);

    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.onSurface),
        SizedBox(width: Format.separatorIconTitle),
        Text(title, style: contentStyle.titleItem),
      ],
    );
  }
}
