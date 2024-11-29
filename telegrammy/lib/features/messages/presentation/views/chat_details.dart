import 'package:flutter/material.dart';
import 'package:telegrammy/features/messages/presentation/data/messages.dart';
import 'package:telegrammy/features/messages/presentation/widgets/bottom_bar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/chat_appbar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/chat_details_body.dart';
import 'package:telegrammy/features/messages/presentation/widgets/reply_preview.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_appbar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_bottom_bar.dart';

class ChatDetails extends StatefulWidget {
  final String participantNames;

  const ChatDetails({Key? key, required this.participantNames})
      : super(key: key); // Key for ChatDetails widget

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  Message? _selectedMessage;
  Message? _repliedMessage;
  Message? _editedMessage;

  void _onMessageTap(Message message) {
    setState(() {
      _selectedMessage = message;
    });
  }

  void _onMessageSwipe(Message message) {
    setState(() {
      _repliedMessage = message;
    });
  }

  void _clearReply() {
    setState(() {
      _repliedMessage = null;
      _editedMessage = null;
    });
  }

  void _onSendAudio(Message message) {
    setState(() {
      messages.add(message);
    });
  }

  void _onClickEdit() {
    setState(() {
      _editedMessage = _selectedMessage;
      _repliedMessage = _selectedMessage!.repliedTo;
      _selectedMessage = null;
    });
  }

  void _onClickDelete() {
    setState(() {
      messages.add(Message(
        text: "message has been deleted",
        time: DateTime.now().toString(),
        isSentByUser: true,
        repliedTo: null,
      ));
      _clearReply();
    });
  }

  void _onSend(String text) {
    if (text.trim().isNotEmpty) {
      setState(() {
        messages.add(Message(
          text: text,
          time: DateTime.now().toString(),
          isSentByUser: true,
          repliedTo: _repliedMessage,
        ));
      });
    }
  }

  void _onEdit(Message message, String editedString) {
    if (editedString.trim().isNotEmpty) {
      final index = messages.indexOf(message);
      setState(() {
        messages[index] = Message(
          text: editedString,
          time: DateTime.now().toString(),
          isSentByUser: true,
          repliedTo: message.repliedTo,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() {
            _selectedMessage = null;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _selectedMessage == null
            ? ChatAppbar(
                key: const Key('chatAppBar'), // Key for ChatAppbar
                participantNames: widget.participantNames,
              )
            : SelectedMessageAppbar(
                key: const Key(
                    'selectedMessageAppBar'), // Key for SelectedMessageAppbar
                onMessageUnTap: () {
                  setState(() => _selectedMessage = null);
                },
                onClickEdit: _onClickEdit,
                onClickDelete: _onClickDelete,
              ),
        body: Column(
          children: [
            Expanded(
              child: ChatDetailsBody(
                key: const Key('chatDetailsBody'), // Key for ChatDetailsBody
                onMessageTap: _onMessageTap,
                onMessageSwipe: _onMessageSwipe,
                selectedMessage: _selectedMessage,
              ),
            ),
            if (_repliedMessage != null)
              Padding(
                key: const Key('replyPreview'), // Key for ReplyPreview
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ReplyPreview(
                  repliedMessage: _repliedMessage!,
                  onCancel: _clearReply,
                ),
              ),
            _selectedMessage == null
                ? BottomBar(
                    key: const Key('bottomBar'), // Key for BottomBar
                    onSend: _onSend,
                    onSendAudio: _onSendAudio,
                    onEdit: _onEdit,
                    editedMessage: _editedMessage,
                  )
                : SelectedMessageBottomBar(
                    key: const Key(
                        'selectedMessageBottomBar'), // Key for SelectedMessageBottomBar
                    onReply: () {
                      _onMessageSwipe(_selectedMessage!);
                      setState(() {
                        _selectedMessage = null;
                      });
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
