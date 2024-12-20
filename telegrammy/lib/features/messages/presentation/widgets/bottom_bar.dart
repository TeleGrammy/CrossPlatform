import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telegrammy/cores/services/draft_storage_service.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';
import 'package:telegrammy/features/messages/data/models/media.dart';
import 'package:telegrammy/features/messages/presentation/view_models/messages_cubit/messages_cubit.dart';
import 'package:telegrammy/features/messages/presentation/widgets/emoji_picker.dart';
import 'package:telegrammy/features/messages/presentation/widgets/media_picker.dart';
import 'package:path_provider/path_provider.dart';

class BottomBar extends StatefulWidget {
  final Message? editedMessage;
  final String chatId;
  final Message? repliedMessage;
  final Function() clearReply;
  final bool isChannel;
  const BottomBar({
    super.key,
    required this.clearReply,
    this.repliedMessage,
    this.editedMessage,
    required this.chatId,
    required this.isChannel,
  });

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
  dynamic mediaMessage;
  String? _draftContent;

  @override
  void initState() {
    super.initState();
    _initializeMessage();
    _initializeRecorder();
    print(widget.chatId);
  // ## Listen for draft messages

    getit.get<SocketService>().draftMessagerecived('draft', (data) {
      print('salma11');
      if (data != null && data['chatId'] == widget.chatId) {
        print('salmmm$data');
        setState(() {
          _draftContent = data['draft'];
          _messageController.text = _draftContent ?? '';
        });
      }
    });

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
    // await _secureDraftService.saveDraft(widget.chatId, draftContent);
     getit.get<SocketService>().draftMessagerecived('draft', (data) {
      print('salma');

      if (data != null && data['chatId'] == widget.chatId) {
        print('aa$data');
        setState(() {
          _draftContent = data['draft'];
          _messageController.text = _draftContent ?? '';
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant BottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editedMessage != oldWidget.editedMessage) {
      _initializeMessage();
    }
  }

  void _initializeMessage() async {
    // String? savedDraft = await _secureDraftService.loadDraft(widget.chatId);
    // if (savedDraft != null) {
    //   setState(() {
    //     _messageController.text = savedDraft;
    //     _isTyping = savedDraft.isNotEmpty;
    //   });
    // }
    if (widget.editedMessage != null) {
      _messageController.text = widget.editedMessage!.content;
      _isTyping = true;
    
    } else {
      _messageController.clear();
      _isTyping = false;
    }
  }

  Future<void> _initializeRecorder() async {
    if (await Permission.microphone.request().isDenied ||
        await Permission.storage.request().isDenied) {
      print("Permission denied!");
    }
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception('Microphone permission not granted');
    }
    await _recorder.openRecorder();
  }

  Future<void> _startRecording() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';

      setState(() {
        _isRecording = true;
        _recordPath = filePath;
      });
      print("Recording to: $_recordPath");
      await _recorder.startRecorder(
        toFile: filePath,
        codec: Codec.pcm16WAV,
      );
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      print("Error while starting the recorder: $e");
    }
  }

  Future<void> onSendAudio() async {
    Media media = await context.read<MessagesCubit>().uploadAudio(_recordPath!);
    print('${media.mediaKey}');
    print(media.mediaUrl);
    getit.get<SocketService>().sendMessage(
      'message:send',
      {
        'mediaUrl': media.mediaUrl,
        'chatId': widget.chatId,
        'messageType': 'audio',
        'mediaKey': media.mediaKey,
        'isPost': (widget.isChannel) ? true : false,
        'parentPost':
            (widget.isChannel) ? widget.repliedMessage?.id ?? null : null,
      },
    );
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    // Check if the file exists
    if (_recordPath != null) {
      if (!kIsWeb) {
        File file = File(_recordPath!);
        if (file.existsSync()) {
          print("File saved successfully: ${file.path}");
          await onSendAudio(); // Upload the file if it exists
        } else {
          print("File not found at: $_recordPath");
        }
      }
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
          onStickerSelected: (stickerUrl) {
            onSendStickerGIFs(stickerUrl);
            Navigator.pop(context); // Close the picker
          },
          onGifSelected: (gifUrl) {
            onSendStickerGIFs(gifUrl);
            Navigator.pop(context); // Close the picker
          },
        );
      },
    );
  }

  Future<void> onSendStickerGIFs(String url) async {
    getit.get<SocketService>().sendMessage(
      'message:send',
      {
        'chatId': widget.chatId,
        'messageType': 'sticker',
        'replyOn': widget.repliedMessage?.id ?? null,
        'mediaUrl': url,
        'isPost': (widget.isChannel) ? true : false,
        'parentPost':
            (widget.isChannel) ? widget.repliedMessage?.id ?? null : null,
      },
    );
    widget.clearReply();
  }

  Future<void> onSendText(String text, dynamic mediaFile) async {
    String messageType = 'text';
    String? mediaUrl;
    String? mediaKey;

    if (mediaFile != null) {
      print(mediaFile.name);
      dynamic data = await context.read<MessagesCubit>().uploadMedia(mediaFile);
      mediaKey = data['mediaKey'];
      mediaUrl = data['signedUrl'];
      messageType = data['fileType'];
    }

    if (widget.editedMessage != null) {
      getit.get<SocketService>().editMessage('message:update',
          {'messageId': widget.editedMessage!.id, 'content': text});
    } else {
      if (text.trim().isNotEmpty || mediaFile != null) {
        getit.get<SocketService>().sendMessage(
          'message:send',
          {
            'content': text,
            'chatId': widget.chatId,
            'messageType': messageType,
            'replyOn': widget.repliedMessage?.id ?? null,
            'mediaUrl': mediaUrl,
            'mediaKey': mediaKey,
            'isPost': (widget.isChannel) ? true : false,
            'parentPost':
                (widget.isChannel) ? widget.repliedMessage?.id ?? null : null,
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
        (mediaMessage != null)
            ? Row(
                children: [
                  Flexible(
                    child: Text(
                      mediaMessage!.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        mediaMessage = null;
                      });
                    },
                  ),
                ],
              )
            : SizedBox.shrink(),
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
            MediaPickerMenu(
              onSelectMedia: (dynamic attachment) {
                setState(() {
                  mediaMessage = attachment;
                });
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
                      style: TextStyle(color: Colors.red),
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
                    : (_isTyping || mediaMessage != null)
                        ? Icons.send
                        : Icons.mic,
                color: _isRecording ? Colors.red : null,
              ),
              onPressed: () async {
                if (_isRecording) {
                  await _stopRecording();
                } else if (_isTyping || mediaMessage != null) {
                  await onSendText(
                      _messageController.text.trim(), mediaMessage);
                  setState(() {
                    _messageController.clear();
                    mediaMessage = null;
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
