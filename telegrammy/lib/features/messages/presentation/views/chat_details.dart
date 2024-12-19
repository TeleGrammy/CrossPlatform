import 'package:flutter/material.dart';
import 'package:telegrammy/cores/services/channel_socket.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/presentation/widgets/bottom_bar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/chat_appbar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/chat_details_body.dart';
import 'package:telegrammy/features/messages/presentation/widgets/reply_preview.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_appbar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_bottom_bar.dart';

class ChatDetails extends StatefulWidget {
  final String lastSeen;
  final Message? forwardedMessage;
  final String userId;
  final String userRole;
  final ChatData chatData;

  const ChatDetails({
    Key? key,
    required this.chatData,
    this.forwardedMessage,
    required this.lastSeen,
    required this.userRole,
    required this.userId,
  }) : super(key: key);

  @override
  State<ChatDetails> createState() => ChatDetailsState();
}

class ChatDetailsState extends State<ChatDetails> {
  Message? selectedMessage;
  Message? repliedMessage;
  Message? editedMessage;
  late List<Participant> participants;
  @override
  void initState() {
    super.initState();

    getit.get<SocketService>().connect();
    if (widget.chatData.chat.isChannel) {
      getit.get<ChannelSocketService>().connect();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.forwardedMessage != null) {
        getit.get<SocketService>().sendMessage(
          'message:send',
          {
            'messageId': widget.forwardedMessage!.id,
            'chatId': widget.chatData.chat.id,
            'isForwarded': true
          },
        );
      }
    });
  }

  void onMessageTap(Message message) {
    setState(() {
      selectedMessage = message;
    });
  }

  void onMessageSwipe(Message message) {
    setState(() {
      repliedMessage = message;
    });
  }

  void clearReply() {
    setState(() {
      repliedMessage = null;
    });
  }

  void onClickEdit() {
    setState(() {
      editedMessage = selectedMessage;
      repliedMessage = selectedMessage!.replyOn;
      selectedMessage = null;
    });
  }

  void onClickDelete() {
    getit.get<SocketService>().deleteMessage(
      'message:delete',
      {'messageId': selectedMessage!.id},
    );
    setState(() {
      selectedMessage = null;
    });
  }

  void onReply() {
    onMessageSwipe(selectedMessage!);
    setState(() {
      selectedMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() {
            selectedMessage = null;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: selectedMessage == null
            ? ChatAppbar(
                key: const Key('chatAppBar'),
                lastSeen: widget.lastSeen,
                userRole: widget.userRole,
                chat: widget.chatData.chat,
              )
            : SelectedMessageAppbar(
                key: const Key('selectedMessageAppBar'),
                onMessageUnTap: () {
                  setState(() => selectedMessage = null);
                },
                onClickEdit: onClickEdit,
                onClickDelete: onClickDelete,
              ),
        body: Column(
          children: [
            Expanded(
              child: ChatDetailsBody(
                  key: const Key('chatDetailsBody'),
                  messages: widget.chatData.messages,
                  onMessageTap: onMessageTap,
                  onMessageSwipe: onMessageSwipe,
                  selectedMessage: selectedMessage,
                  userId: widget.userId),
            ),
            if (repliedMessage != null)
              Padding(
                key: const Key('replyPreview'),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ReplyPreview(
                  repliedMessage: repliedMessage!,
                  onCancel: clearReply,
                ),
              ),
            selectedMessage == null
                ? BottomBar(
                    key: const Key('bottomBar'),
                    clearReply: clearReply,
                    editedMessage: editedMessage,
                    repliedMessage: repliedMessage,
                    chatId: widget.chatData.chat.id,
                    isChannel: widget.chatData.chat.isChannel,
                  )
                : SelectedMessageBottomBar(
                    key: const Key('selectedMessageBottomBar'),
                    onReply: () {
                      onReply();
                    },
                    selectedMessage: selectedMessage!,
                  ),
          ],
        ),
      ),
    );
  }
}
