import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/profile_settings/profile_settings_app_bar.dart';
import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_cubit.dart';
import '../../view_models/profile_settings_cubit/profile_state.dart';
import 'edit_profile_info_view.dart';

class ChangePhoneNumberView extends StatefulWidget {
  const ChangePhoneNumberView({super.key});

  @override
  State<ChangePhoneNumberView> createState() => _ChangePhoneNumberViewState();
}

class _ChangePhoneNumberViewState extends State<ChangePhoneNumberView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ProfileSettingsAppBar(
          title: 'Change Phone Number',
          backButtonOnPressed: () => context.pop(),
          actions: [
            TextButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final success = await context
                        .read<ProfileSettingsCubit>()
                        .updateUserPhoneNumber(_phoneNumberController.text);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Phone number updated successfully!')),
                      );
                      context.pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'This phone number belongs to another user! Please try again.')),
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
            _phoneNumberController.text = state.profileInfo.phoneNumber ?? "";

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
                        valueKey: const ValueKey('PhoneNumberTextField'),
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
                    )
                  ]),
            ));
          }
          return Container();
        }));
  }
}
