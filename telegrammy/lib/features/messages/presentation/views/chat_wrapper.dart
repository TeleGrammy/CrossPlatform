import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/routes/app_routes.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/presentation/data/messages.dart';
import 'package:telegrammy/features/messages/presentation/view_models/messages_cubit/messages_cubit.dart';
import 'package:telegrammy/features/messages/presentation/views/chat_details.dart';
import 'package:telegrammy/features/messages/presentation/widgets/bottom_bar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/chat_appbar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/chat_details_body.dart';
import 'package:telegrammy/features/messages/presentation/widgets/reply_preview.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_appbar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_bottom_bar.dart';

class ChatWrapper extends StatefulWidget {
  final String name;
  final String id;
  final String photo;
  final String lastSeen;
  const ChatWrapper({
    Key? key,
    required this.name,
    required this.id,
    required this.photo,
    required this.lastSeen,
  }) : super(key: key); // Key for ChatDetails widget

  @override
  State<ChatWrapper> createState() => ChatWrapperState();
}

class ChatWrapperState extends State<ChatWrapper> {
  @override
  void initState() {
    super.initState();
    // loadChatData();
    // getit.get<SocketService>().connect();

    // socketService.connect();
  }

  @override
  Widget build(BuildContext context) {
    context.read<MessagesCubit>().fetchMessages(chatId: widget.id);
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        if (state is MessagesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is Messagesfailture) {
          return Center(
              child: TextButton(
            onPressed: () =>
                context.read<MessagesCubit>().fetchMessages(chatId: widget.id),
            child: const Text('Retry'),
          ));
        } else if (state is MessagesSuccess) {
          List<Participant> participants =
              state.chatData['participants'] as List<Participant>;
          List<Message> messages = state.chatData['messages'] as List<Message>;
          return ChatDetails(
            name: widget.name,
            id: widget.id,
            photo: widget.photo,
            lastSeen: widget.lastSeen,
            messages: messages,
          );
        } else {
          return Center(
            child: Text('no messages'),
          );
        }
      },
    );
  }
}
