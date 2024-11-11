import 'dart:async';
import 'package:flutter/material.dart';

class Customsigninbutton extends StatefulWidget {
  final IconData icon;
  final Future<void> Function() signinWithSocialAccount;
  const Customsigninbutton(
      {super.key, required this.icon, required this.signinWithSocialAccount});

  @override
  State<Customsigninbutton> createState() => _CustomsigninbuttonState();
}

class _CustomsigninbuttonState extends State<Customsigninbutton> {
  @override
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
        onPressed: () async {
          widget.signinWithSocialAccount();
        },
        icon: Icon(
          widget.icon,
          size: 25.0, // Icon size
        ),
      ),
    );
  }
}
