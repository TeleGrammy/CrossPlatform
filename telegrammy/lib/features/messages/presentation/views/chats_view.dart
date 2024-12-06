import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/features/messages/presentation/view_models/contacts_cubit/contacts_cubit.dart';
import 'package:telegrammy/features/messages/presentation/widgets/contact_preview.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_bottom_bar.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

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
            icon: const Icon(Icons.add_circle_rounded),
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
              key: ValueKey('loading_contacts'),
            ));
          } else if (state is ContactsSuccess) {
            final chats = state.chats;
            // final userId=result['userId'];
            // final userId = state.userId; // Current user's ID

            return ListView.builder(
              key: const Key('contactsList'),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];

                // Get the participant whose ID is not equal to the current user's ID
                // final participant = chat.participants.firstWhere(
                //   (p) => p.userId['_id'] != userId,
                // );

                final name = 'Unknown';
                final photo = 'default.jpg';
                final draftMessage = '';
                final id='';
                final lastSeen='';
                // final name = participant.userId['screenName'] ?? 'Unknown';
                // final photo = participant.userId['picture'] ?? 'default.jpg';
                // final draftMessage = participant['draft_message'] ?? '';

                return ContactPreview(
                  key: Key('contactItem_$index'),
                  id:id,
                  name: name,
                  photo: photo,
                  draftMessage: draftMessage,
                  lastSeen:lastSeen
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
