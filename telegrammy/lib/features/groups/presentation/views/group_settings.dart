import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/cores/widgets/rounded_button.dart';
import 'package:telegrammy/features/groups/presentation/view_models/group_cubit.dart';
import 'package:telegrammy/features/groups/presentation/widgets/group_admin_settings.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/settings_box.dart';
import '../../../../cores/constants/app_colors.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/picture_circle.dart';
import '../../../../../cores/styles/styles.dart';
import '../../../../cores/services/groups_socket.dart';
import '../../../../cores/services/service_locator.dart';
import '../../../messages/data/models/contacts.dart';

class GroupSettingsView extends StatefulWidget {
  GroupSettingsView({super.key, required this.chat, required this.lastSeen}) {
    groupId = chat.groupId!;
  }
  final Chat chat;
  final String lastSeen;
  late String groupId;

  @override
  State<GroupSettingsView> createState() => _GroupSettingsViewState();
}

class _GroupSettingsViewState extends State<GroupSettingsView> {
  // String groupId = '6761f0048a2111362183137a';
  bool isAdmin = true; //TODO: use this to enable/disable admin functions

  @override
  void initState() {
    super.initState();
    context.read<GroupCubit>().getGroupInfo(widget.groupId);

    getit.get<GroupSocketService>().connectToGroupServer();
    // getit.get<GroupSocketService>().listenGroupDeleted();
    //getit.get<GroupSocketService>().listenLeftGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: const ValueKey('GroupSettingsAppBar'),
        leading: IconButton(
          onPressed: () {
            context.goNamed(
              RouteNames.chatWrapper,
              extra: [widget.chat, widget.lastSeen],
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Group Settings'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            key: const ValueKey('EditProfileInfoButton'),
            icon: Icon(Icons.edit),
            color: Colors.white,
            onPressed: () => context.goNamed(RouteNames.editGroupSettings,
                extra: widget.groupId),
          ),
        ],
      ),
      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if (state is GroupLoading || state is GroupInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GroupError) {
            return Center(child: Text(state.errorMessage));
          } else if (state is GroupLoaded) {
            return SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20),
                        PictureCircle(
                            key: const ValueKey('GroupPictureCircle'),
                            imageUrl: state.groupData.image ?? 'default.jpg'),
                        SizedBox(height: 20),
                        Text(
                          key: const ValueKey('GroupName'),
                          state.groupData.name,
                          style: textStyle30,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        SettingsBox(
                          key: const ValueKey('GroupDescription'),
                          children: [
                            ListTile(
                              key: const ValueKey('GroupDescriptionTile'),
                              title: Text(state.groupData.description ?? '-'),
                              subtitle: Text('Description'),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        SettingsBox(
                          children: [
                            ListTile(
                                key: const ValueKey('ViewMembersTile'),
                                title: Text('View group members'),
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  // TODO: show members
                                  context.goNamed(RouteNames.viewGroupMembers,
                                      extra: [widget.groupId, state.members]);
                                }),
                          ],
                        ),
                        SizedBox(height: 20),
                        (!isAdmin)
                            ? SizedBox.shrink()
                            : GroupAdminSettings(
                                groupId: widget.groupId,
                                groupPrivacy: state.groupData.groupPrivacy,
                                groupSizeLimit: state.groupData.groupSizeLimit,
                                contactsToAddFrom:
                                    state.contactsExcludingMembers!,
                                membersToMakeAdmins: state.nonAdminMembers!,
                                nonAdminMembers: state.nonAdminMembers!,
                              ),
                        SizedBox(height: 20),
                        RoundedButton(
                          key: const ValueKey('LeaveGroupButton'),
                          onPressed: () {
                            getit
                                .get<GroupSocketService>()
                                .leaveGroup(widget.groupId);
                            context.goNamed(RouteNames.chats);
                          },
                          buttonTitle: 'Leave Group',
                          buttonKey: const ValueKey('LeaveGroupButton'),
                        ),
                        (isAdmin)
                            ? RoundedButton(
                                key: const ValueKey('DeleteGroupButton'),
                                onPressed: () {
                                  getit
                                      .get<GroupSocketService>()
                                      .deleteGroup(widget.groupId);
                                  context.goNamed(RouteNames.chats);
                                },
                                buttonTitle: 'Delete Group',
                                buttonKey: const ValueKey('DeleteGroupButton'),
                                backgroundColor: Colors.red[900]!,
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  )),
            );
          }
          return Center(child: Text('-'));
        },
      ),
    );
  }
}
