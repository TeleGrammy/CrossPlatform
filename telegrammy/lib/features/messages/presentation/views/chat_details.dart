import 'package:flutter/material.dart';
import 'package:telegrammy/features/messages/presentation/data/messages.dart';
import 'package:telegrammy/features/messages/presentation/widgets/bottom_bar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/chat_appbar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/chat_details_body.dart';
import 'package:telegrammy/features/messages/presentation/widgets/reply_preview.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_appbar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_bottom_bar.dart';

class ChatDetails extends StatefulWidget {
  const ChatDetails({super.key});

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  final ScrollController _scrollController =
      ScrollController(); // Add ScrollController
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
        repliedTo: null, // Store replied message
      ));
      _clearReply(); // Clear after sending
    });
  }

  void _scrollToMessage(Message message) {
    final index = messages.indexOf(message);
    if (index != -1) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent -
            index * 72.0, // Adjust height
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
            ? ChatAppbar()
            : SelectedMessageAppbar(
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
                onMessageTap: _onMessageTap,
                onMessageSwipe: _onMessageSwipe,
                selectedMessage: _selectedMessage,
                scrollController: _scrollController,
              ),
            ),
            if (_repliedMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ReplyPreview(
                  repliedMessage: _repliedMessage!,
                  onCancel: _clearReply,
                ),
              ),
            _selectedMessage == null
                ? BottomBar(
                    onSend: (text) {
                      if (text.trim().isNotEmpty) {
                        setState(() {
                          messages.add(Message(
                            text: text,
                            time: DateTime.now().toString(),
                            isSentByUser: true,
                            repliedTo: _repliedMessage, // Store replied message
                          ));
                          _clearReply(); // Clear after sending
                        });
                      }
                    },
                    onEdit: (Message message, String editedString) {
                      if (editedString.trim().isNotEmpty) {
                        final index = messages.indexOf(message);
                        // after this you need to edit the message
                        setState(() {
                          messages.add(Message(
                            text: editedString,
                            time: DateTime.now().toString(),
                            isSentByUser: true,
                            repliedTo:
                                message.repliedTo, // Store replied message
                          ));
                          _clearReply(); // Clear after sending
                        });
                      }
                    },
                    editedMessage: _editedMessage,
                  )
                : SelectedMessageBottomBar(
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