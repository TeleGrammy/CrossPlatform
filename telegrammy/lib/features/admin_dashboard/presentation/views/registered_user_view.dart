import 'package:flutter/material.dart';
import 'package:telegrammy/cores/widgets/app_bar.dart';
import 'package:telegrammy/features/admin_dashboard/data/models/registered_users_model.dart';
import 'package:telegrammy/features/admin_dashboard/presentation/widgets/admin_board_bar.dart';

class UserDetailView extends StatelessWidget {
  final RegisteredUsersData user;

  const UserDetailView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminboardAppBar (
          titleBar:user.username,
          key: const ValueKey('Single_Registered_Users_appbar'),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.picture),
                onBackgroundImageError: (_, __) =>
                    const Icon(Icons.person, size: 50, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            Text('Name: ${user.username}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Screen Name: ${user.screenName}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Email: ${user.email}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Phone: ${user.phone}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Bio: ${user.bio}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Status: ${user.status}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              'Banned: ${user.isBanned ? "Yes" : "No"}',
              style: TextStyle(
                fontSize: 18,
                color: user.isBanned ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
