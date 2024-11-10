import 'package:flutter/material.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';

// Widget for displaying a contact's story
class ContactStoryWidget extends StatelessWidget {
  final String contactName;
  final String storyImage;

  ContactStoryWidget({required this.contactName, required this.storyImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(storyImage),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green, width: 2), // Green border for contacts
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            contactName,
            style: textStyle17.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// Horizontal ListView for displaying the user's story widget and contacts' stories
class StoryListWidget extends StatelessWidget {
  final List<Map<String, String>> contactStories = [
    {'name': 'Alice', 'image': 'assets/images/story_image.jpg'},
    {'name': 'Bob', 'image': 'assets/images/story_image.jpg'},
    {'name': 'Charlie', 'image': 'assets/images/story_image.jpg'},
    // Add more contacts here
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: contactStories.length,
        itemBuilder: (context, index) {
          final contact = contactStories[index];
          return ContactStoryWidget(
            contactName: contact['name']!,
            storyImage: contact['image']!,
          );
        },
      ),
    );
  }
}