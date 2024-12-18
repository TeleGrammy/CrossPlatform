import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/services/channel_socket.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';

import '../../../../cores/routes/route_names.dart';

class ChatAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String chatId;
  final String photo;
  final String lastSeen;
  final bool isChannel;
  final String userRole;

  const ChatAppbar({
    required this.name,
    required this.chatId,
    super.key,
    required this.photo,
    required this.lastSeen,
    required this.isChannel,
    required this.userRole,
  });

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          key: const Key('settings_menu_list'),
          children: [
            ListTile(
              key: const Key('settings_mute_option'),
              leading: Icon(
                Icons.volume_mute_rounded,
                color: Colors.black,
              ),
              title: const Text('Mute'),
              onTap: () => _showMuteOptions(context),
            ),
            ListTile(
              key: const Key('settings_mute_option'),
              leading: Icon(
                Icons.search,
                color: Colors.black,
              ),
              title: const Text('Search'),
              onTap: () => {},
            ),
            if (isChannel)
              ListTile(
                key: const Key('settings_mute_option'),
                leading: Icon(
                  Icons.exit_to_app_outlined,
                  color: Colors.red,
                ),
                title: const Text('leave Channel'),
                onTap: () => {},
              ),
            if (isChannel &&
                (userRole == "Creator" ||
                    userRole ==
                        "Admin")) //should add if the user is admin condition
              ListTile(
                key: const Key('settings_mute_option'),
                leading: Icon(
                  Icons.delete_rounded,
                  color: Colors.red,
                ),
                title: const Text('delete Channel'),
                onTap: () => {
                  getit.get<ChannelSocketService>().removeChannel({
                    'channelId':chatId
                  })
                },
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
          key: const Key('mute_options_list'),
          children: [
            ListTile(
              key: const Key('mute_1_hour_option'),
              title: const Text('Mute for 1 hour'),
              onTap: () {},
            ),
            ListTile(
              key: const Key('mute_permanent_option'),
              title: const Text('Mute Permanently'),
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
        key: const Key('back_button'),
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          getit.get<SocketService>().disconnect();
          context.goNamed(RouteNames.chats);
        },
      ),
      title: Row(
        key: const Key('appbar_title_row'),
        children: [
          CircleAvatar(
            key: const Key('profile_picture'),
            backgroundImage: AssetImage(photo),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Column(
            key: const Key('participant_info_column'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                key: Key('participant_name'),
              ),
              Text(
                lastSeen,
                key: Key('last_seen_info'),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (!isChannel)
          IconButton(
            key: const Key('call_button'),
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
        IconButton(
          key: const Key('settings_button'),
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showSettingsMenu(context),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
