import 'package:telegrammy/cores/models/post_comment_model.dart';

/// Model representing a Post in a channel.
class Post {
  final String? id;
  final String channelId;
  final String content;
  final String authorId;
  final DateTime? createdAt;
  final List<String>? attachments;
  final bool threadsAllowed;
  final List<Comment> comments;
  final Post? repliedTo;

  Post({
    this.id,
    required this.channelId,
    required this.content,
    required this.authorId,
    this.createdAt,
    this.attachments,
    this.comments = const [],
    required this.threadsAllowed,
    this.repliedTo,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        channelId: json['channelId'],
        content: json['content'],
        authorId: json['authorId'],
        createdAt: DateTime.parse(json['createdAt']),
        attachments: json['attachments'] != null
            ? List<String>.from(json['attachments'])
            : null,
        comments: (json['comments'] as List<dynamic>?)
                ?.map((comment) => Comment.fromJson(comment))
                .toList() ??
            [],
        threadsAllowed: json['threadsAllowed']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channelId': channelId,
      'content': content,
      'authorId': authorId,
      'createdAt': createdAt?.toIso8601String(),
      'attachments': attachments,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'threadsAllowed': threadsAllowed
    };
  }
}
