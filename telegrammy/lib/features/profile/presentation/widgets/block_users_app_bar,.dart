import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/cores/styles/styles.dart';

class BlockAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleBar; // Add a final field for the title
 final ValueKey<String> key;
  // Constructor to accept the title
  BlockAppBar({required this.titleBar, required this.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        key: key,
      leading: IconButton(
        onPressed: () {
         print(titleBar);
          // if (titleBar != 'Stories' && titleBar != 'Profile Photo' && titleBar != 'Last Seen & Online') {
          // print('previous');
//           if(titleBar!='Blocked Users')
//            context.goNamed(RouteNames.blockingView);
//  else
  
  context.goNamed(RouteNames.profilePrivacyPage);

    
        },
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
    centerTitle: true,
      title: Text(
        titleBar,
        style: textStyle17.copyWith(fontWeight: FontWeight.w600),
      ),
      backgroundColor: primaryColor, // Ensure appBarDarkMoodColor is defined
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight); // Default height of the AppBar
}
