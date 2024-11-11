import 'package:flutter/material.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';

class SettingsBox extends StatelessWidget {
  final List<Widget> children;
  const SettingsBox({super.key, this.children = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Column(
          children: children,
        ));
  }
}
