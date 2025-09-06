import 'dart:convert';
import 'package:dot_planner/components/noteColor.dart';
import 'package:dot_planner/localDB/db_helper.dart';
import 'package:dot_planner/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';

class EditNote extends StatefulWidget {
  final Note note;
  const EditNote({required this.note, super.key});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late TextEditingController
  noteTitle; // ✅ make late so we can initialize with note
  late quill.QuillController _controller;
  final dbHelper = DBHelper();
  final FocusNode _focusNode = FocusNode();
  late Note note;
  late int selectedColorId; // store only the ID

  @override
  void initState() {
    super.initState();
    note = widget.note;

    // ✅ Initialize controllers with existing note data
    noteTitle = TextEditingController(text: note.title);

    // Decode stored body JSON back into Quill Delta
    try {
      final json = jsonDecode(note.body);
      final doc = quill.Document.fromJson(json);
      _controller = quill.QuillController(
        document: doc,
        selection: TextSelection.collapsed(offset: doc.length - 1),
      );
    } catch (_) {
      // fallback if body was plain text
      _controller = quill.QuillController(
        document: quill.Document()..insert(0, note.body),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    selectedColorId = note.color;

    // Request focus after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    noteTitle.dispose();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ✅ Update instead of insert
  void _updateNote() async {
    final now = DateTime.now().toIso8601String();
    final updatedNote = Note(
      id: note.id, // keep same ID
      title: noteTitle.text,
      body: jsonEncode(_controller.document.toDelta().toJson()),
      color: selectedColorId,
      createdAt: note.createdAt, // preserve original createdAt
      updatedAt: now, // update modified time
    );

    await dbHelper.updateNote(
      updatedNote.toMap(),
      note.id!,
    ); // <- update instead of insert
    print('✅ Note updated with id: ${note.id}');
    if (mounted) {
      Navigator.pop(context, true); // return true so parent can refresh
    }
  }

  Color resolveColor(BuildContext context, int id) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = isDark ? NoteColor.darkPalette : NoteColor.lightPalette;
    return palette[id] ?? Colors.grey; // fallback
  }

  String convertJsonToPlainText(String jsonData) {
    try {
      // Parse JSON string into Delta
      final delta = Delta.fromJson(jsonDecode(jsonData));

      // Create a QuillDocument
      final document = quill.Document.fromDelta(delta);

      // Extract plain text
      return document.toPlainText();
    } catch (e) {
      return 'Error converting note';
    }
  }

  void _showColorPickerDialog() {
    final ids = NoteColor.lightPalette.keys.toList(); // same ids in dark

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick a color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ids.map((id) {
            final color = resolveColor(context, id);
            final isSelected = selectedColorId == id;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColorId = id; // ✅ just ID
                });
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: color,
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final surfaceBrightColor = Theme.of(context).colorScheme.surfaceBright;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final brightness = Theme.of(context).brightness;
    final resolvedColor =
        (brightness == Brightness.dark
            ? NoteColor.darkPalette[selectedColorId]
            : NoteColor.lightPalette[selectedColorId]) ??
        Colors.grey;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                // ✅ Header row (back button + title + color picker)
                Container(
                  padding: const EdgeInsets.only(left: 4, top: 8, bottom: 8),
                  color: resolveColor(context, selectedColorId),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _updateNote,
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      Expanded(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: const TextSelectionThemeData(
                              cursorColor: Color(0xff6366F1),
                              selectionColor: Color.fromARGB(
                                255,
                                113,
                                115,
                                236,
                              ),
                              selectionHandleColor: Color(0xff6366F1),
                            ),
                          ),
                          child: TextField(
                            controller: noteTitle,
                            maxLength: 20,
                            buildCounter:
                                (
                                  BuildContext context, {
                                  int? currentLength,
                                  int? maxLength,
                                  required bool isFocused,
                                }) => null,
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
                              overflow: TextOverflow.ellipsis,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: Theme.of(context).colorScheme.surfaceBright,
                        ),
                        onSelected: (value) {
                          if (value == 'copy') {
                            Clipboard.setData(
                              ClipboardData(
                                text: convertJsonToPlainText(note.body),
                              ),
                            );
                          } else if (value == 'delete') {
                            dbHelper.deleteNote(note.id!);
                            Navigator.pop(context);
                          } else if (value == 'color') {
                            _showColorPickerDialog();
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'copy',
                            child: Text('Copy'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                          PopupMenuItem(
                            value: 'color',
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surfaceBright,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: resolvedColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 0.15, color: surfaceBrightColor),

                // ✅ Body editor
                Expanded(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.grey,
                      textTheme: Theme.of(context).textTheme.copyWith(
                        bodyMedium: const TextStyle(
                          color: Colors.grey,
                        ), // dropdown items color
                      ),
                      dialogTheme: DialogThemeData(
                        backgroundColor: Colors.grey,
                      ),
                      textSelectionTheme: const TextSelectionThemeData(
                        cursorColor: Color(0xff6366F1),
                        selectionColor: Color.fromARGB(104, 113, 115, 236),
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
                          checkBoxReadOnly: false,
                          expands: true,
                          autoFocus: true,
                          scrollable: true,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ✅ Sticky toolbar at bottom
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
