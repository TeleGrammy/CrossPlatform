import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/presentation/view_models/messages_cubit/messages_cubit.dart';
import 'package:telegrammy/features/messages/presentation/views/chat_details.dart';

class ChatWrapper extends StatefulWidget {
  final Message? forwardedMessage;
  final String userId;
    final ChatView chat;
  const ChatWrapper(
      {required this.userId,
      Key? key,
      this.forwardedMessage,
      required this.chat,
      })
      : super(key: key); // Key for ChatDetails widget

  @override
  State<ChatWrapper> createState() => ChatWrapperState();
}

class ChatWrapperState extends State<ChatWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<MessagesCubit>().fetchMessages(chatId: widget.chat.id);
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        if (state is MessagesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is Messagesfailture) {
          return Center(
              child: TextButton(
            onPressed: () => context
                .read<MessagesCubit>()
                .fetchMessages(chatId: widget.chat.id),
            child: const Text('Retry'),
          ));
        } else if (state is MessagesSuccess) {
          List<Participant> participants =
              state.chatData['participants'] as List<Participant>;
          // String userRole=participants.firstWhere((element) => element.id==userId).role;
          String userRole = 'Admin';
          List<Message> messages = state.chatData['messages'] as List<Message>;
          List<Message> reversedList = messages.reversed.toList();
          return ChatDetails(
            chatData: ChatData(
              chat: widget.chat,
              messages: reversedList,
            ),
            forwardedMessage: widget.forwardedMessage,
            participants: participants,
            userId: widget.userId,
            userRole: userRole,
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
