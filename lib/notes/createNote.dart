import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:dot_planner/localDB/db_helper.dart';
import 'package:dot_planner/models/note_model.dart';
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
  Color selectedColor = Color(0xffffffff);

  @override
  void initState() {
    super.initState();
    _controller = quill.QuillController.basic();

    // Initialize brightness after build so context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      brightness = MediaQuery.of(context).platformBrightness;
      selectedColor = brightness == Brightness.dark
          ? Color(0xff1E293B)
          : Color(0xffffffff);
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
      color: selectedColor.toARGB32(),
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
        Navigator.pop(context, false); // return false → no save
      }
      return;
    }

    int id = await dbHelper.insertNote(note.toMap());
    print('✅ Note inserted with id: $id');

    if (mounted) {
      Navigator.pop(context, true); // return true so parent can refresh
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
          children:
              [
                Color(0xff885053),
                Color(0xffd5583c),
                Color(0xff9fc687),
                Color(0xff393939),
                Color(0xff797ea8),
                Color(0xff1c303b),
                Color(0xff328da2),
              ].map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(radius: 14, backgroundColor: color),
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

    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white, // popup background
          textStyle: TextStyle(color: Colors.black), // popup text
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  // AppBar row with back button, title, and color picker
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
                              backgroundColor: selectedColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.15,
                    color: surfaceBrightColor,
                  ),
                  // Editor only, no toolbar here
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme: const TextSelectionThemeData(
                            cursorColor: Color(0xff6366F1),
                            selectionColor: Color.fromARGB(255, 113, 115, 236),
                            selectionHandleColor: Color(0xff6366F1),
                          ),
                        ),
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
              // Sticky, scrollable toolbar at the bottom, above keyboard
              Positioned(
                left: 0,
                right: 0,
                bottom: bottomInset, // aligns above keyboard
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: quill.QuillSimpleToolbar(
                      controller: _controller,
                      config: quill.QuillSimpleToolbarConfig(
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
                        color: Theme.of(
                          context,
                        ).colorScheme.tertiary, // active color
                        iconTheme: quill.QuillIconTheme(
                          iconButtonSelectedData: quill.IconButtonData(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary, // selected icon color
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Theme.of(context)
                                    .colorScheme
                                    .surfaceBright, // selected background
                              ),
                            ),
                          ),
                          iconButtonUnselectedData: quill.IconButtonData(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface, // unselected icon color
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Colors.transparent, // unselected background
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
      ),
    );
  }
}
