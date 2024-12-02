import 'package:audioplayers/audioplayers.dart'; // Add this package for audio playback
import 'package:flutter/material.dart';
import 'package:telegrammy/features/messages/presentation/data/messages.dart';
import 'package:telegrammy/features/messages/presentation/widgets/audio_player_widget.dart';

class ChatDetailsBody extends StatefulWidget {
  final void Function(Message message) onMessageTap;
  final void Function(Message message) onMessageSwipe;
  final Message? selectedMessage;

  const ChatDetailsBody({
    super.key,
    required this.onMessageTap,
    required this.onMessageSwipe,
    required this.selectedMessage,
  });

  @override
  State<ChatDetailsBody> createState() => _ChatDetailsBodyState();
}

class _ChatDetailsBodyState extends State<ChatDetailsBody> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll to the bottom after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void didUpdateWidget(ChatDetailsBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Scroll to the bottom if the message list is updated
    if (scrollController.hasClients &&
        oldWidget.selectedMessage != widget.selectedMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
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
    final index = messages.indexWhere((m) => m.text == message.text);
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
        final isSentByUser = message.isSentByUser;
        final isSelected = message == widget.selectedMessage;

        return GestureDetector(
          key: Key('message_${index}'),
          onHorizontalDragEnd: (details) {
            widget.onMessageSwipe(message);
          },
          child: Container(
            key: isSelected
                ? Key('selected_message_${message.id}')
                : Key('unselected_message_${message.id}'),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected
                  ? const Color.fromARGB(255, 179, 223, 174)
                  : Colors.white,
            ),
            child: AnimatedPadding(
              key: Key('animated_padding_${message.id}'),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: isSelected
                  ? (isSentByUser
                      ? const EdgeInsets.only(right: 50, top: 4, bottom: 4)
                      : const EdgeInsets.only(left: 50, top: 4, bottom: 4))
                  : const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: isSentByUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    key: Key('message_container_${index}'),
                    onTap: () => widget.onMessageTap(message),
                    child: Container(
                      key: Key('message_bubble_${message.id}'),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color:
                            isSentByUser ? Colors.blue[100] : Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: isSentByUser
                              ? const Radius.circular(12)
                              : Radius.zero,
                          bottomRight: isSentByUser
                              ? Radius.zero
                              : const Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        key: Key('message_content_${message.id}'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.repliedTo != null)
                            GestureDetector(
                              key: Key('replied_message_${message.id}'),
                              onTap: () =>
                                  _scrollToMessage(message.repliedTo!),
                              child: Container(
                                key: Key('replied_message_container_${message.id}'),
                                padding: const EdgeInsets.all(8.0),
                                margin: const EdgeInsets.only(bottom: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  message.repliedTo!.text ?? '',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          if (message.audioUrl != null)
                            AudioPlayerWidget(
                              key: Key('audio_player_${message.id}'),
                              audioUrl: message.audioUrl!,
                              audioPlayer: AudioPlayer(),
                            )
                          else
                            Text(
                              message.text,
                              key: Key('message_text_${message.id}'),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16.0,
                              ),
                            ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Sent at ${message.time}',
                            key: Key('message_time_${message.id}'),
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
          ),
        );
      },
    );
  }
}
