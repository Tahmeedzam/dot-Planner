import 'dart:convert';
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
  quill.QuillController _controller = quill.QuillController.basic();
  late Brightness brightness;
  final dbHelper = DBHelper();
  final FocusNode _focusNode = FocusNode();

  int selectedColorId = 1; // default color id

  @override
  void initState() {
    super.initState();
    _controller = quill.QuillController.basic();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      brightness = MediaQuery.of(context).platformBrightness;
      FocusScope.of(context).requestFocus(_focusNode);
      setState(() {});
    });
  }

  @override
  void dispose() {
    noteTitle.dispose();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _saveNote() async {
    final now = DateTime.now().toIso8601String();
    final date = DateTime.now();
    final compactDate = DateFormat('ddMMyyyy').format(date).toString();
    bool canSave = false;
    final plainText = _controller.document.toPlainText().trim();

    var note = Note(
      title: noteTitle.text,
      body: jsonEncode(_controller.document.toDelta().toJson()),
      color: selectedColorId, // ✅ store id, not raw Color
      createdAt: now,
      updatedAt: now,
    );

    if (note.title.isEmpty && plainText.isNotEmpty) {
      canSave = true;
      note = Note(
        title: compactDate,
        body: note.body,
        color: note.color,
        createdAt: now,
        updatedAt: now,
      );
    }

    if (note.title.isEmpty && plainText.isEmpty) {
      if (mounted) {
        Navigator.pop(context, false);
      }
      return;
    }

    int id = await dbHelper.insertNote(note.toMap());
    print('✅ Note inserted with id: $id');

    if (mounted) {
      Navigator.pop(context, true);
    }
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
                setState(() {
                  selectedColorId = id; // ✅ store ID
                });
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

  @override
  Widget build(BuildContext context) {
    brightness = Theme.of(context).brightness;
    final surfaceBrightColor = Theme.of(context).colorScheme.surfaceBright;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // AppBar row
            Container(
              padding: const EdgeInsets.only(left: 4, top: 8, bottom: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _saveNote,
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  // Title TextField with custom cursor
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: const TextSelectionThemeData(
                          cursorColor: Color(0xff6366F1),
                          selectionColor: Color.fromARGB(60, 113, 115, 236),
                          selectionHandleColor: Color(0xff6366F1),
                        ),
                      ),
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
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: _showColorPickerDialog,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: NoteColor.resolve(
                          selectedColorId,
                          brightness,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 0.15, color: surfaceBrightColor),

            // Editor
            // Quill Editor with custom cursor
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: Color(0xff6366F1),
                    selectionColor: Color.fromARGB(60, 113, 115, 236),
                    selectionHandleColor: Color(0xff6366F1),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: quill.QuillEditor.basic(
                    controller: _controller,
                    scrollController: ScrollController(),
                    focusNode: _focusNode,
                    config: quill.QuillEditorConfig(
                      placeholder: 'Start writing your note...',
                      showCursor: true,
                      expands: true,
                      autoFocus: true,
                      scrollable: true,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),

            // Toolbar
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: quill.QuillSimpleToolbar(
                    controller: _controller,
                    config: quill.QuillSimpleToolbarConfig(
                      buttonOptions: quill.QuillSimpleToolbarButtonOptions(
                        base: quill.QuillToolbarColorButtonOptions(
                          iconTheme: quill.QuillIconTheme(
                            iconButtonSelectedData: quill.IconButtonData(
                              color: Theme.of(context).colorScheme.primary,
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context).colorScheme.surfaceBright,
                                ),
                              ),
                            ),
                            iconButtonUnselectedData: quill.IconButtonData(
                              color: Theme.of(context).colorScheme.onSurface,
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      showFontFamily: false,
                      showBoldButton: true,
                      showItalicButton: true,
                      showUnderLineButton: true,
                      showListBullets: true,
                      showUndo: true,
                      showRedo: true,
                      showClearFormat: true,
                      showColorButton: true,
                      showBackgroundColorButton: true,
                      showFontSize: true,
                      showQuote: false,
                      showCodeBlock: false,
                      showInlineCode: false,
                      showSubscript: false,
                      showSuperscript: false,
                      showLink: false,
                      showAlignmentButtons: false,
                      showSearchButton: false,
                      showCenterAlignment: false,
                      showJustifyAlignment: false,
                      showLeftAlignment: false,
                      showRightAlignment: false,
                      showIndent: false,
                      color: Theme.of(context).colorScheme.tertiary,
                      iconTheme: quill.QuillIconTheme(
                        iconButtonSelectedData: quill.IconButtonData(
                          color: Theme.of(context).colorScheme.primary,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.surfaceBright,
                            ),
                          ),
                        ),
                        iconButtonUnselectedData: quill.IconButtonData(
                          color: Theme.of(context).colorScheme.onSurface,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
