import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/profile_settings/profile_settings_app_bar.dart';
import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_cubit.dart';
import '../../view_models/profile_settings_cubit/profile_state.dart';
import 'edit_profile_info_view.dart';

class ChangeEmailView extends StatefulWidget {
  const ChangeEmailView({super.key});

  @override
  State<ChangeEmailView> createState() => _ChangeEmailViewState();
}

class _ChangeEmailViewState extends State<ChangeEmailView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileSettingsCubit>().loadBasicProfileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ProfileSettingsAppBar(
          title: 'Change Email',
          backButtonOnPressed: () => context.pop(),
          actions: [
            TextButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final success = await context
                        .read<ProfileSettingsCubit>()
                        .updateUserEmail(_emailController.text);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Email updated successfully!\nCheck your inbox to verify your new email!')),
                      );
                      context.pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'This email belongs to another user! Please try again.')),
                      );
                    }
                  }
                },
                child: Text(
                  'SAVE CHANGES',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
        body: BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
            builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ProfileError) {
            return Center(child: Text(state.errorMessage));
          }
          if (state is ProfileLoaded) {
            _emailController.text = state.profileInfo.email!;

            return SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Form(
                      key: _formKey,
                      child: ProfileInfoTextFormField(
                        valueKey: const ValueKey('EmailTextField'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        labelText: 'Email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    )
                  ]),
            ));
          }
          return Container();
        }));
  }
}
