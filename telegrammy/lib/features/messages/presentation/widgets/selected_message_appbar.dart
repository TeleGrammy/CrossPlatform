import 'package:flutter/material.dart';

class SelectedMessageAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final Function() onMessageUnTap;
  final Function() onClickEdit;
  final Function() onClickDelete;
  const SelectedMessageAppbar({super.key, required this.onMessageUnTap,required this.onClickEdit,required this.onClickDelete});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // title: Text('Edit/Delete'),
      leading: IconButton(onPressed: onMessageUnTap, icon: Icon(Icons.close)),
      actions: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed:onClickEdit,
        ),
        IconButton(
          onPressed: onClickDelete,
          icon: Icon(Icons.delete),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
