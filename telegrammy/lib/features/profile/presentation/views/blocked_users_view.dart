import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/widgets/app_bar.dart';
import 'package:telegrammy/features/profile/presentation/view_models/blocked_users_cubit/blocked_users_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/blocked_users_cubit/blocked_users_state.dart';
import 'package:telegrammy/features/profile/presentation/views/contacts_to_block.dart';

class BlockingPage extends StatefulWidget {
  @override
  _BlockingPageState createState() => _BlockingPageState();
}

class _BlockingPageState extends State<BlockingPage> {
  @override
  void initState() {
    super.initState();
    // Load blocked users when the widget is initialized
    context.read<BlockedUsersCubit>().loadBlockedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black, // Set background to black
      appBar: GeneralAppBar('Blocked Users'),
      body: BlocBuilder<BlockedUsersCubit, BlockedUsersState>(
        builder: (context, state) {
          if (state is BlockedUsersLoaded) {
            final blockedUsers = state.blockedUsers;

            return Column(
              children: [
                SizedBox(height: 30,),
                Expanded(
                  child: blockedUsers.isNotEmpty
                      ? ListView.builder(
                          itemCount: blockedUsers.length,
                          itemBuilder: (context, index) {
                            final user = blockedUsers[index];
                            return ListTile(
                              tileColor: primaryColor, // Tile background color
                              title: Text(
                                user.userName,
                                style: TextStyle(color: tileInfoHintColor), // Text color
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.lock_open, color: Colors.green),
                                onPressed: () {
                                  // context.read<BlockedUsersCubit>().removeBlockedUser(user.id);
                                  print('unbloced');
                                },
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'No users blocked yet.',
                            style: TextStyle(color: tileInfoHintColor), // Text color for contrast
                          ),
                        ),
                ),
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.person_add,
                    size: 24.0,
                    color: Colors.black,
                  ),
                  label: Text(
                    'Add User to Block List',
                    style: TextStyle(color: appBarDarkMoodColor), // Button text color
                  ),
                  onPressed: () {
                  context.pushNamed(RouteNames.ContactsToBlockFromView);
                    print('contacts');
                  },
                ),
                SizedBox(height: 30)
              ],
            );
          } else if (state is BlockedUsersError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Colors.white), // Error message text color
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
