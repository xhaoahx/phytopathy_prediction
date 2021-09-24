import 'package:flutter/material.dart';

class APPThemeData {
  static const primary = Color(0xFF75876A);
  static const primaryLight = Color(0xFFE4E4D6);
  static const secondary = Color(0xFF00C2A4);
  static const secondaryLight = Color(0xFF00DF4E);
  static const canvas = Color(0xFFFAFBF8);
  static const surface = Color(0xFFFFFFFF);
  static const error = Color(0xFFBF0000);

  // static const colorScheme = ColorScheme(
  //   // primary: Color(primary),
  //   // primaryVariant: Color(primaryVariant),
  //   // secondary: Color(secondary),
  //   // secondaryVariant: Color(secondaryVariant),
  //   // surface: Color(surface),
  //   // background: Color(background),
  //   // error: Color(error),
  //   // onPrimary: Color(surface),
  //   // onSecondary: Color(surface),
  //   // onSurface: Color(surface),
  //   // onBackground: Color(surface),
  //   // onError: Color(surface),
  //   // brightness: Brightness.light,
  // );

  static final themeData = ThemeData(
    primaryColor: primary,
    canvasColor: canvas,
    primaryColorLight: primaryLight,
    toggleableActiveColor: primary,
    unselectedWidgetColor: primaryLight,
    buttonColor: secondary,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryLight,
      selectionColor: primaryLight,
      selectionHandleColor: primaryLight,
    ),
    accentColor: secondary,
    disabledColor: Colors.grey.withOpacity(0.5),
    textTheme: Typography.material2018().black.apply(fontFamily: 'green'),
  );
}
