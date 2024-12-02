import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
import 'package:telegrammy/features/messages/presentation/view_models/contacts_cubit/contacts_cubit.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_bottom_bar.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({Key? key}) : super(key: key); // Add a key to the ContactsScreen widget

  @override
  Widget build(BuildContext context) {
    context.read<ContactsCubit>().getContacts();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            
          },
          icon: Icon(Icons.person),
        ),
        title: Text('Contacts'),
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoading) {
            return const Center(child: CircularProgressIndicator(key: ValueKey('loading_contancts'),));
          } else if (state is ContactsSuccess) {
            final contacts = state.contacts;
            return ListView.builder(
              key: const Key('contactsList'), // Add a key to the ListView
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                final participantNames =
                    contact.participants.map((p) => p.user.username).join(', ');

                return ContactItem(
                  key: Key('contactItem_$index'), // Unique key for each ContactItem
                  title: contact.isGroup
                      ? 'Group: $participantNames'
                      : participantNames,
                  subtitle: 'Created At: ${contact.createdAt}',
                );
              },
            );
          } else if (state is ContactsFailture) {
            return const Center(key: ValueKey('Contacts_error'),child: Text('Failed to load contacts'));
          } else {
            return const Center(key: ValueKey('Contacts_initial'),child: Text('No contacts available'));
          }
        },
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const ContactItem({
    Key? key, // Add key to the ContactItem widget
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('contactItemTile_$title'), // Key for the ListTile
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      onTap: () {
        context.goNamed(
          RouteNames.oneToOneMessaging,
          extra: title, // Pass participant names as extra
        );
      },
    );
  }
}
