import 'package:telegrammy/cores/models/post_model.dart';

class Channel {
  final String? id;
  final String name;
  final String description;
  final String? inviteLink;
  final List<String>? adminsId;
  final DateTime createdAt;
  final bool isChannelPublic;
  final List<String>? subscribedUsers;
  final String? imageUrl;
  final List<Post> posts;

  Channel({
    this.id,
    required this.name,
    required this.description,
    this.inviteLink,
    this.adminsId,
    required this.createdAt,
    required this.isChannelPublic,
    this.subscribedUsers,
    this.imageUrl,
    this.posts = const [],
  });
}
