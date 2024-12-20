import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/cores/styles/styles.dart';

class AdminboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleBar;
  final ValueKey<String> key;
  final String signn;
  // final String nextRoutename;

  AdminboardAppBar({required this.titleBar, required this.key,required this.signn});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: key,
      leading: IconButton(
        onPressed: () {
          print(titleBar);
          // if (titleBar != 'Stories' && titleBar != 'Profile Photo' && titleBar != 'Last Seen & Online') {
          // print('previous');
          if(signn=='1')
           context.goNamed(RouteNames.adminDashboardPage);
 else if  (signn=='2')
  context.goNamed(RouteNames.adminDashboardPageFilterMedia);
 else
  context.goNamed(RouteNames.chats);

        },
        icon: Icon(Icons.arrow_back, color: Colors.white)
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
