import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/profile_settings_app_bar.dart';
import '../../../../cores/routes/route_names.dart';
import '../../../../cores/services/groups_socket.dart';
import '../../../../cores/services/service_locator.dart';
import '../../data/models/group.dart';
import '../view_models/group_cubit.dart';

class AddGroupAdminView extends StatefulWidget {
  AddGroupAdminView({
    required this.groupId,
    required this.usersToMakeAdmins,
  });
  final String groupId;
  final List<MemberData> usersToMakeAdmins;

  @override
  _AddGroupAdminViewState createState() => _AddGroupAdminViewState();
}

class _AddGroupAdminViewState extends State<AddGroupAdminView> {
  @override
  void initState() {
    super.initState();
    context.read<GroupCubit>().getGroupInfo(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileSettingsAppBar(
        backButtonOnPressed: () => context.goNamed(RouteNames.groupSettings),
        title: 'Add admins to group',
        key: const ValueKey('AddGroupAdminsAppBar'),
      ),
      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if (state is GroupLoading || state is GroupInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GroupError) {
            return Center(child: Text(state.errorMessage));
          } else if (state is GroupLoaded) {
            return SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Expanded(
                    key: const ValueKey('UsersToMakeAdmins'),
                    child: widget.usersToMakeAdmins.isNotEmpty
                        ? ListView.builder(
                            itemCount: widget.usersToMakeAdmins.length,
                            itemBuilder: (context, index) {
                              final contact = widget.usersToMakeAdmins[index];

                              return ListTile(
                                key: ValueKey('userToMakeAdmin_$index'),
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
                                  key: ValueKey('AddAdminButton_$index'),
                                  icon: Icon(Icons.add),
                                  onPressed: () async {
                                    context.read<GroupCubit>().makeAdmin(
                                        widget.groupId, contact.userId);
                                    setState(() {
                                      widget.usersToMakeAdmins.remove(contact);
                                    });
                                    ;
                                  },
                                ),
                              );
                            },
                          )
                        : Center(
                            key: const ValueKey('NoUsersAvailableText'),
                            child: Text(
                              'No users available.',
                              style: TextStyle(color: tileInfoHintColor),
                            ),
                          ),
                  ),
                ],
              ),
            );
          } else
            return Container();
        },
      ),
    );
  }
}
