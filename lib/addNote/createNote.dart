import 'package:dot_planner/dbFunctions/createItems.dart';
import 'package:dot_planner/localDB/db_helper.dart';
import 'package:dot_planner/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final TextEditingController noteTitle = TextEditingController();
  final TextEditingController noteBody = TextEditingController();
  final FocusNode bodyFocus = FocusNode();

  final dbHelper = DBHelper();

  void _saveNote() async {
    final now = DateTime.now().toIso8601String();
    final note = Note(
      title: noteTitle.text,
      body: noteBody.text,
      color: 0xffa0a0a0,
      createdAt: now,
      updatedAt: now,
    );

    int id = await dbHelper.insertNote(note.toMap());
    print('✅ Note inserted with id: $id');

    Navigator.pop(context, true); // return to notes list
  }

  @override
  void initState() {
    super.initState();
    // Delay focus request slightly so it happens after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(bodyFocus);
    });
  }

  @override
  void dispose() {
    noteTitle.dispose();
    noteBody.dispose();
    bodyFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceBrightColor = Theme.of(context).colorScheme.surfaceBright;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Sticky Header
            Container(
              padding: const EdgeInsets.only(left: 4, top: 8, bottom: 8),
              child: Row(
                children: [
                  IconButton(
                    // color: Color(0xffa0a0a0),
                    //todo: Later save it in HIVE storage
                    onPressed: () async {
                      _saveNote();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: noteTitle,
                      decoration: InputDecoration(
                        hintText: "Untitled",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          color: surfaceBrightColor,
                          fontSize: 18,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.15,
              color: Theme.of(context).colorScheme.surfaceBright,
            ),
            // Body takes all remaining space
            Expanded(
              child: TextField(
                controller: noteBody,
                focusNode: bodyFocus,
                maxLines: null, // expands as user types
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Start writing your note...",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  hintStyle: TextStyle(color: surfaceBrightColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
