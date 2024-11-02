import 'package:flutter/material.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/widgets/app_bar.dart';
import 'package:telegrammy/features/profile/presentation/widgets/stories_app_bar.dart';


class StoriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StoriesBar(),
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
              // SecurityOptions(),
              SizedBox(height: 50),
              // PrivacyOptions(),
            ],
          ),
        ),
      ),
    );
  }
}
