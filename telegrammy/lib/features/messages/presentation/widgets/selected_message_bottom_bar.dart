import 'package:flutter/material.dart';

class SelectedMessageBottomBar extends StatelessWidget {
  final void Function() onReply;
  const SelectedMessageBottomBar({super.key,required this.onReply});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(Icons.forward),
          onPressed: () {},
          // onPressed: () => _forwardMessage(_selectedMessage),
        ),
        IconButton(
          icon: Icon(Icons.reply),
          onPressed:onReply,
          // onPressed: () => _replyToMessage(_selectedMessage),
        ),
      ],
    );
  }
}
