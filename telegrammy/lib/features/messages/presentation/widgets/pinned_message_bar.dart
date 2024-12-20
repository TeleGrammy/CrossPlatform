import 'package:flutter/material.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';

class PinnedMessageBar extends StatelessWidget {
  final Message pinnedMessage;
  final VoidCallback onTap;

  const PinnedMessageBar({
    Key? key,
    required this.pinnedMessage,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.push_pin, color: Colors.orangeAccent),
            Expanded(
              child: Text(
                pinnedMessage.content,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Icon(Icons.arrow_forward, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
