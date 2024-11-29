import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/app_routes.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';

class SelectedMessageBottomBar extends StatelessWidget {
  final void Function() onReply;
  const SelectedMessageBottomBar({super.key, required this.onReply});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(Icons.forward),
          onPressed: () {
            context.goNamed(RouteNames.forwardToPage);
          },
          // onPressed: () => _forwardMessage(_selectedMessage),
        ),
        IconButton(
          icon: Icon(Icons.reply),
          onPressed: onReply,
          // onPressed: () => _replyToMessage(_selectedMessage),
        ),
      ],
    );
  }
}
