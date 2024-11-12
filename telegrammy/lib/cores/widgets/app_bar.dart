import 'package:flutter/material.dart';
import 'package:telegrammy/cores/constants/app_colors.dart'; 
import 'package:telegrammy/cores/styles/styles.dart';

class GeneralAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleBar; 


  GeneralAppBar(this.titleBar);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
      
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back, color: Colors.white), 
      ),
      centerTitle: true,
      title: Text(
        titleBar,
        style: textStyle17.copyWith(fontWeight: FontWeight.w600), 
      ),
      backgroundColor: appBarDarkMoodColor, // Ensure appBarDarkMoodColor is defined
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Default height of the AppBar
}
