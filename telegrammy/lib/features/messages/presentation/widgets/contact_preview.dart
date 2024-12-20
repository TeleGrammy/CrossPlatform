import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';

class ContactPreview extends StatelessWidget {
  final String lastMessageTime;
  final Message? forwardMessage;
  final String? draftMessage;
  final String userId;
  final ChatView chat;
  const ContactPreview({
    Key? key,
    required this.lastMessageTime,
    this.forwardMessage,
    this.draftMessage,
    required this.userId,
    required this.chat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasPhoto = (chat.photo != null) && chat.photo != 'default.jpg';
    String userPhoto =
        hasPhoto ? chat.photo! : 'assets/images/defaultphoto.jpg';
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: !hasPhoto
            ? AssetImage(userPhoto)
            : NetworkImage(userPhoto) as ImageProvider,
      ),
      title: Text(
        chat.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        draftMessage != null
            ? "draft:$draftMessage"
            :chat.lastMessage!=null && chat.lastMessage!.content.isNotEmpty
                ? chat.lastMessage!.content
                : '',
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      onTap: () {
        if (forwardMessage != null) {
          getit.get<SocketService>().sendMessage(
            'message:send',
            {
              'content': forwardMessage!.content,
              'chatId': chat.id,
              'messageType': 'text'
            },
          );
        }
        context.goNamed(
          RouteNames.chatWrapper,
          extra: [chat, userId],
        );
      },
    );
  }
}
