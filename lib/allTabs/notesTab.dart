import 'package:bounce/bounce.dart';
import 'package:dot_planner/components/noteCard.dart';
import 'package:dot_planner/notes/editNote.dart';
import 'package:flutter/material.dart';
import '../localDB/db_helper.dart';
import '../models/note_model.dart';

class NotesTab extends StatefulWidget {
  const NotesTab({super.key});

  @override
  State<NotesTab> createState() => NotesTabState();
}

class NotesTabState extends State<NotesTab> {
  final dbHelper = DBHelper();
  List<Note> _notes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final data = await dbHelper.getNotes();
    if (!mounted) return;
    setState(() {
      _notes = data.map((e) => Note.fromMap(e)).toList();
      _loading = false;
    });
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
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        return Bounce(
          tilt: false,
          onTap: () {
            final result = Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditNote(note: note), // Pass ID
              ),
            );
            if (result == true) {
              loadNotes();
            }
          },
          child: NoteCard(note: note),
        );
      },
    );
  }
}
