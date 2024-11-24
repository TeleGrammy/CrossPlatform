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
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              repliedMessage.text,
              style: TextStyle(fontSize: 14, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}
