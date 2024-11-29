class Comment {
  final String id;
  final String postId;
  final String authorId; 
  final String content;
  final DateTime createdAt; 

  Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      authorId: json['authorId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'authorId': authorId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
