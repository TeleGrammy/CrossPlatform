import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: GeneralAppBar(
        titleBar: title,
        key: const ValueKey('PrivacyAllowableAppBar'),
      ),
      backgroundColor: secondaryColor,
      body: BlocListener<PrivacySettingsCubit, PrivacyState>(
        listener: (context, state) {
          if (state is PrivacyOptionsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<PrivacySettingsCubit, PrivacyState>(
          buildWhen: (previous, current) {
            // Avoid unnecessary rebuilds
            return current is PrivacyOptionsLoaded || current is PrivacyLoading;
          },
          builder: (context, state) {
            if (state is PrivacyLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is PrivacyOptionsLoaded) {
              final selectedOption = _getSelectedOption(state);

              return Column(
                key: const ValueKey('PrivacyOptionsColumn'),
                children: [
                  const SizedBox(height: 50),
                  buildPrivacyAllowableTile(
                    context, 'Everybody', PrivacyOption.everyone, selectedOption),
                  buildPrivacyAllowableTile(
                    context, 'My Contacts', PrivacyOption.contacts, selectedOption),
                  buildPrivacyAllowableTile(
                    context, 'Nobody', PrivacyOption.nobody, selectedOption),
                ],
              );
            }

            return Center(child: Text('Failed to load privacy options.'));
          },
        ),
      ),
    );
  }

  String? _getSelectedOption(PrivacyState state) {
    if (state is PrivacyOptionsLoaded) {
      // Ensure we are correctly fetching the state for the selected option
      if (optionKey == 'profilePicture') return state.privacyOptions.profilePicture;
      if (optionKey == 'stories') return state.privacyOptions.stories;
      if (optionKey == 'lastSeen') return state.privacyOptions.lastSeen;
    }
    return null; // Default fallback for unexpected state
  }

  Widget buildPrivacyAllowableTile(
      BuildContext context, String title, PrivacyOption value, String? selectedOption) {
    return Container(
      color: appBarDarkMoodColor,
      child: RadioListTile<PrivacyOption>(
        title: Text(
          title,
          style: textStyle17.copyWith(
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        value: value,
        groupValue: _getPrivacyOptionFromName(selectedOption),
        activeColor: Colors.blue,
        onChanged: (PrivacyOption? selectedValue) {
          if (selectedValue != null) {
            context.read<PrivacySettingsCubit>().updatePrivacyOption(optionKey, selectedValue);
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
