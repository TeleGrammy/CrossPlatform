import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/features/groups/presentation/view_models/group_cubit.dart';
import 'package:telegrammy/features/groups/presentation/widgets/create_group_form.dart';

import '../../../../../cores/constants/app_colors.dart';
import '../../../../../cores/routes/route_names.dart';

class CreateGroupView extends StatelessWidget {
  CreateGroupView({super.key});

  final formKey = GlobalKey<FormState>();
  final groupNameController = TextEditingController();
  final groupDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const ValueKey('CreateGroupBackButton'),
          onPressed: () => context.goNamed(RouteNames.chats),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text('Create Group'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                BlocProvider(
                  create: (context) => GroupCubit(),
                  child: CreateGroupForm(
                    formKey: formKey,
                    groupNameController: groupNameController,
                    groupDescriptionController: groupDescriptionController,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
