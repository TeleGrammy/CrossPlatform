import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/presentation/view_models/contacts_cubit/contacts_cubit.dart';
import 'package:telegrammy/features/messages/presentation/widgets/contact_preview.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_bottom_bar.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';

import '../../../../cores/services/groups_socket.dart';
import '../../../../cores/services/service_locator.dart';

class ChatsScreen extends StatefulWidget {
  final Message? forwardMessage;
  const ChatsScreen({Key? key, this.forwardMessage}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    super.initState();
    getit.get<GroupSocketService>().connectToGroupServer();
  }

  @override
  void dispose() {
    //getit.get<GroupSocketService>().disconnectGroups();
    super.dispose();
  }

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
      } else
        context.goNamed(RouteNames.addContact);
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
          IconButton(
            key: const ValueKey('GlobalSearchButton'),
            icon: Icon(Icons.search),
            onPressed: () {
              context.goNamed(RouteNames.globalSearch);
            },
          ),
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
            final chats = state.chats['chats'] as List<ChatView>;
            final userId = state.chats['userId'] as String;
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
                final lastMessageTime =
                    chat.lastMessage?.timestamp.toString() ?? '';
                final String? draftMessage = chat.draftMessage;
                // print(id);
                // final name = participant.userId['screenName'] ?? 'Unknown';
                // final photo = participant.userId['picture'] ?? 'default.jpg';
                // final draftMessage = participant['draft_message'] ?? '';

                return ContactPreview(
                  key: Key('contactItem_$index'),
                  chat: chat,
                  forwardMessage: widget.forwardMessage,
                  draftMessage: draftMessage,
                  userId: userId,
                  lastMessageTime: lastMessageTime,
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
