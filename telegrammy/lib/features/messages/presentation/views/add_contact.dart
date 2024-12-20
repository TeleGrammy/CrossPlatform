import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/services/group_api_service.dart';
import 'package:telegrammy/features/groups/presentation/view_models/group_cubit.dart';
import 'package:telegrammy/features/groups/presentation/widgets/create_group_form.dart';

import '../../../../../cores/constants/app_colors.dart';
import '../../../../../cores/routes/route_names.dart';
import '../../../../cores/services/service_locator.dart';
import '../../../../cores/widgets/custom_text_field.dart';
import '../../../../cores/widgets/rounded_button.dart';

class AddContactView extends StatelessWidget {
  AddContactView({super.key});

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const ValueKey('AddContactBackButton'),
          onPressed: () => context.goNamed(RouteNames.chats),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text('Create Chat / Add Contact'),
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          inputFieldKey: const ValueKey('usernameField'),
                          controller: usernameController,
                          hintText: 'Username / Email / Phone Number',
                          obsecureText: false,
                          validator: (value) =>
                              value!.isEmpty ? 'username is required' : null,
                        ),
                        SizedBox(height: 16),
                        // Custom Submit Button
                        RoundedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              getit
                                  .get<GroupApiService>()
                                  .addContact(usernameController.text);
                              context.goNamed(RouteNames.chats);
                            }
                          },
                          buttonKey: const ValueKey('AddContactButton'),
                          buttonTitle: 'Add Contact',
                        ),
                      ],
                    ),
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
