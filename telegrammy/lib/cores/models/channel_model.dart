import 'package:telegrammy/cores/models/post_model.dart';

class Channel {
  final String? id;
  final String name;
  final String description;
  final String? inviteLink;
  final List<String>? adminsId;
  final String createdAt;
  final String privacy;
  final List<String>? subscribedUsers;
  final String? image;
  final List<Post> posts;

  Channel({
    this.id,
    required this.name,
    required this.description,
    this.inviteLink,
    this.adminsId,
    required this.createdAt,
    required this.privacy,
    this.subscribedUsers,
    this.image,
    this.posts = const [], String? channelId,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['channelId'],
      name: json['channelName'],
      description: json['channelDescription'] ?? '-',
      image: json['image'] ?? 'default.jpg',
      privacy: json['channelPrivacy'] ?? 'public',
      createdAt: json['channelCreationDate'].toString(),
    );
  }
}
