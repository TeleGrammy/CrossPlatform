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
import 'package:telegrammy/features/messages/presentation/widgets/pinned_message_bar.dart';
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
  Message? lastPinnedMessage;
  late List<Participant> participants;
  bool isPinned=false;
  final ScrollController _scrollController = ScrollController(); // Scroll controller for chat
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
  bool checkPinning(){
     print('1');
    if( lastPinnedMessage !=null){
      print('1');
      if(selectedMessage?.id ==lastPinnedMessage?.id)
      {
        print('2');
        return true;
      }
      else{
        print('3');
        return false;
      }
    }
    print('4');
     return false;
  }
  void onMessageTap(Message message) {
    setState(() {
      selectedMessage = message;
      // print(message.content);
      isPinned=checkPinning() ;

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
    void onClickPin() {
      // print(selectedMessage!.content);
    getit.get<SocketService>().pinMessage(
      'message:pin',
      {'messageId': selectedMessage!.id,'chatId':widget.id},
    );

// comming from server 
 getit.get<SocketService>().pinMessagerecived('message:pin', (data) {
      if (data!= null && data['isPinned']==true) {
        // Find the message by its ID and replace replyOn with the message object
      //  print(data);
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Message pinned: ${lastPinnedMessage?.content ?? ''}"),
        duration: const Duration(seconds: 2),
      ),
    );
      }

     
    });


    setState(() {
        // print('insides2');
      lastPinnedMessage=selectedMessage;
      selectedMessage = null;

    });

   
    }
void goToPinnedMessage() {
  if (lastPinnedMessage != null) {
    final index = widget.messages.indexWhere((msg) => msg.id == lastPinnedMessage!.id);
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
      {'messageId': selectedMessage!.id,'chatId':widget.id},
    );

     getit.get<SocketService>().unpinMessagerecived('message:unpin', (data) {
      if (data!= null && data['isPinned']==false) {
        // Find the message by its ID and replace replyOn with the message object
      //  print(data);
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Message unpinned: ${data['content']?? ''}"),
        duration: const Duration(seconds: 2),
      ),
    );
      }

     
    });
    setState(() {
      lastPinnedMessage=null;
      selectedMessage = null;

    });

   
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
    void onPin() {
    // onMessageSwipe(selectedMessage!);
    // setState(() {
    //   selectedMessage = null;
    // });
    print('salma');
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
                 onClickPin: onClickPin,
                 onClickUnpin: onClickUnpin,
                 isPinned: isPinned,
              ),
        body: Column(
          children: [
                   // Show pinned message bar if a message is pinned
        if (lastPinnedMessage != null)
          PinnedMessageBar(
            pinnedMessage: lastPinnedMessage!,
            onTap: goToPinnedMessage,
          ),
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
