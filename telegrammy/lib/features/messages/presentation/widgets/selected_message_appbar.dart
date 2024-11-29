import 'package:flutter/material.dart';

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
