import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';
import 'package:intl/intl.dart';
import '../models/note_model.dart';
import '../components/noteColor.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final List<Map<String, dynamic>> blocks;

  const NoteCard({super.key, required this.note, required this.blocks});

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    try {
      final date = DateTime.parse(widget.note.updatedAt);
      formattedDate = DateFormat.yMd().format(date);
    } catch (_) {
      formattedDate = widget.note.updatedAt;
    }
  }

  List<Widget> buildBlockPreviews() {
    List<Widget> previews = [];
    int maxLines = 6;
    int usedLines = 0;
    bool imageAdded = false;

    for (var block in widget.blocks) {
      final type = block['type'];
      final data = block['data'];

      // Handle text
      if (type == 'quill' && data != null) {
        final deltaList = (data is String) ? jsonDecode(data) : data;
        final doc = quill.Document.fromDelta(Delta.fromJson(deltaList));
        final text = doc.toPlainText().trim();
        if (text.isEmpty) continue;

        // Count lines in this text block
        int blockLines =
            '\n'.allMatches(text).length + 1; // approximate line count

        // Add only as many lines as remaining
        int remainingLines = maxLines - usedLines;
        if (remainingLines <= 0) break; // max reached

        previews.add(
          Text(
            text,
            style: const TextStyle(fontSize: 14),
            maxLines: remainingLines,
            overflow: TextOverflow.ellipsis,
          ),
        );
        usedLines += blockLines;
      }

      // Handle image
      if (!imageAdded && type == 'image' && data != null) {
        // Only add image if remaining lines >= 2 (rough estimate)
        int remainingLines = maxLines - usedLines;
        if (remainingLines <= 2) continue;

        final dataMap = (data is String) ? jsonDecode(data) : data;
        final path = dataMap['path'];
        if (path != null) {
          previews.add(
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Text(path, maxLines: 3),
              ),
            ),
          );
          imageAdded = true;
        }
      }
    }

    if (previews.isEmpty) previews.add(const SizedBox.shrink());
    return previews;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final noteColor =
        (isDark
            ? NoteColor.darkPalette[widget.note.color]
            : NoteColor.lightPalette[widget.note.color]) ??
        Colors.grey;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.55,
      child: Card(
        color: noteColor,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...buildBlockPreviews(),
              const SizedBox(height: 8),
              Spacer(),
              Text(
                widget.note.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.surfaceDim,
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
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
