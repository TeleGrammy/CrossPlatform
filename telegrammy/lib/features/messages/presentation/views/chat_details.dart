import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/routes/app_routes.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/presentation/data/messages.dart';
import 'package:telegrammy/features/messages/presentation/view_models/messages_cubit/messages_cubit.dart';
import 'package:telegrammy/features/messages/presentation/widgets/bottom_bar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/chat_appbar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/chat_details_body.dart';
import 'package:telegrammy/features/messages/presentation/widgets/reply_preview.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_appbar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_bottom_bar.dart';

class ChatDetails extends StatefulWidget {
  final String name;
  final String id;
  final String photo;
  final String lastSeen;
  final List<Message> messages;
  final Message? forwardedMessage;
  const ChatDetails(
      {Key? key,
      required this.name,
      required this.id,
      required this.photo,
      required this.lastSeen,
      required this.messages,
      this.forwardedMessage})
      : super(key: key); // Key for ChatDetails widget

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
    // loadChatData();

    getit.get<SocketService>().connect();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.forwardedMessage != null) {
        getit.get<SocketService>().sendMessage(
          'message:send',
          {
            'messageId': widget.forwardedMessage!.id,
            'chatId': widget.id,
            'isForwarded': true
          },
        );
      }
    });

    // socketService.connect();
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

  // void onSendAudio(Message message) {
  //   setState(() {
  //     messages.add(message);
  //   });
  // }

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
    // setState(() {
    //   messages.add(Message(
    //     text: "message has been deleted",
    //     time: DateTime.now().toString(),
    //     isSentByUser: true,
    //     repliedTo: null,
    //   )
    //   );
    // clearReply();
    // });
  }

  // void onSend(String text) {
  //   if (text.trim().isNotEmpty) {
  //     getit.get<SocketService>().sendMessage(
  //       'message:send',
  //       {'content': text, 'chatId': widget.id, 'messageType': 'text'},
  //     );
  //     // socketService.sendMessage('event', "data");
  //     // setState(() {
  //     //   messages.add(Message(
  //     //     text: text,
  //     //     time: DateTime.now().toString(),
  //     //     isSentByUser: true,
  //     //     repliedTo: repliedMessage,
  //     //   ));
  //     // }
  //     // );
  //   }
  // }

  // void onEdit(Message message, String editedString) {
  //   if (editedString.trim().isNotEmpty) {
  //     final index = messages.indexOf(message);
  //     setState(() {
  //       messages[index] = Message(
  //         text: editedString,
  //         time: DateTime.now().toString(),
  //         isSentByUser: true,
  //         repliedTo: message.repliedTo,
  //       );
  //     });
  //   }
  // }

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
                key: const Key('chatAppBar'), // Key for ChatAppbar
                name: widget.name,
                photo: widget.photo,
                lastSeen: widget.lastSeen)
            : SelectedMessageAppbar(
                key: const Key(
                    'selectedMessageAppBar'), // Key for SelectedMessageAppbar
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
                  messages: widget.messages,
                  onMessageTap: onMessageTap,
                  onMessageSwipe: onMessageSwipe,
                  selectedMessage: selectedMessage,
                  userId: widget.id),
            ),
            if (repliedMessage != null)
              Padding(
                key: const Key('replyPreview'), // Key for ReplyPreview
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ReplyPreview(
                  repliedMessage: repliedMessage!,
                  onCancel: clearReply,
                ),
              ),
            selectedMessage == null
                ? BottomBar(
                    key: const Key('bottomBar'), // Key for BottomBar
                    // onSend: onSend,
                    // onSendAudio: onSendAudio,
                    // onEdit: onEdit,
                    clearReply: clearReply,
                    editedMessage: editedMessage,
                    repliedMessage: repliedMessage,
                    chatId: widget.id,
                  )
                : SelectedMessageBottomBar(
                    key: const Key(
                        'selectedMessageBottomBar'), // Key for SelectedMessageBottomBar
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
