import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telegrammy/features/messages/presentation/data/messages.dart';
import 'package:telegrammy/features/messages/presentation/widgets/emoji_picker.dart';

class BottomBar extends StatefulWidget {
  final void Function(String) onSend;
  final void Function(Message, String) onEdit;
  final void Function(Message) onSendAudio;
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
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception('Microphone permission not granted');
    }
    await _recorder.openRecorder();
  }

  Future<void> _startRecording() async {
    final filePath = 'audio_${DateTime.now().millisecondsSinceEpoch}.aac';
    setState(() {
      _isRecording = true;
      _recordPath = filePath;
    });
    await _recorder.startRecorder(toFile: filePath);
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    if (path != null) {
      widget.onSendAudio(Message(
        text: 'Voice note',
        time: DateTime.now().toString(),
        isSentByUser: true,
        repliedTo: null,
      ));
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
    return Row(
      children: [
        if (!_isRecording)
          IconButton(
            icon: Icon(Icons.insert_emoticon),
            onPressed: () {
              _showEmojiPicker(context);
            },
          ),
        if (_isRecording)
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                _isRecording = false;
                _recordPath = null;
              });
            },
          ),
        Expanded(
          child: _isRecording
              ? Text(
                  'Recording...',
                  style: TextStyle(color: Colors.red),
                )
              : TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                  ),
                ),
        ),
        IconButton(
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
              widget.onSend(_messageController.text.trim());
            } else {
              await _startRecording();
            }
          },
        ),
      ],
    );
  }
}
