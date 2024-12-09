import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/route_names.dart';

class ContactPreview extends StatelessWidget {
  final String name;
  final String photo;
  final String draftMessage;
  final String id;
  final String lastSeen;

  const ContactPreview(
      {Key? key,
      required this.id,
      required this.name,
      required this.photo,
      required this.draftMessage,
      required this.lastSeen})
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
        draftMessage.isNotEmpty ? draftMessage : 'No draft message',
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      onTap: () {
        context.goNamed(
          RouteNames.chatWrapper,
          extra: [name, id, userPhoto, lastSeen],
        );
      },
    );
  }
}
