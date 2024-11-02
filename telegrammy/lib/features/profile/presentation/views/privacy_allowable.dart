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
      appBar: GeneralAppBar(title),
    
      backgroundColor: secondaryColor, // Set the background color to black
      body: BlocBuilder<PrivacySettingsCubit, PrivacyState>(
        builder: (context, state) {
          final selectedOption = state is PrivacyOptionsLoaded
              ? state.privacyOptions[optionKey]
              : PrivacyOption.everyone;

          return Column(
            children: [
              SizedBox(height: 50),
              buildPrivacyAllowableTile(context, 'Everybody', PrivacyOption.everyone, selectedOption),
              buildPrivacyAllowableTile(context, 'My Contacts', PrivacyOption.contacts, selectedOption),
              buildPrivacyAllowableTile(context, 'Nobody', PrivacyOption.nobody, selectedOption),
            ],
          );
        },
      ),
    );
  }

  Widget buildPrivacyAllowableTile(BuildContext context, String title, PrivacyOption value, PrivacyOption? groupValue) {
    return Container(
      color: appBarDarkMoodColor, // Use a color that contrasts with black
      child: RadioListTile<PrivacyOption>(
        title: Text(
          title,
          style: textStyle17.copyWith(fontWeight: FontWeight.w400, color: Colors.white), // Set text color to white
        ),
        value: value,
        groupValue: groupValue,
        activeColor: Colors.blue, // Set active color for radio
        onChanged: (PrivacyOption? selectedValue) {
          if (selectedValue != null) {
            context.read<PrivacySettingsCubit>().updatePrivacyOption(optionKey, selectedValue);
            Navigator.pop(context); // Return to the previous screen
          }
        },
      ),
    );
  }
}
