import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/models/post_model.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';

class PostCommentsView extends StatefulWidget {
  final Post post;
  const PostCommentsView({super.key, required this.post});

  @override
  State<PostCommentsView> createState() => _PostCommentsViewState();
}

class _PostCommentsViewState extends State<PostCommentsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.goNamed(RouteNames.channel,
                queryParameters: {'channelId': widget.post.channelId});
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}
