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

class ChatsScreen extends StatefulWidget {
  final Message? forwardMessage;
  const ChatsScreen({Key? key, this.forwardMessage}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  initState() {
    super.initState();
    // _initializeSocketConnection();
  }

  // Future<void> _initializeSocketConnection() async {
  //   await getit.get<SocketService>().connect();

  //   getit.get<SocketService>().recieveCall('call:incomingCall', (response) {
  //     print(response);
  //     context.goNamed(RouteNames.incomingCall, extra: {
  //       'name': 'mmmomo',
  //       'photo': 'default.png',
  //       'callId': response['_id'],
  //       'remoteOffer': response['callObj']['offer'],
  //       // 'chatId': widget.id,
  //       'chatId': response['chatId']['_id'],
  //     });
  //   });
  // }

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

                final name = chat.name;
                final photo = chat.photo ?? 'default.jpg';
                // final draftMessage = '';
                final lastMessage = chat.lastMessage?.content ?? '';
                final String id = chat.id;
                final lastMessageTime =
                    chat.lastMessage?.timestamp.toString() ?? '';
                final String? draftMessage = chat.draftMessage;
                final String lastSeen = chat.lastSeen ?? '';
                // print(id);
                // final name = participant.userId['screenName'] ?? 'Unknown';
                // final photo = participant.userId['picture'] ?? 'default.jpg';
                // final draftMessage = participant['draft_message'] ?? '';

                return ContactPreview(
                  key: Key('contactItem_$index'),
                  id: id,
                  name: name,
                  photo: photo,
                  lastMessage: lastMessage,
                  lastMessageTime: lastMessageTime,
                  forwardMessage: widget.forwardMessage,
                  draftMessage: draftMessage,
                  userId: userId,
                  lastSeen: lastSeen,
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
