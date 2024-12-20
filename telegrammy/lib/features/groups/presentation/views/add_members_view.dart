import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/profile_settings_app_bar.dart';
import '../../../../cores/routes/route_names.dart';
import '../../../../cores/services/groups_socket.dart';
import '../../../../cores/services/service_locator.dart';
import '../../../messages/data/models/contacts.dart';
import '../../data/models/group.dart';

class AddGroupMembersView extends StatefulWidget {
  AddGroupMembersView(
      {required this.groupId,
      required this.contactsToAddFrom,
      required this.chat,
      required this.lastSeen});
  final String groupId;
  final List<ContactData> contactsToAddFrom;
  Chat chat;
  String lastSeen;
  @override
  _AddGroupMembersViewState createState() => _AddGroupMembersViewState();
}

class _AddGroupMembersViewState extends State<AddGroupMembersView> {
  @override
  void initState() {
    super.initState();
    getit.get<GroupSocketService>().connectToGroupServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileSettingsAppBar(
        backButtonOnPressed: () => context.goNamed(RouteNames.groupSettings,
            extra: [widget.chat, widget.lastSeen]),
        title: 'Add members to group',
        key: const ValueKey('AddGroupMembersAppBar'),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Expanded(
            key: const ValueKey('MembersToAdd'),
            child: widget.contactsToAddFrom.isNotEmpty
                ? ListView.builder(
                    itemCount: widget.contactsToAddFrom.length,
                    itemBuilder: (context, index) {
                      final contact = widget.contactsToAddFrom[index];
                      final isBlocked = contact.blockDetails == "not_blocked";

                      return ListTile(
                        key: ValueKey('userToAdd_$index'),
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
                        trailing: IconButton(
                          key: ValueKey('AddMemberButton_$index'),
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            getit
                                .get<GroupSocketService>()
                                .addMember(widget.groupId, contact.userId);
                            setState(() {
                              widget.contactsToAddFrom.remove(contact);
                            });
                          },
                        ),
                      );
                    },
                  )
                : Center(
                    key: const ValueKey('NoContactsToAddText'),
                    child: Text(
                      'No contacts available to add.',
                      style: TextStyle(color: tileInfoHintColor),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
