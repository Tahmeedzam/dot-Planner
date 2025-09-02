import 'package:dot_planner/components/noteCard.dart';
import 'package:flutter/material.dart';
import '../localDB/db_helper.dart';
import '../models/note_model.dart';

class NotesTab extends StatefulWidget {
  const NotesTab({super.key});

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  final dbHelper = DBHelper();
  List<Note> _notes = [];
  bool _loading = true;

  void _loadNotes() async {
    final data = await dbHelper.getNotes();
    setState(() {
      _notes = data.map((e) => Note.fromMap(e)).toList();
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_notes.isEmpty) {
      return const Center(child: Text("No notes yet"));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        return NoteCard(note: _notes[index]);
      },
    );
  }
}
