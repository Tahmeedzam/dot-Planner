import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'block_model.dart';
import 'quill_block.dart';
import 'image_block.dart';

// re-export model types so callers importing this file can access BlockType and BlockData
export 'block_model.dart';

typedef BlockUpdateCallback = void Function(BlockData updated);

/// Build the proper widget for the given block. Optionally accept an update callback.
Widget buildBlock(BlockData block, [BlockUpdateCallback? onUpdated]) {
  switch (block.type) {
    case BlockType.quill:
      final controller = block.controller!;
      final focusNode = block.focusNode!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuillBlock(controller: controller, focusNode: focusNode),
          QuillToolbarWrapper(controller: controller, focusNode: focusNode),
        ],
      );

    case BlockType.image:
      return ImageBlock(
        imagePath: block.imagePath,
        onChanged: (newPath) {
          if (onUpdated != null) {
            onUpdated(block.copyWith(imagePath: newPath));
          }
        },
      );

    default:
      return const SizedBox.shrink();
  }
}
