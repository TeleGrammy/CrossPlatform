import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telegrammy/cores/services/draft_storage_service.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';
import 'package:telegrammy/features/messages/data/models/media.dart';
import 'package:telegrammy/features/messages/data/repos/messages_repo_implementaion.dart';
import 'package:telegrammy/features/messages/presentation/data/messages.dart';
import 'package:telegrammy/features/messages/presentation/widgets/emoji_picker.dart';

class BottomBar extends StatefulWidget {
  // final void Function(String) onSend;
  // final void Function(Message, String) onEdit;
  // final void Function(Message) onSendAudio;
  final Message? editedMessage;
  final String chatId;
  final Message? repliedMessage;
  final Function() clearReply;
  const BottomBar(
      {super.key,
      // required this.onSend,
      // required this.onEdit,
      // required this.onSendAudio,
      required this.clearReply,
      this.repliedMessage,
      this.editedMessage,
      required this.chatId});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final TextEditingController _messageController = TextEditingController();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final _secureDraftService = SecureDraftStorageService();
  bool _isTyping = false;
  bool _isRecording = false;
  String? _recordPath;
  String? _draftContent;

  @override
  void initState() {
    super.initState();
    _initializeMessage();
    _initializeRecorder();
    print(widget.chatId);
    // Listen for draft messages

    // getit.get<SocketService>().draftMessagerecived('draft', (data) {
    //   print('salma11');
    //   if (data != null && data['chatId'] == widget.chatId) {
    //     print('salmmm$data');
    //     setState(() {
    //       _draftContent = data['draft'];
    //       _messageController.text = _draftContent ?? '';
    //     });
    //   }
    // });

    _messageController.addListener(() {
      setState(() {
        _isTyping = _messageController.text.isNotEmpty;
      });
    });
  }

  void createDraft(String draftContent) async {
    getit.get<SocketService>().draftMessage(
      'draft',
      {'chatId': widget.chatId, 'draft': draftContent},
    );
    await _secureDraftService.saveDraft(widget.chatId, draftContent);
    //  getit.get<SocketService>().draftMessagerecived('draft', (data) {
    //   print('salma');

    //   if (data != null && data['chatId'] == widget.chatId) {
    //     print('aa$data');
    //     setState(() {
    //       _draftContent = data['draft'];
    //       _messageController.text = _draftContent ?? '';
    //     });
    //   }
    // });
  }

  @override
  void didUpdateWidget(covariant BottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editedMessage != oldWidget.editedMessage) {
      _initializeMessage();
    }
  }

  void _initializeMessage() async {
    String? savedDraft = await _secureDraftService.loadDraft(widget.chatId);
    // if (savedDraft != null) {
    //   setState(() {
    //     _messageController.text = savedDraft;
    //     _isTyping = savedDraft.isNotEmpty;
    //   });
    // }
    if (widget.editedMessage != null) {
      _messageController.text = widget.editedMessage!.content;
      _isTyping = true;
    } else if (savedDraft != null) {
      _messageController.text = savedDraft;
      _draftContent = savedDraft;

      _isTyping = true;
    } else {
      _messageController.clear();
      _isTyping = false;
    }
  }

  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception('Microphone permission not granted');
    }
    await _recorder.openRecorder();
  }

  Future<void> _startRecording() async {
    final _recorderePath = 'audio_${DateTime.now().millisecondsSinceEpoch}.aac';
    setState(() {
      _isRecording = true;
    });
    await _recorder.startRecorder(toFile: _recorderePath);
  }

  Future<Media> uploadAudio() async {
    return await getit
        .get<MessagesRepoImplementaion>()
        .uploadMedia(_recordPath);
  }

  Future<void> onSendAudio() async {
    Media media = await uploadAudio();
    print(media.mediaKey);
    print(media.mediaUrl);
    getit.get<SocketService>().sendMessage(
      'message:send',
      {
        'mediaUrl': media.mediaUrl,
        'chatId': widget.chatId,
        'messageType': 'audio',
        'mediaKey': media.mediaKey
      },
    );
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    if (_recordPath != null) {
      await onSendAudio();
    }
  }

  void _showEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return EmojiPicker(
          onEmojiSelected: (emoji) {
            setState(() {
              _messageController.text += emoji;
            });
            Navigator.pop(context); // Close the picker
          },
          onStickerSelected: (stickerPath) {
            print('Selected Sticker: $stickerPath');
            Navigator.pop(context); // Close the picker
          },
          onGifSelected: (gifPath) {
            print('Selected GIF: $gifPath');
            Navigator.pop(context); // Close the picker
          },
        );
      },
    );
  }

  void onSendText(String text) async {
    if (widget.editedMessage != null) {
      getit.get<SocketService>().editMessage('message:update',
          {'messageId': widget.editedMessage!.id, 'content': text});
    } else {
      if (text.trim().isNotEmpty) {
        await _secureDraftService.clearDraft(widget.chatId);
        getit.get<SocketService>().sendMessage(
          'message:send',
          {
            'content': text,
            'chatId': widget.chatId,
            'messageType': 'text',
            'replyOn': widget.repliedMessage?.id ?? null
          },
        );
      }
    }
    // _draftText = '';
    widget.clearReply();
  }

  @override
  void dispose() {
    if (_messageController.text.isNotEmpty) {
      createDraft(_messageController.text);
    }
    _messageController.dispose();
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Optional: Display a visual indicator for draft content
        if (_draftContent != null && !_isTyping)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            color: Colors.yellow[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Draft: "${_draftContent}"',
                  style: const TextStyle(
                      fontSize: 12, fontStyle: FontStyle.italic),
                ),
                IconButton(
                  icon: const Icon(Icons.clear, size: 16, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _draftContent = null;
                      _messageController.clear();
                    });
                  },
                ),
              ],
            ),
          ),
        // The main input row
        Row(
          key: const Key('bottom_bar_row'),
          children: [
            if (!_isRecording)
              IconButton(
                key: const Key('emoji_button'),
                icon: Icon(Icons.insert_emoticon),
                onPressed: () {
                  _showEmojiPicker(context);
                },
              ),
            if (_isRecording)
              IconButton(
                key: const Key('delete_recording_button'),
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _isRecording = false;
                    _recordPath = null;
                  });
                },
              ),
            Expanded(
              key: const Key('message_input_container'),
              child: _isRecording
                  ? Text(
                      'Recording...',
                      key: const Key('recording_status_text'),
                      style: const TextStyle(color: Colors.red),
                    )
                  : TextField(
                      key: const Key('message_input_field'),
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                      ),
                    ),
            ),
            IconButton(
              key: const Key('send_or_record_button'),
              icon: Icon(
                _isRecording
                    ? Icons.stop
                    : _isTyping
                        ? Icons.send
                        : Icons.mic,
                color: _isRecording ? Colors.red : null,
              ),
              onPressed: () async {
                if (_isRecording) {
                  await _stopRecording();
                } else if (_isTyping) {
                  onSendText(_messageController.text.trim());
                  setState(() {
                    _messageController.clear();
                    _draftContent = null; // Clear draft on send
                  });
                } else {
                  await _startRecording();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
