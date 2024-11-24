import 'package:flutter/material.dart';
import 'package:telegrammy/features/messages/presentation/data/messages.dart';

class BottomBar extends StatefulWidget {
  final void Function(String) onSend;
  const BottomBar({super.key, required this.onSend});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      // Check if the TextField has text and update the icon
      setState(() {
        _isTyping = _messageController.text.isNotEmpty;
      });
    });
  }

//   void _sendMessage() {
//     // Handle sending the message
//     final message = _messageController.text.trim();
//     if (message.isNotEmpty) {
// messages.add(Message(text: message, time: DateTime.now().toString(), isSentByUser: true));
//       _messageController.clear();
//     }
//   }

  @override
  void dispose() {
    _messageController
        .dispose(); // Dispose of the controller to free up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.insert_emoticon),
          onPressed: () {
            // Add emoji picker functionality here
          },
        ),
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Type a message',
              border: InputBorder.none,
            ),
          ),
        ),
        IconButton(
          icon: Icon(_isTyping ? Icons.send : Icons.mic),
          onPressed: _isTyping
              ? () => {widget.onSend(_messageController.text.trim())}
              : () {
                  // Handle voice note functionality here
                  print('Recording voice note...');
                },
        ),
      ],
    );
  }
}
