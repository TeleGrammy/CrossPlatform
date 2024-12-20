import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/widgets/custom_text_field.dart';
import 'package:telegrammy/cores/widgets/rounded_button.dart';
import 'package:telegrammy/features/groups/presentation/view_models/group_cubit.dart';

import '../../../../cores/routes/route_names.dart';
import '../../../../cores/services/groups_socket.dart';
import '../../../../cores/services/service_locator.dart';

class CreateGroupForm extends StatefulWidget {
  const CreateGroupForm({
    super.key,
    required this.formKey,
    required this.groupNameController,
    required this.groupDescriptionController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController groupNameController;
  final TextEditingController groupDescriptionController;

  @override
  State<CreateGroupForm> createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<CreateGroupForm> {
  bool isGroupPublic = true;

  @override
  void initState() {
    super.initState();
    getit.get<GroupSocketService>().listenGroupCreated();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            inputFieldKey: const ValueKey('groupNameField'),
            controller: widget.groupNameController,
            hintText: 'Group Name',
            obsecureText: false,
            validator: (value) =>
                value!.isEmpty ? 'Group Name is required' : null,
          ),
          SizedBox(height: 16),
          CustomTextField(
            inputFieldKey: const ValueKey('groupDescriptionField'),
            controller: widget.groupDescriptionController,
            hintText: 'Group Description',
            obsecureText: false,
            validator: (value) => null,
          ),
          SizedBox(height: 16),

          //errors message box
          BlocBuilder<GroupCubit, GroupState>(
            builder: (context, state) {
              if (state is GroupError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(color: errorColor, fontSize: 16),
                  ),
                );
              }
              return const SizedBox.shrink(); // No error, return empty widget
            },
          ),

          // Custom Submit Button
          BlocListener<GroupCubit, GroupState>(
            listener: (context, state) {
              //if success navigate to the group screen
              //if loading show spinner
            },
            child: RoundedButton(
              onPressed: () {
                if (widget.formKey.currentState?.validate() ?? false) {
                  getit.get<GroupSocketService>().createGroup(
                      widget.groupNameController.text,
                      widget.groupDescriptionController.text);
                  context.goNamed(RouteNames.chats);
                }
              },
              buttonKey: const ValueKey('createGroupButton'),
              buttonTitle: 'Create Group',
            ),
          ),
        ],
      ),
    );
  }
}
