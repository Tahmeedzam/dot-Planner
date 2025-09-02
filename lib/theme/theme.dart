import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    // Background (Scaffold)
    primary: Color(0xffF9FAFB),

    // Card background (light equivalent of 0xff181818)
    // secondary: Color(0xffFFFFFF),

    // Text (dark text instead of white)
    surfaceDim: Color(0xff111827),

    // Secondary Text
    surfaceBright: Color(0xff6B7280),

    //Notes Text: (little cream)
    surfaceContainer: Color(0xffFAFAF7),

    //Notes color for dark notes:

    // Line color (light grey instead of 0xff333333)
    // onPrimary: Color(0xffDDDDDD),

    // Purple -  main color
    tertiary: Color(0xff6366F1),

    // Transparent
    onTertiary: Colors.transparent,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.white, // popup background for light
    textStyle: TextStyle(color: Colors.black), // popup text for light
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    // Background (Scaffold)
    primary: Color(0xff121212),

    // Card background (light equivalent of 0xff181818)
    // secondary: Color(0xffFFFFFF),

    // Text (dark text instead of white)
    surfaceDim: Color(0xffEDEDED),

    // Secondary Text
    surfaceBright: Color(0xffA0A0A0),

    //Notes Text: (little cream)
    surfaceContainer: Color(0xffFAFAF7),

    // Line color (light grey instead of 0xff333333)
    // onPrimary: Color(0xffDDDDDD),

    // Purple -  main color
    tertiary: Color(0xff6366F1),

    // Transparent
    onTertiary: Colors.transparent,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.grey[900], // popup background for dark
    textStyle: TextStyle(color: Colors.white), // popup text for dark
  ),
);

// Divider(
//thickness: 4,
//radius: BorderRadius.circular(2),
//color: Theme.of(
//context,
//).colorScheme.onPrimary.withAlpha(80),
//),

// gradient: LinearGradient(
// colors: [
//   Color(0xff009C47),
//   Color(0xff00C853),
// ],
// stops:[0.1, 0.71],
// begin:Alignment.topLeft,
// end:Alignment.bottomRight,
// )
