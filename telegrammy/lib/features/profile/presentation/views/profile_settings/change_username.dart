import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/profile_settings/profile_settings_app_bar.dart';
import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_cubit.dart';
import '../../view_models/profile_settings_cubit/profile_state.dart';
import 'edit_profile_info_view.dart';

class ChangeUsernameView extends StatefulWidget {
  const ChangeUsernameView({super.key});

  @override
  State<ChangeUsernameView> createState() => _ChangeUsernameViewState();
}

class _ChangeUsernameViewState extends State<ChangeUsernameView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
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
          title: 'Change Username',
          backButtonOnPressed: () => context.pop(),
          actions: [
            TextButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final success = await context
                        .read<ProfileSettingsCubit>()
                        .updateUsername(_usernameController.text);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Username updated successfully!')),
                      );
                      context.pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'This username is not available. Try another one!')),
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
            _usernameController.text = state.profileInfo.username ?? "";

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
                        valueKey: const ValueKey('UsernameTextField'),
                        controller: _usernameController,
                        labelText: 'Username',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
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
