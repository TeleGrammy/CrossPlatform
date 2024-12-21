import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/app_routes.dart';

import '../../../../cores/routes/route_names.dart';

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
          key: const Key('backButton'), // Key for back button
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(RouteNames.chatWrapper),
        ),
        title: Text(
          'Forward To',
          key: const Key('appBarTitle'), // Key for app bar title
        ),
        actions: [
          IconButton(
            key: const Key('searchButton'), // Key for search button
            icon: Icon(Icons.search),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
      ),
      body: ListView.builder(
        key: const Key('contactsList'), // Key for ListView
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            key: Key('contactTile_$index'), // Key for each ListTile
            leading: CircleAvatar(
              key: Key('contactAvatar_$index'), // Key for CircleAvatar
              backgroundImage: AssetImage(contact['image']!),
              radius: 24,
            ),
            title: Text(
              contact['name']!,
              key: Key('contactName_$index'), // Key for contact name
            ),
            onTap: () {
              // Handle forward action here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  key: const Key('forwardSnackBar'), // Key for SnackBar
                  content: Text('Forwarded to ${contact['name']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
