import 'package:flutter/material.dart';
import 'package:mcdmx/style/font_mul.dart';
import 'package:mcdmx/style/theme_hue.dart';

class SchemeState extends ChangeNotifier {
  ThemeMode _themeMode;
  double _themeHue = ThemeHue.base;
  double _fontMul = FontMul.base;

  SchemeState(BuildContext context)
    : _themeMode =
          (MediaQuery.of(context).platformBrightness == Brightness.dark)
          ? ThemeMode.dark
          : ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  double get fontMul => _fontMul;
  double get themeHue => _themeHue;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setFontMul(double fontMul) {
    _fontMul = fontMul.clamp(FontMul.min, FontMul.max);

    notifyListeners();
  }

  void setThemeHue(double themeHue) {
    _themeHue = themeHue.clamp(ThemeHue.min, ThemeHue.max);

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
