import 'package:flutter/material.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';
import 'package:telegrammy/features/messages/presentation/widgets/message_attachment.dart';

class ChatDetailsBody extends StatefulWidget {
  final void Function(Message message) onMessageTap;
  final void Function(Message message) onMessageSwipe;
  final List<Message> messages;
  final Message? selectedMessage;
  final String userId;

  const ChatDetailsBody(
      {super.key,
      required this.onMessageTap,
      required this.onMessageSwipe,
      required this.selectedMessage,
      required this.messages,
      required this.userId});

  @override
  State<ChatDetailsBody> createState() => _ChatDetailsBodyState();
}

class _ChatDetailsBodyState extends State<ChatDetailsBody> {
  final ScrollController scrollController = ScrollController();
  late List<Message> messages; // Local copy of the message list

  @override
  void initState() {
    super.initState();
    // Initialize the local messages list
    messages = List.from(widget.messages);

    getit.get<SocketService>().receiveMessage('message:sent', (data) {
      // Check if replyOn is not null
      if (data['replyOn'] != null) {
        // Find the message by its ID and replace replyOn with the message object
        int index = messages.indexWhere((m) => m.id == data['replyOn']);
        if (index != -1) {
          data['replyOn'] = messages[index].toJson();
        }
      }

      // Create the Message object
      Message message = Message.fromJson(data);

      setState(() {
        messages.add(message);
        _scrollToBottom(); // Automatically scroll to the bottom
      });
    });

    getit.get<SocketService>().receiveEditedMessage('message:updated', (data) {
      if (data['replyOn'] != null) {
        // Find the message by its ID and replace replyOn with the message object
        int index = messages.indexWhere((m) => m.id == data['replyOn']);
        if (index != -1) {
          data['replyOn'] = messages[index].toJson();
        }
      }

      Message message = Message.fromJson(data);
      int index = messages.indexWhere((m) => m.id == message.id);

      setState(() {
        messages[index].content = message.content;
      });
    });

    getit.get<SocketService>().receiveDeletedMessage('message:deleted', (data) {
      if (data['replyOn'] != null) {
        // Find the message by its ID and replace replyOn with the message object
        int index = messages.indexWhere((m) => m.id == data['replyOn']);
        if (index != -1) {
          data['replyOn'] = messages[index].toJson();
        }
      }

      Message message = Message.fromJson(data);
      int index = messages.indexWhere((m) => m.id == message.id);

      setState(() {
        messages[index].content = "message has been deleted";
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollToMessage(Message message) {
    final index = messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      final messagePosition = index * 72.0; // Approximate height per message
      scrollController.animateTo(
        messagePosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      print('Message not found in the list.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const Key('chat_messages_list'),
      controller: scrollController,
      itemCount: messages.length,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (context, index) {
        final message = messages[index];
        final isSentByUser = message.sender == widget.userId;
        final isSelected = message == widget.selectedMessage;

        return GestureDetector(
          key: Key('message_$index'),
          onHorizontalDragEnd: (details) {
            widget.onMessageSwipe(message);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected
                  ? const Color.fromARGB(255, 179, 223, 174)
                  : Colors.white,
            ),
            child: Row(
              mainAxisAlignment: isSentByUser
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => widget.onMessageTap(message),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isSentByUser ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.replyOn != null)
                          GestureDetector(
                            onTap: () => _scrollToMessage(message.replyOn!),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.only(bottom: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                message.replyOn!.content ?? '',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        MessageAttachmentWidget(message: message),
                        Text(
                          message.content,
                          key: Key('message_text_${message.id}'),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          message.content,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Sent at ${message.timestamp}',
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
