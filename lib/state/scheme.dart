import 'package:flutter/material.dart';

import 'package:mcdmx/scheme/color_theme.dart';
import 'package:mcdmx/scheme/font_size.dart';

class SchemeState extends ChangeNotifier {
  bool _darkMode = ColorTheme.baseIsDark;
  double _fontSize = FontSize.base;

  bool get darkMode => _darkMode;
  double get fontSize => _fontSize;
  ThemeData get themeData => _darkMode ? ColorTheme.dark : ColorTheme.light;

  void setFontSize(double fontSize) {
    _fontSize = fontSize.clamp(FontSize.min, FontSize.max);

    notifyListeners();
  }

  void toggleTheme() {
    _darkMode = !darkMode;

    notifyListeners();
  }

  void restore() {
    _fontSize = FontSize.base;
    _darkMode = ColorTheme.baseIsDark;

    notifyListeners();
  }
}
