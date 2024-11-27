import 'package:flutter/material.dart';

class PushNotification extends StatelessWidget {
  final String sender;
  final String message;
  final String timestamp;

  const PushNotification({required this.sender, required this.message, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Card(
        color: Colors.blueAccent,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          title: Text(sender, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text(message, style: TextStyle(color: Colors.white70)),
          trailing: Text(timestamp, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}