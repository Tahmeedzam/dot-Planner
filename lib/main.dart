import 'package:dot_planner/notesPage.dart';
import 'package:dot_planner/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dot.',
      // theme: lightMode,
      theme: darkMode,
      home: NotesPage(),
    );
  }
}
