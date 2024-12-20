
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/services/channel_socket.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';

import '../../../../cores/routes/route_names.dart';

class ChatAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Chat chat;
  final String lastSeen;
  final String userRole;
  final Function() onSearch;
  final String name;
  final String photo;
  final String id;

  const ChatAppbar(
      {super.key,
      required this.name,
      required this.photo,
      required this.lastSeen,
      required this.chat,
      required this.userRole,
      required this.onSearch,
      required this.id
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
            if (chat.isChannel)
              ListTile(
                key: const Key('settings_mute_option'),
                leading: Icon(
                  Icons.exit_to_app_outlined,
                  color: Colors.red,
                ),
                title: const Text('leave Channel'),
                onTap: () => {},
              ),
            if (chat.isChannel &&
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
                onTap: () {
                  getit
                      .get<ChannelSocketService>()
                      .removeChannel({'channelId': chat.channelId});
                  getit
                      .get<ChannelSocketService>()
                      .errorChannelMessage((dynamic callback) {});
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
            backgroundImage:
                (chat.photo != null) ? AssetImage(chat.photo!) : null,
            radius: 20,
          ),
          const SizedBox(width: 10),
          Column(
            key: const Key('participant_info_column'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chat.name,
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
        IconButton(
          key: const Key('call_button'),
          icon: const Icon(Icons.call),
          onPressed: () {
            context.goNamed(RouteNames.onGoingCall,extra: {
              'name': name,
              'photo': photo,
              'id': id,
            });
          },
        ),
        IconButton(
          key: const Key('settings_button'),
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showSettingsMenu(context),
        ),
        IconButton(
            key: const Key('chat_info_button'),
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              if (chat.isGroup) context.goNamed(RouteNames.groupSettings);
            }),
        IconButton(
          key: const Key('search_settings_button'),
          icon: const Icon(Icons.search),
          onPressed: onSearch,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
