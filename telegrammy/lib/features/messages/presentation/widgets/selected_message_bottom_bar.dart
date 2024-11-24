import 'package:flutter/material.dart';

class SelectedMessageBottomBar extends StatelessWidget {
  const SelectedMessageBottomBar({super.key});

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
          onPressed: () {},
          // onPressed: () => _replyToMessage(_selectedMessage),
        ),
      ],
    );
  }
}
