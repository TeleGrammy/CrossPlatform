import 'package:flutter/material.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/features/profile/presentation/widgets/create_story_widget.dart';
import 'package:telegrammy/features/profile/presentation/widgets/storyList_widget.dart';
import 'package:telegrammy/features/profile/presentation/widgets/stories_app_bar.dart';

class StoriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StoriesBar(),
      body: Container(
        color: appBarDarkMoodColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0), // Adjust the top padding here
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Status',
                  style: textStyle17.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 30),
                CreateStoryWidget(),
                // SizedBox(height: 50),
                // StoryListWidget(),
                
                // PrivacyOptions(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
