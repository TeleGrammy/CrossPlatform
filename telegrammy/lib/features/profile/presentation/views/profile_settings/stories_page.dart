import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/widgets/rounded_button.dart';
import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_cubit.dart';
import 'package:telegrammy/features/profile/presentation/widgets/profile_settings/profile_settings_app_bar.dart';
import '../../view_models/profile_settings_cubit/profile_state.dart';

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileSettingsAppBar(title: 'My Stories'),
      body: BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
          builder: (context, state) {
        if (state is ProfileInitial) {
          context.read<ProfileSettingsCubit>().loadBasicProfileInfo();
        } else if (state is ProfileLoading) {
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
                    RoundedButton(onPressed: () {}, buttonTitle: 'Add Story'),
                  ],
                ),
              ),
            ),
          );
        }
        return Center(child: Text('-'));
      }),
    );
  }
}
