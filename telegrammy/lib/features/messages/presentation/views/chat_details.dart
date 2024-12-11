import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';
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
  const ChatDetails(
      {Key? key,
      required this.name,
      required this.id,
      required this.photo,
      required this.lastSeen})
      : super(key: key); // Key for ChatDetails widget

  @override
  State<ChatDetails> createState() => ChatDetailsState();
}

class ChatDetailsState extends State<ChatDetails> {
  Message? selectedMessage;
  Message? repliedMessage;
  Message? editedMessage;

  @override
  void initState() {
    super.initState();
    getit.get<SocketService>().connect();
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
      editedMessage = null;
    });
  }

  Future<void> onSendAudio(String filePath) async {
    dynamic data = await context.read<MessagesCubit>().sendAudio(filePath);
    if (data != null) {
      setState(() {
        messages.add(Message(
            isSentByUser: true,
            messageType: 'audio',
            text: '',
            time: DateTime.now().toString(),
            attachmentKey: data['mediaKey'],
            attachmentUrl: data['signedUrl']));
      });
    }
  }

  void onClickEdit() {
    setState(() {
      editedMessage = selectedMessage;
      repliedMessage = selectedMessage!.repliedTo;
      selectedMessage = null;
    });
  }

  void onClickDelete() {
    setState(() {
      messages.add(Message(
        text: "message has been deleted",
        time: DateTime.now().toString(),
        isSentByUser: true,
        repliedTo: null,
        messageType: '',
      ));
      clearReply();
    });
  }

  void onSend(String text, XFile? media) async {
    if (text.trim().isNotEmpty || media != null) {
      getit.get<SocketService>().sendMessage('event', 'data');

      dynamic fileData;
      if (media != null) {
        fileData = await context.read<MessagesCubit>().sendMedia(media);
      }

      setState(() {
        messages.add(Message(
          text: text,
          time: DateTime.now().toString(),
          isSentByUser: true,
          repliedTo: repliedMessage,
          attachmentKey: fileData['mediaKey'],
          attachmentUrl: fileData['signedUrl'],
          messageType: (fileData != null) ? 'image' : 'text',
        ));
      });
    }
  }

  void onEdit(Message message, String editedString) {
    if (editedString.trim().isNotEmpty) {
      final index = messages.indexOf(message);
      setState(() {
        messages[index] = Message(
          text: editedString,
          time: DateTime.now().toString(),
          isSentByUser: true,
          repliedTo: message.repliedTo,
          messageType: message.messageType,
        );
      });
    }
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
                key: const Key('chatDetailsBody'), // Key for ChatDetailsBody
                onMessageTap: onMessageTap,
                onMessageSwipe: onMessageSwipe,
                selectedMessage: selectedMessage,
              ),
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
                    onSend: onSend,
                    onSendAudio: onSendAudio,
                    onEdit: onEdit,
                    editedMessage: editedMessage,
                  )
                : SelectedMessageBottomBar(
                    key: const Key(
                        'selectedMessageBottomBar'), // Key for SelectedMessageBottomBar
                    onReply: () {
                      onReply();
                    }),
          ],
        ),
      ),
    );
  }
}
