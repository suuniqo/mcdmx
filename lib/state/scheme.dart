import 'package:flutter/material.dart';
import 'package:mcdmx/style/font_mul.dart';

class SchemeState extends ChangeNotifier {
  ThemeMode _themeMode;
  double _fontMul = FontMul.base;

  SchemeState(BuildContext context)
    : _themeMode =
          (MediaQuery.of(context).platformBrightness == Brightness.dark)
          ? ThemeMode.dark
          : ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  double get fontMul => _fontMul;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setFontMul(double fontMul) {
    _fontMul = fontMul.clamp(FontMul.min, FontMul.max);

    notifyListeners();
  }

  void toggleThemeMode() {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    notifyListeners();
  }

  void restore() {
    _fontMul = FontMul.base;
    _themeMode = ThemeMode.system;

    notifyListeners();
  }
}
