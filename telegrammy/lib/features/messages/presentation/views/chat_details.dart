import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/cores/services/channel_socket.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/presentation/widgets/bottom_bar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/chat_appbar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/chat_details_body.dart';
import 'package:telegrammy/features/messages/presentation/widgets/pinned_message_bar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/reply_preview.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_appbar.dart';
import 'package:telegrammy/features/messages/presentation/widgets/selected_message_bottom_bar.dart';

class ChatDetails extends StatefulWidget {
  final Message? forwardedMessage;
  final String userId;
  // final List<Participant> participants;
  final String userRole;
  final ChatData chatData;
  final List<Participant> participants;
  // final List<Message> messages;
  // final String name;
  // final String id;
  // final String photo;

  const ChatDetails({
    Key? key,
    required this.participants,
    // required this.name,
    // required this.id,
    // required this.photo,
    // required this.lastSeen,
    // required this.messages,
    this.forwardedMessage,
    required this.userId,
        required this.chatData,
    required this.userRole,
  }) : super(key: key);

  @override
  State<ChatDetails> createState() => ChatDetailsState();
}

class ChatDetailsState extends State<ChatDetails> {
  Message? selectedMessage;
  Message? repliedMessage;
  Message? editedMessage;
  Message? lastPinnedMessage;
  Message? SearchedMessage;
  late List<Participant> participants;
  bool isPinned = false;
  final ScrollController _scrollController = ScrollController();
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
            'chat':widget.chatData.chat,
            'userId': widget.userId,
          });
        }
      });
      setState(() {
        isSocketInitialized = true; // Mark socket as initialized
      });
    });
  }

  bool checkPinning() {
    if (lastPinnedMessage != null) {
      if (selectedMessage?.id == lastPinnedMessage?.id) {
        return true;
      } else {
        return false;
      }
    }

    return false;
  }

  void onMessageTap(Message message) {
    // print(message.isPinned);
    setState(() {
      selectedMessage = message;

      isPinned = checkPinning();
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

  void onClickPin() {
    // print(selectedMessage!.content);
    getit.get<SocketService>().pinMessage(
      'message:pin',
      {'messageId': selectedMessage!.id, 'chatId': widget.chatData.chat.id},
    );

// comming from server
    getit.get<SocketService>().pinMessagerecived('message:pin', (data) {
      if (data != null && data['isPinned'] == true) {
        // Find the message by its ID and replace replyOn with the message object
        print(data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Message pinned: ${lastPinnedMessage?.content ?? ''}"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });

    setState(() {
      lastPinnedMessage = selectedMessage;
      selectedMessage = null;
    });
  }

  void goToPinnedMessage() {
    if (lastPinnedMessage != null) {
      final index = widget.chatData.messages
          .indexWhere((msg) => msg.id == lastPinnedMessage!.id);
      // print(lastPinnedMessage?.content);
      // print(index);

      if (index != -1) {
        final messagePosition = index * 72.0; // Approximate height per message
        // _scrollController.animateTo(
        //   messagePosition,
        //   duration: Duration(milliseconds: 4300),
        //   curve: Curves.easeInOut,
        // );
        print("salmmma");
      } else {
        print('Message not found in the list.');
      }
    }
  }

  void onClickUnpin() {
    getit.get<SocketService>().unpinMessage(
      'message:unpin',
      {'messageId': selectedMessage!.id, 'chatId': widget.chatData.chat.id},
    );

    getit.get<SocketService>().unpinMessagerecived('message:unpin', (data) {
      if (data != null && data['isPinned'] == false) {
        // Find the message by its ID and replace replyOn with the message object
        //  print(data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Message unpinned: ${data['content'] ?? ''}"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
    setState(() {
      lastPinnedMessage = null;
      selectedMessage = null;
    });
  }

  void createDraft(String draftContent) {
    getit.get<SocketService>().draftMessage(
      'draft',
      {'chatId': widget.chatData.chat.id},
    );

    getit.get<SocketService>().draftMessagerecived('draft', (data) {
      if (data != null) {
        // Find the message by its ID and replace replyOn with the message object
        //  print(data);
        //    ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("Message unpinned: ${data['content']?? ''}"),
        //     duration: const Duration(seconds: 2),
        //   ),
        // );
      }
    });
    setState(() {
      // lastPinnedMessage=null;
      // selectedMessage = null;
    });
  }

  void onReply() {
    if (selectedMessage != null) {
      onMessageSwipe(selectedMessage!);
      setState(() {
        selectedMessage = null;
      });
    }
  }

  void onPin() {
    // onMessageSwipe(selectedMessage!);
    // setState(() {
    //   selectedMessage = null;
    // });
    print('salma');
  }

  void onSearch() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<Message> filteredMessages = [];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Search Messages"),
              content: SizedBox(
                width: double
                    .maxFinite, // Ensures the dialog adapts to content size
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search Input Field
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: "Search",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            setState(() {
                              filteredMessages = [];
                            });
                          },
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredMessages = widget.chatData.messages
                              .where((message) =>
                                  RegExp(value, caseSensitive: false)
                                      .hasMatch(message.content))
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Scrollable List of Filtered Messages
                    filteredMessages.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredMessages.length,
                              itemBuilder: (context, index) {
                                final message = filteredMessages[index];
                                return ListTile(
                                  title: Text(message.content),
                                  onTap: () {
                                    setState(() {
                                      SearchedMessage = message;
                                      print(SearchedMessage!.content);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                          )
                        : const Text("No results found."),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
                ),
              ],
            );
          },
        );
      },
    );
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
                      lastSeen: widget.chatData.chat.lastSeen!,
                      userRole: widget.userRole,
                      userId: widget.userId,
                      
                      chat: widget.chatData.chat,
                      onSearch: onSearch,
                      name: widget.chatData.chat.name,
                      photo: widget.chatData.chat.photo ?? 'default.jpg',
                      id: widget.chatData.chat.id,
                    )
                  : SelectedMessageAppbar(
                      key: const Key('selectedMessageAppBar'),
                      onMessageUnTap: () {
                        setState(() => selectedMessage = null);
                      },
                      onClickEdit: onClickEdit,
                      onClickDelete: onClickDelete,
                      onClickPin: onClickPin,
                      onClickUnpin: onClickUnpin,
                      isPinned: isPinned,
                    ),
              body: Column(
                children: [
                  // Show pinned message bar if a message is pinned

                  Expanded(
                    child: ChatDetailsBody(
                      key: const Key('chatDetailsBody'),
                      messages: widget.chatData.messages,
                      onMessageTap: onMessageTap,
                      onMessageSwipe: onMessageSwipe,
                      selectedMessage: selectedMessage,
                      userId: widget.userId,
                      participants: participants,
                      searchedMessage: SearchedMessage,
                      havePin: lastPinnedMessage != null,
                      lastPinnedMessage: lastPinnedMessage,
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
            )
          : const Scaffold(
              body: Center(
                child: CircularProgressIndicator(), // Loading indicator
              ),
            ),
    );
  }
}
