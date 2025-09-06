import 'dart:convert';
import 'package:dot_planner/components/noteColor.dart';
import 'package:intl/intl.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../models/note_model.dart';

class NoteCard extends StatefulWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late String noteDate;
  late DateTime stringDate;
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    noteDate = widget.note.updatedAt;
    stringDate = DateTime.parse(noteDate);
    formattedDate = DateFormat.yMd().format(stringDate);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Resolve the note's colorId into a real Color
    final noteColor = isDark
        ? NoteColor.darkPalette[widget.note.color] ?? Colors.grey
        : NoteColor.lightPalette[widget.note.color] ?? Colors.grey;

    String getPlainText(String jsonBody) {
      try {
        final doc = quill.Document.fromJson(jsonDecode(jsonBody));
        return doc.toPlainText();
      } catch (e) {
        return jsonBody; // fallback if not proper JSON
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.55,
          height: 250,
          child: Card(
            color: noteColor, // ✅ use resolved Color
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      getPlainText(widget.note.body),
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        // color: Color(0xffffffff)
                        color: Theme.of(context).colorScheme.surfaceDim,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.note.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.surfaceDim,
                      // color: Color(0xffffffff),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.surfaceDim,
                      // color: Color(0xffffffff),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
