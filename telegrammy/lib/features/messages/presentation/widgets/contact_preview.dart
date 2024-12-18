import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';

class ContactPreview extends StatelessWidget {
  final String id;
  final String name;
  final String photo;
  final String lastMessage;
  final String lastMessageTime;
  final String lastSeen;
  final Message? forwardMessage;

  const ContactPreview(
      {Key? key,
      required this.id,
      required this.name,
      required this.photo,
      required this.lastMessage,
      required this.lastMessageTime,
      required this.lastSeen,
      this.forwardMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasPhoto = photo != 'default.jpg';
    String userPhoto = hasPhoto ? photo : 'assets/images/defaultphoto.jpg';
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: !hasPhoto
            ? AssetImage(userPhoto)
            : NetworkImage(userPhoto) as ImageProvider,
      ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        lastMessage.isNotEmpty ? lastMessage : '',
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      onTap: () {
        if (forwardMessage != null) {
          getit.get<SocketService>().sendMessage(
            'message:send',
            {
              'content': forwardMessage!.content,
              'chatId': id,
              'messageType': 'text'
            },
          );
        }
        context.goNamed(
          RouteNames.chatWrapper,
          extra: [
            name,
            id,
            userPhoto,
            lastSeen,
          ],
        );
      },
    );
  }
}
