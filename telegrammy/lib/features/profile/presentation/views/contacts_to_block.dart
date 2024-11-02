import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/widgets/app_bar.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_cubit.dart'; 
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_state.dart';

class ContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contacts = [
      User(id: 4, name: 'User 4', isBlocked: false),
      User(id: 5, name: 'User 5', isBlocked: false),
    ];

    return Scaffold(
      appBar: GeneralAppBar(
        'Block User', // Title for the app bar
      ),
      body: Container(
        color: Colors.black, // Set background color of the column to black
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final user = contacts[index];
                  return ListTile(
                    tileColor: Colors.white, // White background for each tile
                    leading: Icon(Icons.person, color: tileInfoHintColor),
                    title: Text(
                      user.name,
                      style: TextStyle(color: tileInfoHintColor), // Text color for contrast
                    ),
                    onTap: () {
                      context.read<SecurityCubit>().addBlockedUser(user);                   
                      Navigator.pop(context); // Go back after blocking the user
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
