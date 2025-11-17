import 'package:flutter/material.dart';

class ContentStyle {
  final TextStyle titlePrimary;
  final TextStyle titleSecondary;
  final TextStyle titleItem;

  ContentStyle.fromTheme(final ThemeData theme)
    : titlePrimary = theme.textTheme.displayMedium!.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
      titleSecondary = theme.textTheme.headlineMedium!.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      ),
      titleItem = theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      );
}
