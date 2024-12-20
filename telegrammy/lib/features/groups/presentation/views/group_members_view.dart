import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/features/groups/presentation/view_models/AddMembersCubit/group_members_cubit.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/profile_settings_app_bar.dart';
import '../../../../cores/routes/route_names.dart';
import '../../../../cores/services/groups_socket.dart';
import '../../../../cores/services/service_locator.dart';

class GroupMembersView extends StatefulWidget {
  GroupMembersView({required this.groupId});
  final String groupId;
  @override
  _GroupMembersViewState createState() => _GroupMembersViewState();
}

class _GroupMembersViewState extends State<GroupMembersView> {
  @override
  void initState() {
    super.initState();
    context.read<GroupMembersCubit>().getContacts();
    getit.get<GroupSocketService>().connectToGroupServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileSettingsAppBar(
        backButtonOnPressed: () => context.goNamed(RouteNames.groupSettings),
        title: 'Add members to group',
        key: const ValueKey('AddGroupMembersAppBar'),
      ),
      body: BlocBuilder<GroupMembersCubit, GroupMembersState>(
        builder: (context, state) {
          if (state is GroupMembersLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GroupMembersError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (state is GroupMembersLoaded) {
            // Filter out blocked contacts
            final contacts = state.contacts
                .where((contact) => contact.blockDetails == "not_blocked")
                .toList();

            return Column(
              children: [
                SizedBox(height: 30),
                Expanded(
                  key: const ValueKey('MembersToAdd'),
                  child: contacts.isNotEmpty
                      ? ListView.builder(
                          itemCount: contacts.length,
                          itemBuilder: (context, index) {
                            final contact = contacts[index];
                            final isBlocked =
                                contact.blockDetails == "not_blocked";

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
                                icon: Icon(Icons.add),
                                onPressed: () async {
                                  getit.get<GroupSocketService>().addMember(
                                      widget.groupId, contact.userId);
                                  setState(() {
                                    state.contacts.remove(contact);
                                  });
                                },
                              ),
                            );
                          },
                        )
                      : Center(
                          key: const ValueKey('NoContactsToBlockText'),
                          child: Text(
                            'No contacts available.',
                            style: TextStyle(color: tileInfoHintColor),
                          ),
                        ),
                ),
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
