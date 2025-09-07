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
  List<Map<String, dynamic>> _notesWithBlocks = []; // ✅ note + blocks
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    setState(() {
      _loading = true;
    });

    final data = await dbHelper.getNotesWithBlocks(); // fetch notes + blocks
    if (!mounted) return;

    setState(() {
      _notesWithBlocks = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_notesWithBlocks.isEmpty) {
      return const Center(child: Text("No notes yet"));
    }

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: _notesWithBlocks.length,
      itemBuilder: (context, index) {
        final noteMap = _notesWithBlocks[index];
        final note = noteMap['note'] as Note;
        final blocks = noteMap['blocks'] as List<Map<String, dynamic>>;

        return Bounce(
          tilt: false,
          onTap: () async {
            // final result = await Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (_) => EditNote(note: note)),
            // );
            // if (result == true) {
            //   loadNotes();
            // }
          },
          child: NoteCard(
            note: note,
            blocks: blocks, // ✅ pass blocks here
          ),
        );
      },
    );
  }
}
