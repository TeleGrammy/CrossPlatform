import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/widgets/app_bar.dart';
import 'package:telegrammy/features/profile/data/repos/profile_repo.dart';
import 'package:telegrammy/features/profile/presentation/view_models/blocked_users_cubit/blocked_users_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/blocked_users_cubit/blocked_users_state.dart';


class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    super.initState();
    // Load contacts when the widget is initialized
    context.read<ContactsCubit>().loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GeneralAppBar('Block User'),
      body: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ContactsError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (state is ContactsLoaded) {
            final contacts = state.contacts;

            return Column(
  children: [
    SizedBox(height: 30),
    Expanded(
      child: contacts.isNotEmpty
          ? ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  tileColor: primaryColor, // Tile background color
                  leading: CircleAvatar(
       backgroundImage: AssetImage('assets/images/logo.png'), // Use AssetImage for image assets
    radius: 20, // Size of the circular avatar
  ),
                  title: Text(
                    contact.contactId,
                    style: TextStyle(color: tileInfoHintColor), // Text color
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.block, color: Colors.red),
                    onPressed: () {
                      // Uncomment and implement block user functionality
                      // context.read<ContactsCubit>().blockUser(contact.contactId);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text('${contact.userName} has been blocked.'),
                      //   ),
                      // );
                    },
                  ),
                );
              },
            )
          : Center(
              child: Text(
                'No contacts available.',
                style: TextStyle(color: tileInfoHintColor), // Text color for contrast
              ),
            ),
    ),
  ],
);

          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
