import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_state.dart';
import 'package:telegrammy/cores/routes/route_names.dart';

class PrivacyOptions extends StatefulWidget {
  @override
  _PrivacyOptionsState createState() => _PrivacyOptionsState();
}

class _PrivacyOptionsState extends State<PrivacyOptions> {
  @override
  void initState() {
    super.initState();
    // Fetch privacy settings when the widget is initialized
    context.read<PrivacySettingsCubit>().fetchPrivacySettings();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrivacySettingsCubit, PrivacyState>(
      listener: (context, state) {
        if (state is PrivacyOptionsError) {
          // Show error as a Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }

        if (state is PrivacyUpdating) {
          // Optional: Show a loading indicator or similar action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Updating privacy settings...')),
          );
        }
      },
      child: BlocBuilder<PrivacySettingsCubit, PrivacyState>(
        builder: (context, state) {
          // Show loading indicator while fetching privacy options
          if (state is PrivacyLoading || state is PrivacyUpdating) {
            return Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (state is PrivacyOptionsError) {
            return Center(child: Text('Failed to load privacy settings'));
          }

          // Loaded state
          if (state is PrivacyOptionsLoaded) {
            return Column(
              key: const ValueKey('PrivacyOptions'),
              children: [
                buildPrivacyTile(context, 'Last Seen & Online', 'lastSeen',
                    state.privacyOptions.lastSeen),
                buildPrivacyTile(context, 'Profile Photo', 'profilePicture',
                    state.privacyOptions.profilePicture),
                buildPrivacyTile(context, 'Stories', 'stories',
                    state.privacyOptions.stories),
              ],
            );
          }

          // Default fallback (optional)
          return Center(child: Text('Unexpected state'));
        },
      ),
    );
  }

  Widget buildPrivacyTile(BuildContext context, String title, String optionKey,
      String optionValue) {
    return Container(
      color: primaryColor,
      child: ListTile(
        leading: Text(
          title,
          style: textStyle17.copyWith(fontWeight: FontWeight.w400),
        ),
        trailing: Text(
          _privacyOptionText(optionValue),
          style: textStyle17.copyWith(
              fontWeight: FontWeight.w400, color: tileInfoHintColor),
        ),
        onTap: () {
          navigateToPrivacySettings(context, title, optionKey);
        },
      ),
    );
  }

  String _privacyOptionText(String option) {
    switch (option.toLowerCase()) {
      case 'everyone':
        return 'EveryOne';
      case 'contacts':
        return 'Contacts';
      case 'nobody':
        return 'Nobody';
      default:
        return 'Unknown';
    }
  }

  void navigateToPrivacySettings(
      BuildContext context, String title, String optionKey) {
    context.goNamed(
      RouteNames.privacyAllowablePage,
      extra: {'title': title, 'optionKey': optionKey},
    );
  }
}
