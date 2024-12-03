import 'package:flutter/material.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:go_router/go_router.dart';

class CreateStoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('CreateStory'),
      padding: EdgeInsets.symmetric(vertical: 20), // Adjust vertical padding
      alignment: Alignment.centerLeft, // Align container content to the left
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.start, // Align children to the start (left)
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to UserStoryView when the avatar is tapped
              context.pushNamed(RouteNames.createStoryPage);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 30, // Size of the circle
                  backgroundImage: AssetImage(
                      'assets/images/story_image.jpg'), // Replace with your asset
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.blue,
                          width: 2), // Border around the avatar
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4), // Padding around the plus icon
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1), // Position of shadow
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.blue, // Color of the plus icon
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 40), // Space between avatar and text
          Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Align texts to the start within the column
            children: [
              Text(
                'My Status',
                style: textStyle17.copyWith(
                    fontWeight: FontWeight.w600), // Title 1
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to UserStoryView when the text is tapped
                  context.pushNamed(RouteNames.userStoryPage);
                },
                child: Text(
                  'Tap to see your status update',
                  style: textStyle17.copyWith(
                      fontWeight: FontWeight.w400, color: tileInfoHintColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
