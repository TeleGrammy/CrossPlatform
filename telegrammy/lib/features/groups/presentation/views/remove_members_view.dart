import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/profile_settings_app_bar.dart';
import '../../../../cores/routes/route_names.dart';
import '../../../../cores/services/groups_socket.dart';
import '../../../../cores/services/service_locator.dart';
import '../../data/models/group.dart';

class RemoveGroupMembersView extends StatefulWidget {
  RemoveGroupMembersView(
      {required this.groupId, required this.membersToRemoveFrom});
  final String groupId;
  final List<MemberData> membersToRemoveFrom;
  @override
  _RemoveGroupMembersViewState createState() => _RemoveGroupMembersViewState();
}

class _RemoveGroupMembersViewState extends State<RemoveGroupMembersView> {
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
        title: 'Remove members from group',
        key: const ValueKey('RemoveGroupMembersAppBar'),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Expanded(
            key: const ValueKey('MembersToRemove'),
            child: widget.membersToRemoveFrom.isNotEmpty
                ? ListView.builder(
                    itemCount: widget.membersToRemoveFrom.length,
                    itemBuilder: (context, index) {
                      final contact = widget.membersToRemoveFrom[index];

                      return ListTile(
                        tileColor: primaryColor,
                        leading: CircleAvatar(
                          backgroundImage: contact.picture != null
                              ? NetworkImage(contact.picture!)
                              : null,
                          radius: 20,
                        ),
                        title: Text(
                          contact.username,
                          style: TextStyle(color: tileInfoHintColor),
                        ),
                        trailing: IconButton(
                          key: const ValueKey('RemoveMemberButton'),
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () async {
                            getit.get<GroupSocketService>().removeParticipant(
                                widget.groupId, contact.userId);
                            setState(() {
                              widget.membersToRemoveFrom.remove(contact);
                            });
                          },
                        ),
                      );
                    },
                  )
                : Center(
                    key: const ValueKey('NoMembersToRemoveText'),
                    child: Text(
                      'No members to remove.',
                      style: TextStyle(color: tileInfoHintColor),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
