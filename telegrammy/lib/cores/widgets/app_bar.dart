import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/routes/app_routes.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
import 'package:telegrammy/cores/styles/styles.dart';

class GeneralAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleBar;
  final ValueKey<String> key;
  // final String nextRoutename;

  GeneralAppBar({required this.titleBar, required this.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: key,
      leading: IconButton(
        onPressed: () {
          print(titleBar);
  // if (titleBar != 'Stories' && titleBar != 'Profile Photo' && titleBar != 'Last Seen & Online') {
  // print('previous');
  context.pop();
// } else {
//   print('go');
//   context.goNamed(RouteNames.profilePrivacyPage);
// }

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
