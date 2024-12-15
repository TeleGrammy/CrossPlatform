import 'package:flutter/material.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';

class SelectedMessageAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final Function() onMessageUnTap;
  final Function() onClickEdit;
  final Function() onClickDelete;

  const SelectedMessageAppbar({
    super.key,
    required this.onMessageUnTap,
    required this.onClickEdit,
    required this.onClickDelete,
  });

  // void onEditMessage(String text) {
  //   if (text.trim().isNotEmpty) {
  //     getit.get<SocketService>().sendMessage(
  //       'message:send',
  //       {'content': text, 'chatId': widget.chatId, 'messageType': 'text'},
  //     );
  //   }
  // }
  // void onDeleteMessage(String text) {
  //   if (text.trim().isNotEmpty) {
  //     getit.get<SocketService>().sendMessage(
  //       'message:send',
  //       {'content': text, 'chatId': widget.chatId, 'messageType': 'text'},
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: const Key('selected_message_appbar'),
      leading: IconButton(
        key: const Key('selected_message_close_button'),
        onPressed: onMessageUnTap,
        icon: const Icon(Icons.close),
      ),
      actions: [
        IconButton(
          key: const Key('selected_message_edit_button'),
          icon: const Icon(Icons.edit),
          onPressed: onClickEdit,
        ),
        IconButton(
          key: const Key('selected_message_delete_button'),
          icon: const Icon(Icons.delete),
          onPressed: onClickDelete,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
