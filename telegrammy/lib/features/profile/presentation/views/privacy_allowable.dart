import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';

import 'package:telegrammy/cores/widgets/app_bar.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_state.dart';

class PrivacyAllowablePage extends StatelessWidget {
  final String title;
  final String optionKey;

  PrivacyAllowablePage({required this.title, required this.optionKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GeneralAppBar(title),
      backgroundColor: secondaryColor,
      body: BlocBuilder<PrivacySettingsCubit, PrivacyState>(
        builder: (context, state) {
          // Show loading indicator while privacy options are being loaded
          if (state is PrivacyUpdating) {
            return Center(child: CircularProgressIndicator());
          }
          // Handle loaded state
          if (state is PrivacyOptionsLoaded) {
            final profileVisibility = state.privacyOptions;
            final selectedOption = optionKey == 'profilePicture'
                ? profileVisibility.profilePicture
                : optionKey == 'stories'
                    ? profileVisibility.stories
                    : profileVisibility.lastSeen;

            return Column(
              children: [
                SizedBox(height: 50),
                buildPrivacyAllowableTile(context, 'Everybody', PrivacyOption.everyone, selectedOption),
                buildPrivacyAllowableTile(context, 'My Contacts', PrivacyOption.contacts, selectedOption),
                buildPrivacyAllowableTile(context, 'Nobody', PrivacyOption.nobody, selectedOption),
              ],
            );
          }
          // Handle error state
          if (state is PrivacyOptionsError) {
            return Center(child: Text(state.message));
          }

          // Default fallback
          return Center(child: Text('Unexpected state.'));
        },
      ),
    );
  }

  Widget buildPrivacyAllowableTile(BuildContext context, String title, PrivacyOption value, String? selectedOption) {
    return Container(
      color: appBarDarkMoodColor,
      child: RadioListTile<PrivacyOption>(
        title: Text(
          title,
          style: textStyle17.copyWith(fontWeight: FontWeight.w400, color: Colors.white),
        ),
        value: value,
        groupValue: _getPrivacyOptionFromName(selectedOption),
        activeColor: Colors.blue,
        onChanged: (PrivacyOption? selectedValue) {
          if (selectedValue != null) {
            print('iam hereeeeeeeeeeeeeeeeeeeeeeee');
            context.read<PrivacySettingsCubit>().updatePrivacyOption(optionKey, selectedValue);
            // Navigator.pop(context);
          }
        },
      ),
    );
  }

  PrivacyOption? _getPrivacyOptionFromName(String? selectedOption) {
    switch (selectedOption) {
      case 'Everybody':
        return PrivacyOption.everyone;
      case 'My Contacts':
        return PrivacyOption.contacts;
      case 'Nobody':
        return PrivacyOption.nobody;
      default:
        return null;
    }
  }
}