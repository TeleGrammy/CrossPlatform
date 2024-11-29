import 'package:flutter/material.dart';
import 'package:telegrammy/features/messages/presentation/data/messages.dart';

class ReplyPreview extends StatelessWidget {
  final Message repliedMessage;
  final VoidCallback onCancel;

  const ReplyPreview({
    super.key,
    required this.repliedMessage,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('reply_preview_container'),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        key: Key('reply_preview_row_${repliedMessage.id}'),
        children: [
          Expanded(
            child: Text(
              repliedMessage.text,
              key: Key('reply_preview_text_${repliedMessage.id}'),
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            key: const Key('reply_preview_cancel_button'),
            icon: const Icon(Icons.close),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}
