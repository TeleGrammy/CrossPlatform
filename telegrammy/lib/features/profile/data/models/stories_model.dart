// import 'dart:typed_data';

// import 'package:dio/dio.dart';
// import 'package:http_parser/http_parser.dart';
// class Story {
//   final String id;
//   final String content;
//   final String? media;
//   final DateTime expiresAt;
//   final String userId;
//   final Map<String, DateTime>? viewers;
//   final int version;
//   final int? viewersCount;
//   Story({
//     required this.id,
//     required this.content,
//     this.media,
//     required this.expiresAt,
//     required this.userId,
//     this.viewers,
    
//     required this.version,
//     this.viewersCount,
//   });

//   // Factory constructor to create a Story instance from JSON
//   factory Story.fromJson(Map<String, dynamic> json) {
//     // Parse viewers if they exist in the JSON
//     Map<String, DateTime>? parsedViewers;
//     if (json['viewers'] != null) {
//       parsedViewers = (json['viewers'] as Map<String, dynamic>).map(
//         (key, value) => MapEntry(key, DateTime.parse(value)),
//       );
//     }
//     return Story(
//       id: json['_id'],
//       content: json['content'],
//       media: json['media'],
//       expiresAt: DateTime.parse(json['expiresAt']),
//       userId: json['userId'],
//       viewers: parsedViewers,
//       version: json['__v'],
//       viewersCount: json['viewersCount'],
//     );
//   }

//   // Convert Story instance back to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'content': content,
//       'media': media,
//       'expiresAt': expiresAt.toIso8601String(),
//       'userId': userId,
//       'viewers': viewers?.map((key, value) => MapEntry(key, value.toIso8601String())),
//       '__v': version,
//     };
//   }

//   // Static method to parse a list of stories from JSON
//   static List<Story> listFromJson(List<dynamic> jsonList) {
//     return jsonList.map((json) => Story.fromJson(json)).toList();
//   }
// }

// class StoryResponse {
//   final List<Story> data;
//   final String status;

//   StoryResponse({required this.data, required this.status});

//   factory StoryResponse.fromJson(Map<String, dynamic> json) {
//     return StoryResponse(
//       data: (json['data'] as List).map((story) => Story.fromJson(story)).toList(),
//       status: json['status'],
//     );
//   }
// }

// // StoryCreation Class
// // StoryCreation Class
// class StoryCreation {
//   final String content;
//   final Uint8List? media; // Accept media as raw binary (image bytes)
//   final String mediaType; // Accept media as raw binary (image bytes)

//   StoryCreation({
//     required this.content,
//     this.media,
//     required this.mediaType
//   });
  
//   // Prepare multipart data payload
//   FormData toFormData() {
//     // print(media);
//  final formData = FormData.fromMap({
//          "content":content, 
//          "mediaType":mediaType,
//         "story": MultipartFile.fromBytes(
//           media!,
//           filename: 'story_img.jpeg',
//           contentType: MediaType("image", "jpeg"), // Adjust based on file type
//         ),
//       });
//     print('outside');
//     return formData;
//   }
// }

import 'dart:typed_data';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

/// Story Model Class
class Story {
  final String id;
  final String content;
  final String? media;
  final DateTime expiresAt;
  final String userId;
  final Map<String, ViewerDetails>? viewers; // Updated to handle nested structure
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

  /// Factory constructor to parse JSON into a Story instance
  factory Story.fromJson(Map<String, dynamic> json) {
    Map<String, ViewerDetails>? parsedViewers;

    if (json['viewers'] is Map<String, dynamic>) {
      parsedViewers = (json['viewers'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, ViewerDetails.fromJson(value)),
      );
    }

    return Story(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      media: json['media']?.toString(),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'])
          : DateTime.now(),
      userId: json['userId'] ?? '',
      viewers: parsedViewers,
      version: json['__v'] ?? 0,
      viewersCount: json['viewersCount'] ?? 0,
    );
  }

  /// Converts Story instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'media': media,
      'expiresAt': expiresAt.toIso8601String(),
      'userId': userId,
      'viewers': viewers?.map((key, value) => MapEntry(key, value.toJson())),
      '__v': version,
    };
  }

  /// Static method to parse a list of stories from JSON
  static List<Story> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Story.fromJson(json)).toList();
  }
}

/// ViewerDetails class to parse each viewer's detailed data
class ViewerDetails {
  final String viewerId;
  final DateTime viewedAt;
  final ViewerProfile profile;

  ViewerDetails({
    required this.viewerId,
    required this.viewedAt,
    required this.profile,
  });

  /// Factory constructor to parse JSON into a ViewerDetails instance
  factory ViewerDetails.fromJson(Map<String, dynamic> json) {
    return ViewerDetails(
      viewerId: json['viewerId'] ?? '',
      viewedAt: DateTime.parse(json['viewedAt']),
      profile: ViewerProfile.fromJson(json['profile']),
    );
  }

  /// Converts ViewerDetails instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'viewerId': viewerId,
      'viewedAt': viewedAt.toIso8601String(),
      'profile': profile.toJson(),
    };
  }
}

/// ViewerProfile class to parse profile information
class ViewerProfile {
  final String username;
  final String email;
  final String picture;
  final String screenName;
  final String? id;

  ViewerProfile({
    required this.username,
    required this.email,
    required this.picture,
    required this.screenName,
    this.id,
  });

  /// Factory constructor to parse JSON into a ViewerProfile instance
  factory ViewerProfile.fromJson(Map<String, dynamic> json) {
    return ViewerProfile(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      picture: json['picture'] ?? '',
      screenName: json['screenName'] ?? '',
      id: json['id'],
    );
  }

  /// Converts ViewerProfile instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'picture': picture,
      'screenName': screenName,
      'id': id,
    };
  }
}

/// Story Response Model
class StoryResponse {
  final List<Story> data;
  final String status;

  StoryResponse({required this.data, required this.status});

  /// Factory constructor to safely parse the response JSON into a StoryResponse
  factory StoryResponse.fromJson(Map<String, dynamic> json) {
    try {
      return StoryResponse(
        data: json['data'] != null
            ? (json['data'] as List<dynamic>)
                .map((story) => Story.fromJson(story))
                .toList()
            : [],
        status: json['status'] ?? '',
      );
    } catch (e) {
      print("Error parsing story response: $e");
      return StoryResponse(data: [], status: 'Error');
    }
  }
}

/// Story Creation class for handling story creation data payloads
class StoryCreation {
  final String content;
  final Uint8List? media; // Accept media as raw binary (image bytes)
  final String mediaType; // Accept media type

  StoryCreation({
    required this.content,
    this.media,
    required this.mediaType,
  });

  /// Prepares the payload for multipart upload
  FormData toFormData() {
    final formData = FormData.fromMap({
      "content": content,
      "mediaType": mediaType,
      "story": MultipartFile.fromBytes(
        media ?? Uint8List(0),
        filename: 'story_img.jpeg',
        contentType: MediaType("image", "jpeg"), // Adjust based on your media type
      ),
    });
    return formData;
  }
}

///////////////////
///
class Profile {
  final String username;
  final String email;
  final String screenName;
  final String? picture;

  Profile({
    required this.username,
    required this.email,
    required this.screenName,
    this.picture,
  });

  // Parsing from JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      username: json["username"],
      email: json["email"],
      screenName: json["screenName"],
      picture: json["picture"],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "screenName": screenName,
      "picture": picture,
    };
  }
}

class UserStoriesModel {
  final String id;
  final List<Story> stories;
  final Profile profile;

  UserStoriesModel({
    required this.id,
    required this.stories,
    required this.profile,
  });

  // Parsing from JSON
  factory UserStoriesModel.fromJson(Map<String, dynamic> json) {
    return UserStoriesModel(
      id: json["_id"],
      stories: (json["stories"] as List)
          .map((story) => Story.fromJson(story))
          .toList(),
      profile: Profile.fromJson(json["profile"]),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "stories": stories.map((story) => story.toJson()).toList(),
      "profile": profile.toJson(),
    };
  }
}

class MultiUserStoryResponse {
  final List<UserStoriesModel> userStories; // List to store each user's stories and profiles
  final String status;

  MultiUserStoryResponse({required this.userStories, required this.status});

  /// Factory constructor to parse the entire JSON response
  factory MultiUserStoryResponse.fromJson(Map<String, dynamic> json) {
    try {
      // Map each user's data to UserStoriesModel
      List<UserStoriesModel> users = [];
      if (json['data'] is List) {
        users = (json['data'] as List)
            .map((userJson) => UserStoriesModel.fromJson(userJson))
            .toList();
      }

      return MultiUserStoryResponse(
        userStories: users,
        status: json['status'] ?? '',
      );
    } catch (e) {
      print("Error parsing multi-user response: $e");
      return MultiUserStoryResponse(userStories: [], status: 'Error');
    }
  }
}
