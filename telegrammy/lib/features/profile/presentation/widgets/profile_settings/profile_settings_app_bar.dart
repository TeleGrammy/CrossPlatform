import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../cores/constants/app_colors.dart';
import '../../../../../cores/routes/routes_name.dart';
import '../../../../../cores/styles/styles.dart';

class ProfileSettingsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ProfileSettingsAppBar(
      {super.key,
      required this.title,
      required this.backButtonOnPressed,
      this.actions});

  final String title;
  final List<Widget>? actions;
  final Function backButtonOnPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: const ValueKey('ProfileSettingsAppBar'),
      leading: IconButton(
        onPressed: () => backButtonOnPressed(),
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
