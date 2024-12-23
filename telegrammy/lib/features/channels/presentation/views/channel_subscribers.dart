import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/services/channel_socket.dart';
import 'package:telegrammy/features/groups/data/models/group.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/profile_settings_app_bar.dart';
import '../../../../cores/routes/route_names.dart';
import '../../../../cores/services/service_locator.dart';

class GroupMembersView extends StatefulWidget {
  GroupMembersView({required this.channelId, required this.subscribers});
  final String channelId;
  final List<MemberData> subscribers;
  @override
  _GroupMembersViewState createState() => _GroupMembersViewState();
}

class _GroupMembersViewState extends State<GroupMembersView> {
  @override
  void initState() {
    super.initState();
    getit.get<ChannelSocketService>().connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileSettingsAppBar(
        backButtonOnPressed: () => context.goNamed(RouteNames.channelSettings),
        title: 'Channel Subscribers',
        key: const ValueKey('ChannelSubscribersAppBar'),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Expanded(
            key: const ValueKey('ChannelSubscribers'),
            child: widget.subscribers.isNotEmpty
                ? ListView.builder(
                    itemCount: widget.subscribers.length,
                    itemBuilder: (context, index) {
                      final contact = widget.subscribers[index];

                      return ListTile(
                        key: ValueKey('GroupMember_$index'),
                        tileColor: primaryColor,
                        leading: CircleAvatar(
                          backgroundImage: contact.picture != null
                              ? NetworkImage(contact.picture!)
                              : null,
                          radius: 20,
                        ),
                        title: Text(
                          key: ValueKey('username_$index'),
                          contact.username,
                          style: TextStyle(color: tileInfoHintColor),
                        ),
                      );
                    },
                  )
                : Center(
                    key: const ValueKey('NoMembersText'),
                    child: Text(
                      'No Members yet.',
                      style: TextStyle(color: tileInfoHintColor),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
