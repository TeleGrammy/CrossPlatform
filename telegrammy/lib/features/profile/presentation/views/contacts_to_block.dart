import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/widgets/app_bar.dart';
import 'package:telegrammy/features/profile/data/repos/profile_repo.dart';
import 'package:telegrammy/features/profile/presentation/view_models/blocked_users_cubit/blocked_users_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/blocked_users_cubit/blocked_users_state.dart';
import 'package:telegrammy/features/profile/presentation/widgets/block_users_app_bar,.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    super.initState();
    // Load contacts when the widget is initialized
    context.read<ContactstoCubit>().loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlockAppBar(
        titleBar: 'Block User',
        key: const ValueKey('ContactsToBlockAppBar'),
      ),
      body: BlocBuilder<ContactstoCubit, ContactstoState>(
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
            // Filter out blocked contacts
            final contacts = state.contacts
                .where(
                    (contact) => contact.blockDetails.status == "not_blocked")
                .toList();

            return Column(
              children: [
                SizedBox(height: 30),
                Expanded(
                  key: const ValueKey('ContactsToBlock'),
                  child: contacts.isNotEmpty
                      ? ListView.builder(
                          itemCount: contacts.length,
                          itemBuilder: (context, index) {
                            final contact = contacts[index];
                            final isBlocked =
                                contact.blockDetails.status == "not_blocked";

                            return ListTile(
                              tileColor: primaryColor,
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/logo.png'),
                                radius: 20,
                              ),
                              title: Text(
                                contact.contactInfo.username,
                                style: TextStyle(color: tileInfoHintColor),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  isBlocked ? Icons.lock : Icons.block,
                                  color: isBlocked ? Colors.grey : Colors.red,
                                ),
                                onPressed: () async {
                                  await context
                                      .read<ContactstoCubit>()
                                      .blockUser(contact.contactInfo.id);

                                  // Ensure context is still valid before attempting to show the snackbar
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${contact.contactInfo.username} has been ${isBlocked ? 'unblocked' : 'blocked'}.'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        )
                      : Center(
                          key: const ValueKey('NoContactsToBlockText'),
                          child: Text(
                            'No contacts available.',
                            style: TextStyle(color: tileInfoHintColor),
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
