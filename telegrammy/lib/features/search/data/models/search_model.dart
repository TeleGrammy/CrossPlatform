class SearchResult {
  final String id;
  final String title;
  final String subtitle;
  final String? picture;

  SearchResult(
      {required this.id,
      required this.title,
      required this.subtitle,
      this.picture});
}

class UserSearchResult extends SearchResult {
  UserSearchResult(id, title, subtitle, picture)
      : super(id: id, title: title, subtitle: subtitle, picture: picture);

  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(
        json['_id'], json['username'], json['email'], json['picture']);
  }
}

class GroupSearchResult extends SearchResult {
  GroupSearchResult(id, title, subtitle, picture)
      : super(id: id, title: title, subtitle: subtitle, picture: picture);

  factory GroupSearchResult.fromJson(Map<String, dynamic> json) {
    return GroupSearchResult(json['_id'], json['name'],
        json['description'] ?? '', json['image'] ?? null);
  }
}

class ChannelSearchResult extends SearchResult {
  ChannelSearchResult(id, title, subtitle, picture)
      : super(id: id, title: title, subtitle: subtitle, picture: picture);

  factory ChannelSearchResult.fromJson(Map<String, dynamic> json) {
    return ChannelSearchResult(
        json['_id'], json['name'], json['description'] ?? '', null);
  }
}

class MessageSearchResult extends SearchResult {
  MessageSearchResult(id, title, subtitle, picture)
      : super(id: id, title: title, subtitle: subtitle, picture: picture);

  factory MessageSearchResult.fromJson(Map<String, dynamic> json) {
    String subtitle, img;
    if (json['groupId'] != null) {
      subtitle = json['groupName'];
      img = json['groupImage'];
    } else {
      subtitle = json['channelName'];
      img = json['channelImage'];
    }
    return MessageSearchResult(json['_id'], json['content'], subtitle, img);
  }
}

class GlobalSearchResponse {
  List<SearchResult> results;

  GlobalSearchResponse({required this.results});

  factory GlobalSearchResponse.fromJson(
      Map<String, dynamic> json, String type) {
    if (type == 'user') {
      return GlobalSearchResponse(
        results: (json['user'] as List<dynamic>)
            .map((item) => UserSearchResult.fromJson(item))
            .toList(),
      );
    } else if (type == 'group') {
      return GlobalSearchResponse(
        results: (json['group'] as List<dynamic>)
            .map((item) => GroupSearchResult.fromJson(item))
            .toList(),
      );
    } else if (type == 'channel') {
      return GlobalSearchResponse(
        results: (json['channel'] as List<dynamic>)
            .map((item) => ChannelSearchResult.fromJson(item))
            .toList(),
      );
    } else {
      return GlobalSearchResponse(
        results: (json['message'] as List<dynamic>)
            .map((item) => MessageSearchResult.fromJson(item))
            .toList(),
      );
    }
  }
}
