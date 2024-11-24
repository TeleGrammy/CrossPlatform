import 'package:flutter/material.dart';
import 'package:telegrammy/features/messages/presentation/data/messages.dart';

class ChatDetailsBody extends StatelessWidget {
  final void Function(Message message) onMessageTap;
  final void Function(Message message)
      onMessageSwipe; // Callback for swipe action
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
    print(messages.length - 1 - index);
    if (index != -1) {
      scrollController.animateTo(
        (messages.length - 1 - 0) * 72.0,
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
      reverse: true,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (context, index) {
        final message = messages[index];
        final isSentByUser = message.isSentByUser;
        final isSelected = message == selectedMessage;

        return GestureDetector(
          onHorizontalDragEnd: (details) {
            // Swipe right detected
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
              duration: Duration(milliseconds: 300), // Animation duration
              curve: Curves.easeInOut, // Animation curve
              padding: isSelected
                  ? (isSentByUser
                      ? EdgeInsets.only(right: 50, top: 4, bottom: 4)
                      : EdgeInsets.only(left: 50, top: 4, bottom: 4))
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
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: (isSentByUser
                            ? Colors.blue[100]
                            : Colors.grey[200]),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomLeft:
                              isSentByUser ? Radius.circular(12) : Radius.zero,
                          bottomRight:
                              isSentByUser ? Radius.zero : Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.repliedTo != null)
                            GestureDetector(
                              onTap: () => _scrollToMessage(message.repliedTo!),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                margin: EdgeInsets.only(bottom: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  message.repliedTo!.text,
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          Text(
                            message.text,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Sent at ${message.time}',
                            style: TextStyle(
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
