import 'package:audioplayers/audioplayers.dart'; // Add this package for audio playback
import 'package:flutter/material.dart';
import 'package:telegrammy/features/messages/presentation/data/messages.dart';
import 'package:telegrammy/features/messages/presentation/widgets/audio_player_widget.dart';

class ChatDetailsBody extends StatelessWidget {
  final void Function(Message message) onMessageTap;
  final void Function(Message message) onMessageSwipe;
  final Message? selectedMessage;
  final ScrollController scrollController;

  const ChatDetailsBody({
    super.key,
    required this.onMessageTap,
    required this.onMessageSwipe,
    required this.selectedMessage,
    required this.scrollController,
  });

  void _scrollToMessage(Message message) {
    final index = messages.indexWhere((m) => m.text == message.text);
    if (index != -1) {
      scrollController.animateTo(
        (messages.length - 1 - index) * 72.0,
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
      controller: scrollController,
      itemCount: messages.length,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (context, index) {
        final message = messages[index];
        final isSentByUser = message.isSentByUser;
        final isSelected = message == selectedMessage;

        return GestureDetector(
          onHorizontalDragEnd: (details) {
            onMessageSwipe(message);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected
                  ? const Color.fromARGB(255, 179, 223, 174)
                  : Colors.white,
            ),
            child: AnimatedPadding(
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
                    onTap: () => onMessageTap(message),
                    child: Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.repliedTo != null)
                            GestureDetector(
                              onTap: () => _scrollToMessage(message.repliedTo!),
                              child: Container(
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
                            AudioPlayerWidget(audioUrl: message.audioUrl!)
                          else
                            Text(
                              message.text,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16.0,
                              ),
                            ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Sent at ${message.time}',
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
