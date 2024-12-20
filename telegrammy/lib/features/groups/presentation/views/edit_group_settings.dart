import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/features/groups/presentation/widgets/change_picture_button.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/profile_settings_app_bar.dart';

import '../../../messages/data/models/contacts.dart';
import '../../../profile/presentation/widgets/profile_settings/picture_circle.dart';
import '../view_models/group_cubit.dart';

class EditGroupSettingsView extends StatefulWidget {
  const EditGroupSettingsView(
      {super.key,
      required this.groupId,
      required this.chat,
      required this.lastSeen});
  final String groupId;
  final ChatView chat;
  final String lastSeen;

  @override
  State<EditGroupSettingsView> createState() => _EditGroupSettingsViewState();
}

class _EditGroupSettingsViewState extends State<EditGroupSettingsView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupDescriptionController =
      TextEditingController();

  @override
  void dispose() {
    groupNameController.dispose();
    groupDescriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<GroupCubit>().getGroupInfo(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ProfileSettingsAppBar(
          key: const ValueKey('EditGroupSettingsAppBar'),
          title: 'Edit Group Info',
          backButtonOnPressed: () {
            context.goNamed(RouteNames.groupSettings,
                extra: [widget.chat, widget.lastSeen]);
          },
          actions: [
            TextButton(
                key: const ValueKey('SaveChangesButton'),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await context.read<GroupCubit>().updateGroupInfo(
                        groupId: widget.groupId,
                        name: groupNameController.text,
                        description: groupDescriptionController.text);
                    Future.delayed(Duration(seconds: 1));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Group info updated successfully!')),
                    );
                    context.goNamed(RouteNames.groupSettings,
                        extra: [widget.chat, widget.lastSeen]);
                  }
                },
                child: Text(
                  'SAVE CHANGES',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
        body: BlocBuilder<GroupCubit, GroupState>(builder: (context, state) {
          if (state is GroupLoading || state is GroupInitial) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is GroupError) {
            return Center(child: Text(state.errorMessage));
          }

          if (state is GroupLoaded) {
            groupNameController.text = state.groupData.name;
            groupDescriptionController.text = state.groupData.description ?? '';

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
                      ChangePictureButton(
                        key: const ValueKey('ChangeGroupPictureButton'),
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(children: [
                          GroupSettingsTextFormField(
                            valueKey: const ValueKey('GroupNameTextField'),
                            controller: groupNameController,
                            labelText: 'Group Name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                          GroupSettingsTextFormField(
                            valueKey:
                                const ValueKey('GroupDescriptionTextField'),
                            controller: groupDescriptionController,
                            labelText: 'Group Description',
                            validator: (value) => null,
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        }));
  }
}

class GroupSettingsTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final ValueKey<String>? valueKey;
  const GroupSettingsTextFormField(
      {super.key,
      this.controller,
      this.keyboardType = TextInputType.text,
      this.labelText = "",
      this.validator,
      this.valueKey});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: valueKey,
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[400]),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey), // White underline when enabled
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white), // White underline when focused
        ),
      ),
      validator: validator,
    );
  }
}
