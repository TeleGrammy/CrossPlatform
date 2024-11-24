import 'package:flutter/material.dart';

class SelectedMessageAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final Function() onMessageUnTap;
  const SelectedMessageAppbar({super.key, required this.onMessageUnTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // title: Text('Edit/Delete'),
      leading: IconButton(onPressed: onMessageUnTap, icon: Icon(Icons.close)),
      actions: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {},
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.delete),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
