import 'package:telegrammy/cores/models/post_model.dart';

enum ChannelPrivacy { public, private }

class Channel {
  final String? id;
  final String name;
  final String description;
  final String? inviteLink;
  final List<String> adminsId;
  final DateTime createdAt;
  final bool isChannelPublic;
  final List<String>? subscribedUsers;
  final String? imageLink;
  final List<Post> posts;

  Channel({
    this.id,
    required this.name,
    required this.description,
    this.inviteLink,
    required this.adminsId,
    required this.createdAt,
    required this.isChannelPublic,
    this.subscribedUsers,
    this.imageLink,
    this.posts = const [],
  });
}
