import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';  // Import GoRouter
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
// import 'package:telegrammy/features/profile/presentation/views/privacy_allowable.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_state.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';

class PrivacyOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch privacy settings when this widget is built
    context.read<PrivacySettingsCubit>().fetchPrivacySettings();

    return BlocBuilder<PrivacySettingsCubit, PrivacyState>(
      builder: (context, state) {
        // Show loading indicator while fetching privacy options
        if (state is PrivacyInitial || state is PrivacyUpdating) {
          return Center(child: CircularProgressIndicator());
        }
        // Handle error state
        if (state is PrivacyOptionsError) {
          return Center(child: Text(state.message));
        }
        // Loaded state
        if (state is PrivacyOptionsLoaded) {
          return Column(
            children: [
              buildPrivacyTile(context, 'Last Seen & Online', 'lastSeen', state.privacyOptions.lastSeen),
              buildPrivacyTile(context, 'Profile Photo', 'profilePicture', state.privacyOptions.profilePicture),
              buildPrivacyTile(context, 'Stories', 'stories', state.privacyOptions.stories),
            ],
          );
        }
        // Default fallback
        return Center(child: Text('Unexpected state.'));
      },
    );
  }
}


  Widget buildPrivacyTile(BuildContext context, String title, String optionKey, String? optionValue) {
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

String _privacyOptionText(String? option) {
  switch (option?.toLowerCase()) { // Use lowercase for consistent matching
    case 'everyone':
      return 'Everyone';
    case 'my contacts':
      return 'My Contacts';
    case 'nobody':
      return 'Nobody';
    default:
      return 'Unknown';
  }
}

  void navigateToPrivacySettings(BuildContext context, String title, String optionKey) {
    context.goNamed(
      RouteNames.privacyAllowablePage,
      extra: {'title': title, 'optionKey': optionKey},
    );
  }
