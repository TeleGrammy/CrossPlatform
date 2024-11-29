import 'package:flutter/material.dart';
import 'package:telegrammy/cores/styles/styles.dart';

class AddCommentButton extends StatelessWidget {
  const AddCommentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      margin: EdgeInsets.all(0),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero, // Remove default TextButton padding
          minimumSize: Size(0, 0), // Ensures no extra space
          tapTargetSize:
              MaterialTapTargetSize.shrinkWrap, // Compact button area
        ),
        key: Key('addCommentButton'),
        onPressed: () {
          //got to post comment screen
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.comment,
              color: Colors.black,
              size: 20.0,
            ),
            Text(
              ' add Comment',
              style: textStyle13,
            ),
          ],
        ),
      ),
    );
  }
}
