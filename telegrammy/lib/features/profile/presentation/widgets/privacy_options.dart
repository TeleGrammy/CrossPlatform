import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';  // Import GoRouter
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/features/profile/presentation/views/privacy_allowable.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_state.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';

class PrivacyOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrivacySettingsCubit, PrivacyState>(
      builder: (context, state) {
        if (state is PrivacyOptionsLoaded) {
          return Column(
            children: [
              buildPrivacyTile(context, 'Last Seen & Online', 'Last Seen', state.privacyOptions['Last Seen']),
              buildPrivacyTile(context, 'Profile Photo', 'Profile Photo', state.privacyOptions['Profile Photo']),
              buildPrivacyTile(context, 'Stories', 'Stories', state.privacyOptions['Stories']),
              buildPrivacyTile(context, 'Groups & Channels', 'Groups', state.privacyOptions['Groups']),
            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  // Helper method to build privacy tiles
  Widget buildPrivacyTile(BuildContext context, String title, String optionKey, PrivacyOption? optionValue) {
    return Container(
      color: appBarDarkMoodColor,
      child: ListTile(
        leading: Text(
          title,
          style: textStyle17.copyWith(fontWeight: FontWeight.w400),
        ),
        trailing: Text(
          _privacyOptionText(optionValue),
          style: textStyle17.copyWith(fontWeight: FontWeight.w400, color: tileInfoHintColor),
        ),
        onTap: () {
          navigateToPrivacySettings(context, title, optionKey);
        },
      ),
    );
  }

  // Helper function to convert PrivacyOption to text
  String _privacyOptionText(PrivacyOption? option) {
    switch (option) {
      case PrivacyOption.everyone:
        return 'Everyone';
      case PrivacyOption.contacts:
        return 'My Contacts';
      case PrivacyOption.nobody:
        return 'Nobody';
      default:
        return 'Unknown';
    }
  }

  // Navigation function to PrivacyAllowablePage using named route
 void navigateToPrivacySettings(BuildContext context, String title, String optionKey) {
  // Pass parameters using the 'extra' property
  context.goNamed(RouteNames.privacyAllowablePage, extra: '$title,$optionKey');
}
}
