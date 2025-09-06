import 'package:flutter/material.dart';

class NoteColor {
  static const Map<int, Color> lightPalette = {
    1: Color(0xffd3d3d3), // light gray (black text visible)
    2: Color(0xffa7dbe6), // pastel teal-blue
    3: Color(0xfff6b7a3), // peachy orange
    4: Color(0xffd8a0a4), // muted pink-brown
    5: Color(0xffb9bce3), // soft lavender
    6: Color(0xffcbe5b9), // mint green
  };

  static const Map<int, Color> darkPalette = {
    1: Color(0xff393939), // dark green
    2: Color(0xff1c303b), // dark blue
    3: Color(0xffa63a20), // dark orange/red
    4: Color(0xff5a2f33), // dark red-brown
    5: Color(0xff4a4f7d), // dark purple
    6: Color(0xff2e7d32), // dark gray
  };

  static Color resolve(int id, Brightness brightness) {
    return brightness == Brightness.light
        ? lightPalette[id] ?? Colors.grey
        : darkPalette[id] ?? Colors.grey;
  }
}



// Color getTextColor(Color background) {
//   final brightness = ThemeData.estimateBrightnessForColor(background);
//   return brightness == Brightness.dark ? Colors.white : Colors.black;
// }
// final bgColor = NoteColor.lightPalette[selectedColorId] ?? Colors.grey;
// final textColor = getTextColor(bgColor);

// Container(
//   color: bgColor,
//   child: Text(
//     note.title,
//     style: TextStyle(color: textColor),
//   ),
// );

