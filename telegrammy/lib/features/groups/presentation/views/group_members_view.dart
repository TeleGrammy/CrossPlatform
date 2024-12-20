import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/profile_settings_app_bar.dart';
import '../../../../cores/routes/route_names.dart';
import '../../../../cores/services/groups_socket.dart';
import '../../../../cores/services/service_locator.dart';
import '../../data/models/group.dart';

class GroupMembersView extends StatefulWidget {
  GroupMembersView({required this.groupId, required this.members});
  final String groupId;
  final List<MemberData> members;
  @override
  _GroupMembersViewState createState() => _GroupMembersViewState();
}

class _GroupMembersViewState extends State<GroupMembersView> {
  @override
  void initState() {
    super.initState();
    getit.get<GroupSocketService>().connectToGroupServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileSettingsAppBar(
        backButtonOnPressed: () => context.goNamed(RouteNames.groupSettings),
        title: 'Group members',
        key: const ValueKey('GroupMembersAppBar'),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Expanded(
            key: const ValueKey('GroupMembers'),
            child: widget.members.isNotEmpty
                ? ListView.builder(
                    itemCount: widget.members.length,
                    itemBuilder: (context, index) {
                      final contact = widget.members[index];

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
