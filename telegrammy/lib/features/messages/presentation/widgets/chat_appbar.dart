import 'package:flutter/material.dart';

class ChatAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppbar({super.key});

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            ListTile(
              title: Text('Mute'),
              onTap: () => _showMuteOptions(context),
            ),
          ],
        );
      },
    );
  }

  void _showMuteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            ListTile(
              title: Text('Mute for 1 hour'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Mute Permanently'),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/logo.png'),
            radius: 20,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Person Name'),
              Text('Last seen: 10 minutes ago', style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.call),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () => _showSettingsMenu(context),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
