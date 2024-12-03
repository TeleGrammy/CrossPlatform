import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/features/messages/presentation/view_models/contacts_cubit/contacts_cubit.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_bottom_bar.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({Key? key})
      : super(key: key); // Add a key to the ContactsScreen widget

  @override
  Widget build(BuildContext context) {
    context.read<ContactsCubit>().getContacts();

    final List<String> addListOptions = [
      'New Chat',
      'New Group',
      'New Channel'
    ];
    void onDropdownItemSelected(String value) {
      print('Selected: $value');

      if (value == 'New Group') {
        context.goNamed(RouteNames.createGroup);
      } else if (value == 'New Channel') {
        context.goNamed(RouteNames.createChannel);
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.goNamed(RouteNames.profileInfo);
          },
          icon: Icon(Icons.person),
        ),
        title: Text('Chats'),
        backgroundColor: primaryColor,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
                Icons.add_circle_rounded), // IconButton with dropdown
            onSelected: onDropdownItemSelected,
            itemBuilder: (BuildContext context) {
              return addListOptions.map((String option) {
                return PopupMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoading) {
            return const Center(
                child: CircularProgressIndicator(
              key: ValueKey('loading_contancts'),
            ));
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
                  key: Key(
                      'contactItem_$index'), // Unique key for each ContactItem
                  title: contact.isGroup
                      ? 'Group: $participantNames'
                      : participantNames,
                  subtitle: 'Created At: ${contact.createdAt}',
                );
              },
            );
          } else if (state is ContactsFailture) {
            return const Center(
                key: ValueKey('Contacts_error'),
                child: Text('Failed to load contacts'));
          } else {
            return const Center(
                key: ValueKey('Contacts_initial'),
                child: Text('No contacts available'));
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
