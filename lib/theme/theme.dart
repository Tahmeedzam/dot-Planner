import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  menuTheme: MenuThemeData(
    style: MenuStyle(
      backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
    ),
  ),
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

    //Notes color
    //Default
    primaryContainer: Color(0xfff5f5f5), // soft near-white
    onPrimaryContainer: Color(0xff9fc687), // light green

    secondaryContainer: Color(0xffeaf4fc), // pale sky blue
    onSecondaryContainer: Color(0xff328da2), // teal/blue

    tertiaryContainer: Color(0xfffff3e1), // soft cream
    onTertiaryContainer: Color(0xffd5583c), // light orange
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.white, // popup background for light
    textStyle: TextStyle(color: Colors.black), // popup text for light
  ),
);

ThemeData darkMode = ThemeData(
  menuTheme: MenuThemeData(
    style: MenuStyle(
      backgroundColor: WidgetStatePropertyAll<Color>(Colors.grey[900]!),
    ),
  ),
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

    //Notes color
    //Default
    primaryContainer: Color(0xff1c1c1e), // near black
    onPrimaryContainer: Color(0xff2e7d32), // dark green

    secondaryContainer: Color(0xff102a43), // deep navy
    onSecondaryContainer: Color(0xff1c303b), // dark teal/blue

    tertiaryContainer: Color(0xff2e1f27), // dark burgundy
    onTertiaryContainer: Color(0xff885053), // muted dark orange-brown
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
