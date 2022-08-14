import 'package:flutter/material.dart';

import '../utils/ThemeColor.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData = beigeTheme;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  String _fontStyle = 'DancingScript';

  getFont() => _fontStyle;

  setFont(String font) {
    _fontStyle = font;
    notifyListeners();
  }
}