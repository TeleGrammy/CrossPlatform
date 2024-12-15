import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/app_routes.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';

class SelectedMessageBottomBar extends StatelessWidget {
  final void Function() onReply;
  final Message selectedMessage;
  const SelectedMessageBottomBar(
      {super.key, required this.onReply, required this.selectedMessage});

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const Key('selected_message_bottom_bar'),
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          key: const Key('forward_message_button'),
          icon: const Icon(Icons.forward),
          onPressed: () {
            context.goNamed(RouteNames.chats, extra: [selectedMessage]);
          },
        ),
        IconButton(
          key: const Key('reply_message_button'),
          icon: const Icon(Icons.reply),
          onPressed: onReply,
        ),
      ],
    );
  }
}
