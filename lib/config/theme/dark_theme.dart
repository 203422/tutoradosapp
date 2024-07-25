import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color(0xff121212),
    primary: Color(0xff725F96),
    secondary: Color(0xFFD3BBFF),
    tertiary: Color(0xffc7bfd5),
    primaryContainer: Color(0xFF2F2F2F), //Cards
    secondaryContainer: Color(0xff3c3c3c), //FormInput
    tertiaryContainer: Color(0xFF474747), //FormInput form
    onSurface: Color(0xffd2d2d2),
    onPrimary: Color(0xffffffff),
    onPrimaryContainer: Color(0xFFE8E8E8),
    onSecondaryContainer: Color(0xFFF7F7F7),
    onTertiaryContainer: Color(0xFFffffff),
  ),
  fontFamily: 'Manrope',
);
