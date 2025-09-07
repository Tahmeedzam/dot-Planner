// lib/blocks/block_model.dart
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

enum BlockType { quill, image, drawing, table, audio, embed }

class BlockData {
  final BlockType type;
  final quill.QuillController? controller;
  final FocusNode? focusNode;
  final Map<String, dynamic>? data; // extra per-block payload
  final String? imagePath;

  BlockData({
    required this.type,
    this.controller,
    this.focusNode,
    this.data,
    this.imagePath,
  });

  // convenience copyWith if you need to update block and pass back
  BlockData copyWith({
    quill.QuillController? controller,
    FocusNode? focusNode,
    Map<String, dynamic>? data,
    String? imagePath,
  }) {
    return BlockData(
      type: type,
      controller: controller ?? this.controller,
      focusNode: focusNode ?? this.focusNode,
      data: data ?? this.data,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
