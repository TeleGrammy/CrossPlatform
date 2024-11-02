import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/widgets/app_bar.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/privacy_cubit/privacy_state.dart';
import 'package:telegrammy/features/profile/presentation/views/contacts_to_block.dart';

class BlockingPage extends StatefulWidget {
  @override
  _BlockingPageState createState() => _BlockingPageState();
}

class _BlockingPageState extends State<BlockingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background to black
      appBar: GeneralAppBar('Blocked Users'),
      body: BlocBuilder<SecurityCubit, SecurityState>(
        builder: (context, state) {
          if (state is BlockedUsersLoaded) {
            final blockedUsers = state.blockedUsers;

            return Column(
              children: [
                Expanded(
                  child: blockedUsers.isNotEmpty
                      ? ListView.builder(
                          itemCount: blockedUsers.length,
                          itemBuilder: (context, index) {
                            final user = blockedUsers[index];
                            return ListTile(
                              tileColor: appBarDarkMoodColor, // Set tile background to white
                              title: Text(
                                user.name,
                                style: TextStyle(color: tileInfoHintColor), // Text color black for contrast
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.lock_open, color: Colors.green),
                                onPressed: () {
                                  context.read<SecurityCubit>().removeBlockedUser(user.id);
                                },
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'No users blocked yet.',
                            style: TextStyle(color: tileInfoHintColor), // Text color white for contrast
                          ),
                        ),
                ),
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.person_add,
                    size: 24.0,
                    color: tileInfoHintColor,
                  ),
                  label: Text('Add User to Block List'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactsPage()),
                    );
                  },
                ),
              ],
            );
          } else if (state is SecurityError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Colors.white), // Text color white for error message
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
