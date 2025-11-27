import 'package:flutter/material.dart';

class ContentStyle {
  final TextStyle titlePrimary;
  final TextStyle titleSecondary;
  final TextStyle titleTertiary;
  final TextStyle titleSecondaryEmph;
  final TextStyle titleItem;
  final TextStyle descItem;

  ContentStyle.fromTheme(final ThemeData theme)
    : titlePrimary = theme.textTheme.displayMedium!.copyWith(
        fontWeight: FontWeight.bold,
      ),
      titleSecondary = theme.textTheme.headlineMedium!.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleTertiary = theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleSecondaryEmph = theme.textTheme.headlineLarge!.copyWith(
        fontSize: 35,
        fontWeight: FontWeight.w600,
      ),
      titleItem = theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
      ),
      descItem = theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w400,
      );
}
