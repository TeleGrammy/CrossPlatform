import 'package:flutter/material.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';

class SelectedMessageAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final Function() onMessageUnTap;
  final Function() onClickEdit;
  final Function() onClickDelete;
  final Function() onClickPin;
  final Function() onClickUnpin;
  final bool? isPinned;

  const SelectedMessageAppbar({
    super.key,
    required this.onMessageUnTap,
    required this.onClickEdit,
    required this.onClickDelete,
    required this.onClickPin,
    required this.onClickUnpin,
    required this.isPinned
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
    void handlePinUnpin() {
    if (isPinned == true) {
      // Call unpin socket function
      
      onClickUnpin();
    } else {
      // Call pin socket function
       onClickPin();
    }
    // Notify parent to update UI or state
  }
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
           IconButton(
          key: const Key('selected_message_pin_button'),
          icon: isPinned == false
              ? const Icon(Icons.push_pin) // Pinned state
              : const Icon(Icons.push_pin_outlined), // Unpinned state
          onPressed: handlePinUnpin,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
