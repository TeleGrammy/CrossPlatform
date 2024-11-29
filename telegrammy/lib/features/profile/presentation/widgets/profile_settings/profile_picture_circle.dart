import 'dart:io';

import 'package:flutter/material.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';

class ProfilePictureCircle extends StatelessWidget {
  const ProfilePictureCircle({super.key, this.imageUrl});

  final String? imageUrl;
  final profilePicPlaceholderIcon = const Icon(
    Icons.account_circle_rounded,
    size: 120.0,
  );

  @override
  Widget build(BuildContext context) {
    return Align(
      key: const ValueKey('ProfilePictureCircle'),
      alignment: Alignment.center,
      child: ClipOval(
        child: Container(
          height: 160.0,
          width: 160.0,
          decoration: BoxDecoration(
            color: primaryColor, // Set background color if image is null
          ),
          child: imageUrl == null
              ? profilePicPlaceholderIcon
              : Image.network(
                  imageUrl!, // Use NetworkImage URL here
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // The image has finished loading
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return profilePicPlaceholderIcon; // Placeholder for error cases
                  },
                ),
        ),
      ),
    );
  }
}
