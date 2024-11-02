import 'package:flutter/material.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/styles/styles.dart';

class GeneralAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleBar; // Add a final field for the title

  // Constructor to accept the title
  GeneralAppBar({required this.titleBar});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          // Implement your back navigation logic here
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      centerTitle: true,
      title: Text(
        titleBar,
        style: textStyle17.copyWith(fontWeight: FontWeight.w600), // Ensure textStyle17 is defined in your styles
      ),
      backgroundColor: appBarDarkMoodColor, // Ensure appBarDarkMoodColor is defined in your app_colors.dart
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Default height of the AppBar
}
