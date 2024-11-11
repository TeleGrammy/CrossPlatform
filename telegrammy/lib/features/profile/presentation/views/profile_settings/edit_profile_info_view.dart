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

class EditProfileInfoView extends StatefulWidget {
  const EditProfileInfoView({super.key});

  @override
  State<EditProfileInfoView> createState() => _EditProfileInfoViewState();
}

class _EditProfileInfoViewState extends State<EditProfileInfoView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _screenNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    _screenNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
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
          actions: [
            TextButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await context
                        .read<ProfileSettingsCubit>()
                        .updateBasicProfileInfo(
                            screenName: _screenNameController.text,
                            userName: _usernameController.text,
                            email: _emailController.text,
                            phoneNumber: _phoneNumberController.text,
                            bio: _bioController.text);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile updated successfully!')),
                    );
                    context.pop();
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
            _screenNameController.text = state.user.screenName ?? "";
            _usernameController.text = state.user.username ?? "";
            _emailController.text = state.user.email;
            _phoneNumberController.text = state.user.phoneNumber ?? "";
            _bioController.text = state.user.bio ?? "";

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    ProfilePictureCircle(image: state.user.profilePic),
                    ChangeProfilePictureButton(),
                    SizedBox(height: 20),
                    Form(
                        key: _formKey,
                        child: Column(children: [
                          ProfileInfoTextFormField(
                            controller: _screenNameController,
                            labelText: 'Screen Name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a screen name';
                              }
                              return null;
                            },
                          ),
                          ProfileInfoTextFormField(
                            controller: _usernameController,
                            labelText: 'Username',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              //TODO: verify username is unique
                              return null;
                            },
                          ),
                          ProfileInfoTextFormField(
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
                          ProfileInfoTextFormField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.number,
                            labelText: 'Phone Number',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a phone number';
                              }
                              if (value.length != 11) {
                                return 'Phone number must be 11 digits';
                              }
                              return null;
                            },
                          ),
                          BioTextField(controller: _bioController),
                        ])),
                  ],
                )),
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
  const ProfileInfoTextFormField(
      {super.key,
      this.controller,
      this.keyboardType = TextInputType.text,
      this.labelText = "",
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
