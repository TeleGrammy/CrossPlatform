import 'package:flutter/material.dart';

class Customsigninbutton extends StatelessWidget {
  final IconData icon;
  const Customsigninbutton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108,
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      child: IconButton(
        onPressed: () {
          // Your onPressed logic here
        },
        icon: Icon(
          this.icon,
          size: 25.0, // Icon color
        ),
      ),
    );
  }
}
