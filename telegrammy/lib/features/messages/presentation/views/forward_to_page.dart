import 'package:flutter/material.dart';

class ForwardToPage extends StatelessWidget {
  // Example list of contacts
  final List<Map<String, String>> contacts = [
    {'name': 'Alice', 'image': 'assets/images/logo.png'},
    {'name': 'Bob', 'image': 'assets/images/logo.png'},
    {'name': 'Charlie', 'image': 'assets/images/logo.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Forward To'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(contact['image']!),
              radius: 24,
            ),
            title: Text(contact['name']!),
            onTap: () {
              // Handle forward action here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Forwarded to ${contact['name']}')),
              );
            },
          );
        },
      ),
    );
  }
}
