class Story {
  final String id;
  final String content;
  final String? media;
  final DateTime expiresAt;
  final String userId;
  final Map<String, DateTime>? viewers;
  final int version;
  final int? viewersCount;
  Story({
    required this.id,
    required this.content,
    this.media,
    required this.expiresAt,
    required this.userId,
    this.viewers,
    
    required this.version,
    this.viewersCount,
  });

  // Factory constructor to create a Story instance from JSON
  factory Story.fromJson(Map<String, dynamic> json) {
    // Parse viewers if they exist in the JSON
    Map<String, DateTime>? parsedViewers;
    if (json['viewers'] != null) {
      parsedViewers = (json['viewers'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, DateTime.parse(value)),
      );
    }
    return Story(
      id: json['_id'],
      content: json['content'],
      media: json['media'],
      expiresAt: DateTime.parse(json['expiresAt']),
      userId: json['userId'],
      viewers: parsedViewers,
      version: json['__v'],
      viewersCount: json['viewersCount'],
    );
  }

  // Convert Story instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'media': media,
      'expiresAt': expiresAt.toIso8601String(),
      'userId': userId,
      'viewers': viewers?.map((key, value) => MapEntry(key, value.toIso8601String())),
      '__v': version,
    };
  }

  // Static method to parse a list of stories from JSON
  static List<Story> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Story.fromJson(json)).toList();
  }
}

class StoryResponse {
  final List<Story> data;
  final String status;

  StoryResponse({required this.data, required this.status});

  factory StoryResponse.fromJson(Map<String, dynamic> json) {
    return StoryResponse(
      data: (json['data'] as List).map((story) => Story.fromJson(story)).toList(),
      status: json['status'],
    );
  }
}
class StoryCreation {
  final String content;
  final String? media;

  StoryCreation({
    required this.content,
    this.media,
  });

  // Convert Story instance to JSON for POST request (only content and media if not null)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'content': content,
    };

    if (media != null) {
      data['media'] = media;
    }

    return data;
  }
}

