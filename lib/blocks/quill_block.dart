import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class QuillBlock extends StatelessWidget {
  final quill.QuillController controller;
  final FocusNode focusNode;

  const QuillBlock({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.grey,
        textTheme: Theme.of(context).textTheme.copyWith(
          bodyMedium: const TextStyle(
            color: Colors.grey, // dropdown items color
          ),
        ),
        dialogTheme: DialogThemeData(backgroundColor: Colors.grey),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xff6366F1),
          selectionColor: Color.fromARGB(104, 113, 115, 236),
          selectionHandleColor: Color(0xff6366F1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IntrinsicHeight(
          child: quill.QuillEditor(
            controller: controller,
            focusNode: focusNode,
            scrollController: ScrollController(),
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
    );
  }
}

class QuillToolbarWrapper extends StatefulWidget {
  final quill.QuillController controller;
  final FocusNode focusNode;

  const QuillToolbarWrapper({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  State<QuillToolbarWrapper> createState() => _QuillToolbarWrapperState();
}

class _QuillToolbarWrapperState extends State<QuillToolbarWrapper> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() {}); // rebuild when focus changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.focusNode.hasFocus, // ✅ only when typing
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: quill.QuillSimpleToolbar(
            controller: widget.controller,
            config: quill.QuillSimpleToolbarConfig(
              buttonOptions: const quill.QuillSimpleToolbarButtonOptions(
                base: quill.QuillToolbarColorButtonOptions(),
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
    );
  }
}
