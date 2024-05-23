import 'package:flutter/material.dart';

import '../constant/app_color.dart';
import '../constant/app_fonts.dart';

final ThemeData lightTheme = ThemeData(
  fontFamily: AppFonts.montserrat,
  brightness: Brightness.light,
  primaryColor: AppColor.lightPrimaryColor,
  useMaterial3: true,
  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: AppColor.lightTitleColor,
    ),
    titleSmall: TextStyle(
      color: AppColor.lightSubtitleColor,
    ),
    bodyMedium: TextStyle(
      shadows: [
        Shadow(
          color: AppColor.lightShadowColor,
        ),
      ],
    ),
  ),
  colorScheme:
      ColorScheme.light().copyWith(secondary: AppColor.lightAccentColor),
);

final ThemeData darkTheme = ThemeData(
  fontFamily: AppFonts.montserrat,
  brightness: Brightness.dark,
  primaryColor: AppColor.darkPrimaryColor,
  useMaterial3: true,
  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: AppColor.darkTitleColor,
    ),
    titleSmall: TextStyle(
      color: AppColor.darkSubtitleColor,
    ),
    bodyMedium: TextStyle(
      shadows: [
        Shadow(
          color: AppColor.darkShadowColor,
        ),
      ],
    ),
  ),
  colorScheme:
      ColorScheme.dark().copyWith(secondary: AppColor.darkAccentColor),
);

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;

  ThemeChanger(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}

enum MyThemeKeys { LIGHT, DARK }

class MyTheme {
  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}
