import 'package:flutter/material.dart';

class CustomRowDivider extends StatelessWidget {
  const CustomRowDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey, // Line color
            height: 1, // Line height
            thickness: 1, // Line thickness
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Or Login with'),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey, // Line color
            height: 1, // Line height
            thickness: 1, // Line thickness
          ),
        ),
      ],
    );
  }
}