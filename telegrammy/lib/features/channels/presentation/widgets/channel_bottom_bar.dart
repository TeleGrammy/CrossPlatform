import 'package:flutter/material.dart';
import 'package:telegrammy/cores/models/post_model.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/features/channels/presentation/widgets/posts_body.dart';

class ChannelBottomBar extends StatefulWidget {
  final void Function(Post) onSend;
  final void Function(Post, String) onEdit;
  final Post? editedPost;
  final bool isAdmin;
  final bool isJoined;

  const ChannelBottomBar(
      {super.key,
      required this.onSend,
      required this.onEdit,
      this.editedPost,
      required this.isAdmin,
      required this.isJoined});
  @override
  State<ChannelBottomBar> createState() => _ChannelBottomBarState();
}

class _ChannelBottomBarState extends State<ChannelBottomBar> {
  final TextEditingController _postController = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _initializePost();
    _postController.addListener(() {
      setState(() {
        _isTyping = _postController.text.isNotEmpty;
      });
    });
  }

  @override
  void didUpdateWidget(covariant ChannelBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editedPost != oldWidget.editedPost) {
      _initializePost();
    }
  }

  void _initializePost() {
    if (widget.editedPost != null) {
      _postController.text = widget.editedPost!.content;
      _isTyping = true;
    } else {
      _postController.clear();
      _isTyping = false;
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.isAdmin)
        ? Row(
            children: [
              IconButton(
                icon: Icon(Icons.insert_emoticon),
                onPressed: () {
                  // Add emoji picker functionality here
                },
              ),
              Expanded(
                child: TextField(
                  controller: _postController,
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_isTyping ? Icons.send : Icons.mic),
                onPressed: _isTyping
                    ? () {
                        if (widget.editedPost == null) {
                          widget.onSend(Post(
                              authorId: userId,
                              content: _postController.text.trim(),
                              channelId: '1',
                              threadsAllowed: true));
                        } else {
                          widget.onEdit(
                              widget.editedPost!, _postController.text.trim());
                        }
                      }
                    : () {
                        // Handle voice note functionality here
                        print('Recording voice note...');
                      },
              ),
            ],
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.09,
            child: TextButton(
              key: Key('joinMuteChannelButton'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(0),
              ),
              onPressed: () {
                //join channel funtionality
              },
              child: Text((widget.isJoined) ? 'Unjoin' : 'Join',
                  textAlign: TextAlign.center,
                  style: textStyle30.copyWith(
                    fontWeight: FontWeight.w900,
                  )),
            ),
          );
  }
}
