import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/widgets/app_bar.dart';
import 'package:telegrammy/features/profile/presentation/widgets/security_options.dart';
import 'package:telegrammy/features/profile/presentation/widgets/privacy_options.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_cubit.dart';

class PrivacyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Load privacy options when the widget is built
    final cubit = context.read<PrivacySettingsCubit>();
    cubit.loadPrivacyOptions();

    return Scaffold(
      appBar: GeneralAppBar('Privacy & Security'),
      body: Container(
        color: secondaryColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              SecurityOptions(),
              SizedBox(height: 50),
              PrivacyOptions(),
            ],
          ),
        ),
      ),
    );
  }
}
