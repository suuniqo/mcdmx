import 'package:flutter/material.dart';
import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/style/format.dart';

class IconFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final String msg;
  final IconData icon;
  final bool center;
  final Color color;
  final double elevation;

  IconFAB({
    required this.onPressed,
    required this.msg,
    required this.icon,
    required this.color,
    required this.center,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(theme);

    return SizedBox(
      width: double.infinity,
      child: FloatingActionButton(
        heroTag: null,
        backgroundColor: color,
        highlightElevation: 0,
        elevation: elevation,
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: !center
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(icon, color: theme.colorScheme.primary),
                    SizedBox(width: Format.separatorIconTitle),
                    Text(
                      msg,
                      style: contentStyle.titleItem.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: theme.colorScheme.primary),
                    SizedBox(width: Format.separatorIconTitle),
                    Text(
                      msg,
                      style: contentStyle.titleItem.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 1.6 * Format.separatorIconTitle),
                  ],
                ),
        ),
      ),
    );
  }
}
