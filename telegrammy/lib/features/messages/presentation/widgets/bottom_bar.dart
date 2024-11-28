import 'package:flutter/material.dart';
import 'package:telegrammy/features/messages/presentation/data/messages.dart';

class BottomBar extends StatefulWidget {
  final void Function(String) onSend;
  final void Function(Message, String) onEdit;
  final Message? editedMessage;
  const BottomBar(
      {super.key,
      required this.onSend,
      required this.onEdit,
      this.editedMessage});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _initializeMessage();
    _messageController.addListener(() {
      setState(() {
        _isTyping = _messageController.text.isNotEmpty;
      });
    });
  }

  @override
  void didUpdateWidget(covariant BottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editedMessage != oldWidget.editedMessage) {
      _initializeMessage();
    }
  }

  void _initializeMessage() {
    if (widget.editedMessage != null) {
      _messageController.text = widget.editedMessage!.text;
      _isTyping = true;
    } else {
      _messageController.clear();
      _isTyping = false;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
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
              ? () {
                  if (widget.editedMessage == null) {
                    widget.onSend(_messageController.text.trim());
                  } else {
                    widget.onEdit(
                        widget.editedMessage!, _messageController.text.trim());
                  }
                }
              : () {
                  // Handle voice note functionality here
                  print('Recording voice note...');
                },
        ),
      ],
    );
  }
}
