import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/widgets/app_bar.dart';
// import 'package:telegrammy/features/profile/presentation/widgets/security_options.dart';
import 'package:telegrammy/features/profile/presentation/widgets/privacy_options.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_cubit.dart';
import 'package:telegrammy/features/profile/presentation/widgets/security_options.dart';

class PrivacyView extends StatefulWidget {
  @override
  _PrivacyViewState createState() => _PrivacyViewState();
}

class _PrivacyViewState extends State<PrivacyView> {
  late PrivacySettingsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PrivacySettingsCubit();
    _cubit.fetchPrivacySettings(); // Call to load privacy settings
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: Scaffold(
        appBar: GeneralAppBar(
          titleBar: 'Privacy & Security',
          key: const ValueKey('PrivacyAndSecurityAppBar'),
        ),
        body: Container(
          key: const ValueKey('PrivacyAndSecuritySettingsBody'),
          // color: backGroundColor,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                SecurityOptions(), // Uncomment if needed
                SizedBox(height: 50),
                PrivacyOptions(), // This will now receive updates from the cubit
              ],
            ),
          ),
        ),
      ),
    );
  }
}
