import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../cores/constants/app_colors.dart';
import '../../../../../cores/styles/styles.dart';

class ProfileSettingsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ProfileSettingsAppBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      centerTitle: true,
      title: Text(
        title,
        style: textStyle17.copyWith(fontWeight: FontWeight.w600),
      ),
      actions: actions,
      backgroundColor: primaryColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
