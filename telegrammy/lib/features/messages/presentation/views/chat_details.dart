import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
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
  final String userId;
  final List<Participant> participants;

  const ChatDetails({
    Key? key,
    required this.name,
    required this.id,
    required this.photo,
    required this.lastSeen,
    required this.messages,
    this.forwardedMessage,
    required this.userId,
    required this.participants,
  }) : super(key: key);

  @override
  State<ChatDetails> createState() => ChatDetailsState();
}

class ChatDetailsState extends State<ChatDetails> {
  Message? selectedMessage;
  Message? repliedMessage;
  Message? editedMessage;
  bool isSocketInitialized = false; // Tracks whether the socket is ready

  @override
  void initState() {
    super.initState();
    _initializeSocketConnection();
  }

  @override
  void dispose() {
    super.dispose();
    getit.get<SocketService>().removeCallListener('call:incomingCall');
    // getit.get<SocketService>().disconnect();
  }

  Future<void> _initializeSocketConnection() async {
    await getit.get<SocketService>().connect();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.forwardedMessage != null) {
        getit.get<SocketService>().sendMessage(
          'message:send',
          {
            'messageId': widget.forwardedMessage!.id,
            'chatId': widget.id,
            'isForwarded': true,
          },
        );
      }

      getit.get<SocketService>().recieveCall('call:incomingCall', (response) {
        if(mounted) {
          context.goNamed(RouteNames.incomingCall, extra: {
            'name': 'mmmomo',
            'photo': 'default.png',
            'callId': response['_id'],
            'remoteOffer': response['callObj']['offer'],
            'chatId': widget.id,
            'lastSeen': widget.lastSeen,
            'userId': widget.userId,
          });
        }
      });
      setState(() {
        isSocketInitialized = true; // Mark socket as initialized
      });
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
      repliedMessage = selectedMessage?.replyOn;
      selectedMessage = null;
    });
  }

  void onClickDelete() {
    if (selectedMessage != null) {
      getit.get<SocketService>().deleteMessage(
        'message:delete',
        {'messageId': selectedMessage!.id},
      );
      setState(() {
        selectedMessage = null;
      });
    }
  }

  void onReply() {
    if (selectedMessage != null) {
      onMessageSwipe(selectedMessage!);
      setState(() {
        selectedMessage = null;
      });
    }
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
      child: isSocketInitialized
          ? Scaffold(
              backgroundColor: Colors.white,
              appBar: selectedMessage == null
                  ? ChatAppbar(
                      key: const Key('chatAppBar'),
                      name: widget.name,
                      photo: widget.photo,
                      lastSeen: widget.lastSeen,
                      id: widget.id,
                      userId: widget.userId,
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
                      messages: widget.messages,
                      onMessageTap: onMessageTap,
                      onMessageSwipe: onMessageSwipe,
                      selectedMessage: selectedMessage,
                      userId: widget.userId,
                      participants: widget.participants,
                    ),
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
                          chatId: widget.id,
                        )
                      : SelectedMessageBottomBar(
                          key: const Key('selectedMessageBottomBar'),
                          onReply: onReply,
                          selectedMessage: selectedMessage!,
                        ),
                ],
              ),
            )
          : const Scaffold(
              body: Center(
                child: CircularProgressIndicator(), // Loading indicator
              ),
            ),
    );
  }
}
