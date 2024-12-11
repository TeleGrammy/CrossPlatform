import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telegrammy/features/messages/presentation/data/messages.dart';
import 'package:telegrammy/features/messages/presentation/widgets/emoji_picker.dart';
import 'package:telegrammy/features/messages/presentation/widgets/media_picker.dart';

class BottomBar extends StatefulWidget {
  final void Function(String, XFile?) onSend;
  final void Function(Message, String) onEdit;
  final void Function(String) onSendAudio;
  final Message? editedMessage;

  const BottomBar({
    super.key,
    required this.onSend,
    required this.onEdit,
    required this.onSendAudio,
    this.editedMessage,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final TextEditingController _messageController = TextEditingController();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  bool _isTyping = false;
  bool _isRecording = false;
  String? _recordPath;
  XFile? mediaMessage;

  @override
  void initState() {
    super.initState();
    _initializeMessage();
    _initializeRecorder();

    _messageController.addListener(() {
      setState(() {
        _isTyping = _messageController.text.isNotEmpty;
      });
    });
  }

  @override
  void didUpdateWidget(covariant BottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editedMessage != oldWidget.editedMessage) {
      _initializeMessage();
    }
  }

  void _initializeMessage() {
    if (widget.editedMessage != null) {
      _messageController.text = widget.editedMessage!.text;
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
    final filePath = 'audio_${DateTime.now().millisecondsSinceEpoch}.wav';
    setState(() {
      _isRecording = true;
      _recordPath = filePath;
    });
    try {
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

  Future<void> _stopRecording() async {
    final path = await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    if (path != null) {
      widget.onSendAudio(path);
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

  @override
  void dispose() {
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
              onSelectMedia: (XFile media) {
                setState(() {
                  mediaMessage = media;
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
                  widget.onSend(_messageController.text.trim(), mediaMessage);
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
