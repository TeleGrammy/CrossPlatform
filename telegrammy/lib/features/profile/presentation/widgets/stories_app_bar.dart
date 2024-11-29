import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';

class StoriesBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          context.goNamed(
            RouteNames.profileInfo,
          );
        },
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      centerTitle: true,
      title: Text(
        'Stories',
        style: textStyle17.copyWith(fontWeight: FontWeight.w600),
      ),
      backgroundColor: primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            // Add your camera functionality here
            print('camera clicked');
          },
          icon: Icon(Icons.camera_alt, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            print('search clicked');
          },
          icon: Icon(Icons.search, color: Colors.white),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Settings') {
              context.goNamed(RouteNames.profilePrivacyPage);
            } else if (value == 'Story Settings') {
              context.pushNamed(RouteNames.storiesPage);
            }
          },
          icon: Icon(Icons.settings, color: Colors.white),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'Settings',
                child: Text('Settings'),
              ),
              PopupMenuItem(
                value: 'Story Settings',
                child: Text('Story Settings'),
              ),
            ];
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
