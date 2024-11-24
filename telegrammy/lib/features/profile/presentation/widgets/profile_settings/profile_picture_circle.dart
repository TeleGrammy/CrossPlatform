import 'dart:io';

import 'package:flutter/material.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';

class ProfilePictureCircle extends StatelessWidget {
  const ProfilePictureCircle({super.key, this.image});

  final File? image;
  final profilePicPlaceholderIcon = const Icon(
    Icons.account_circle_rounded,
    size: 120.0,
  );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ClipOval(
        child: Container(
          height: 160.0,
          width: 160.0,
          decoration: BoxDecoration(
            color: primaryColor, // Set background color if image is null
          ),
          child: image == null
              ? profilePicPlaceholderIcon
              : Image.file(
                  image!,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
