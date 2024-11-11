import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_state.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/profile_settings_app_bar.dart';
import '../../widgets/profile_settings/profile_picture_circle.dart';
import '../../widgets/profile_settings/basic_info_list.dart';
import '../../widgets/profile_settings/status_and_last_seen_list.dart';
import '../../widgets/profile_settings/settings_box.dart';
import '../../../../../cores/styles/styles.dart';

class ProfileInfoView extends StatefulWidget {
  const ProfileInfoView({super.key});

  @override
  State<ProfileInfoView> createState() => _ProfileInfoViewState();
}

class _ProfileInfoViewState extends State<ProfileInfoView> {
  Future<void> _loadBasicProfileInfo(BuildContext context) async {
    await context.read<ProfileSettingsCubit>().loadBasicProfileInfo();
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
        title: 'Profile Info',
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.white,
            onPressed: () => context.pushNamed(RouteNames.editProfileInfo),
          ),
        ],
      ),
      body: BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
        builder: (context, state) {
          print(state);
          if (state is ProfileLoading || state is ProfileInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(child: Text(state.errorMessage));
          } else if (state is ProfileLoaded) {
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
                        SizedBox(height: 20),
                        Text(
                          state.user.screenName ?? "",
                          style: textStyle30,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        BasicInfoList(user: state.user),
                        SizedBox(height: 20),
                        StatusAndLastSeenList(
                            status: state.user.status,
                            lastSeen: state.user.lastSeen),
                        SizedBox(height: 20),
                        SettingsBox(
                          children: [
                            ListTile(
                              title: Text('My Stories'),
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () =>
                                  context.pushNamed(RouteNames.storiesPage),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        SettingsBox(
                          children: [
                            ListTile(
                                title: Text('Privacy and Security Settings'),
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  //TODO: navigate to privacy settings
                                  context
                                      .pushNamed(RouteNames.profilePrivacyPage);
                                })
                          ],
                        ),
                      ],
                    ),
                  )),
            );
          }
          return Center(child: Text('-'));
        },
      ),
    );
  }
}
