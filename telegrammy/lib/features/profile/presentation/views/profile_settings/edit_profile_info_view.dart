import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_cubit.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/bio_text_field.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/change_profile_picture_button.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/profile_settings_app_bar.dart';
import '../../view_models/profile_settings_cubit/profile_state.dart';
import '../../widgets/profile_settings/profile_picture_circle.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/settings_box.dart';
import 'dart:io';

class EditProfileInfoView extends StatefulWidget {
  const EditProfileInfoView({super.key});

  @override
  State<EditProfileInfoView> createState() => _EditProfileInfoViewState();
}

class _EditProfileInfoViewState extends State<EditProfileInfoView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _screenNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    _screenNameController.dispose();
    _bioController.dispose();
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
          title: 'Edit Profile Info',
          backButtonOnPressed: () {
            context.goNamed(RouteNames.profileInfo);
          },
          actions: [
            TextButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await context
                        .read<ProfileSettingsCubit>()
                        .updateBasicProfileInfo(
                            screenName: _screenNameController.text,
                            bio: _bioController.text);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile updated successfully!')),
                    );
                    //context.pop();
                    context.goNamed(RouteNames.profileInfo);
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
            _screenNameController.text = state.profileInfo.screenName ?? "";
            _bioController.text = state.profileInfo.bio ?? "";

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20),
                      ProfilePictureCircle(
                          imageUrl: state.profileInfo.profilePic),
                      ChangeProfilePictureButton(),
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(children: [
                          ProfileInfoTextFormField(
                            valueKey: const ValueKey('ScreenNameTextField'),
                            controller: _screenNameController,
                            labelText: 'Screen Name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a screen name';
                              }
                              return null;
                            },
                          ),
                          BioTextField(
                            controller: _bioController,
                            valueKey: const ValueKey('BioTextField'),
                          ),
                        ]),
                      ),
                      SizedBox(height: 40),
                      SettingsBox(
                        valueKey: const ValueKey('EditProfileInfoBox'),
                        children: [
                          ListTile(
                            title: Text('Change username'),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              context.pushNamed(RouteNames.changeUsername);
                            },
                          ),
                          ListTile(
                            title: Text('Change email'),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              context.pushNamed(RouteNames.changeEmail);
                            },
                          ),
                          ListTile(
                            title: Text('Change phone number'),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              context.pushNamed(RouteNames.changePhoneNumber);
                            },
                          ),
                        ],
                      )
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

class ProfileInfoTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final ValueKey<String>? valueKey;
  const ProfileInfoTextFormField(
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
