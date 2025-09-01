import 'package:dot_planner/addNote/createNote.dart';
import 'package:dot_planner/notesPage.dart';
import 'package:dot_planner/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://ydpzydnpvwbjrguvxbgz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlkcHp5ZG5wdndianJndXZ4Ymd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY3NTA3NTEsImV4cCI6MjA3MjMyNjc1MX0.iVfzKcDSMIO1AWd8aB4DGGrFgG0zFPcTKgu3Oeusjrw',
  );
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
