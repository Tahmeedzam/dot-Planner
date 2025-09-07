import 'dart:convert';
import 'package:dot_planner/blocks/block_builder.dart' as builder;
import 'package:dot_planner/blocks/block_model.dart';
import 'package:intl/intl.dart';
import 'package:dot_planner/localDB/db_helper.dart';
import 'package:dot_planner/models/note_model.dart';
import 'package:dot_planner/components/noteColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final TextEditingController noteTitle = TextEditingController();
  late Brightness brightness;
  final dbHelper = DBHelper();

  int selectedColorId = 1; // default color id

  final List<builder.BlockData> blocks = [];

  @override
  void initState() {
    super.initState();
    // Start with 1 quill block by default
    blocks.add(
      builder.BlockData(
        type: BlockType.quill,
        controller: quill.QuillController.basic(),
        focusNode: FocusNode(),
      ),
    );
  }

  @override
  void dispose() {
    noteTitle.dispose();
    for (var block in blocks) {
      block.focusNode?.dispose();
      block.controller?.dispose();
    }
    super.dispose();
  }

  void _saveNote() async {
    final now = DateTime.now().toIso8601String();
    final date = DateTime.now();
    final compactDate = DateFormat('ddMMyyyy').format(date);

    final titleText = noteTitle.text.isEmpty ? compactDate : noteTitle.text;

    final noteMap = {
      'title': titleText,
      'color': selectedColorId,
      'created_at': now,
      'updated_at': now,
    };

    final blockMaps = blocks
        .where((block) {
          if (block.type == BlockType.quill) {
            return (block.controller?.document
                    .toPlainText()
                    .trim()
                    .isNotEmpty ??
                false);
          }
          if (block.type == BlockType.image) {
            return block.imagePath != null;
          }
          return true;
        })
        .map((block) {
          if (block.type == BlockType.quill && block.controller != null) {
            return {
              'type': 'quill',
              'data': jsonEncode(block.controller!.document.toDelta().toJson()),
            };
          } else if (block.type == BlockType.image && block.imagePath != null) {
            return {
              'type': 'image',
              'data': jsonEncode({'path': block.imagePath}),
            };
          } else {
            return {
              'type': block.type.toString().split('.').last,
              'data': jsonEncode(block.data ?? {}),
            };
          }
        })
        .toList();

    int noteId = await dbHelper.insertNoteWithBlocks(noteMap, blockMaps);
    print('✅ Note inserted with id: $noteId');
    if (mounted) Navigator.pop(context, true);
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick a color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: NoteColor.lightPalette.keys.map((id) {
            return GestureDetector(
              onTap: () {
                setState(() => selectedColorId = id);
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 14,
                backgroundColor: NoteColor.resolve(id, brightness),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _addBlock(BlockType type) {
    setState(() {
      blocks.add(
        builder.BlockData(
          type: type,
          controller: type == BlockType.quill
              ? quill.QuillController.basic()
              : null,
          focusNode: type == BlockType.quill ? FocusNode() : null,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    brightness = Theme.of(context).brightness;
    final surfaceBrightColor = Theme.of(context).colorScheme.surfaceBright;

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show a simple dialog to pick block type
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Add Block"),
                content: Wrap(
                  spacing: 8,
                  children: BlockType.values.map((type) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _addBlock(type);
                      },
                      child: Text(type.name),
                    );
                  }).toList(),
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _saveNote,
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
                        fontFamily: 'InterBold',
                        fontSize: 18,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showColorPickerDialog,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: NoteColor.resolve(
                        selectedColorId,
                        brightness,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 0.15, color: surfaceBrightColor),
            Expanded(
              child: ListView.builder(
                itemCount: blocks.length,
                itemBuilder: (context, index) {
                  final block = blocks[index];
                  return builder.buildBlock(block, (updated) {
                    setState(() => blocks[index] = updated);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
