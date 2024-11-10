import 'dart:async';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:telegrammy/cores/constants/api_constants.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';
import 'package:telegrammy/features/profile/data/models/profile_visibility_model.dart';
import 'package:telegrammy/features/profile/data/models/blocked_user_model.dart';
import 'package:telegrammy/features/profile/data/models/stories_model.dart';
class ProfileApiService {
  ProfileApiService({required this.dio});

   // Replace with your actual base URL
  final Dio dio;




// Future<ProfileVisibility> fetchProfileVisibility() async {
//     try {
//       String? token = await getit.get<TokenStorageService>().getToken();
//       final response = await dio.get('$baseUrl/privacy/settings/profile-visibility',  options: Options(headers: {
//           'Authorization': 'token $token',
//         }),);
//       return ProfileVisibility.fromJson(response.data); // Parse response to ProfileVisibility
//     } on DioException catch (dioError) {
//       throw Exception('Error fetching profile visibility: ${dioError.message}');
//     }
//   }

  Future<void> updateProfileVisibility(ProfileVisibility profileVisibility ) async {
    try {
      // print(
      //   profileVisibility.toJson()
      // );
      String? token = await getit.get<TokenStorageService>().getToken();
      // print(token);
      await dio.patch(
        '$baseUrl2/privacy/settings/profile-visibility',
          options: Options(headers: {
          'Authorization': 'Bearer$token',
          //  'Accept': 'application/json',
        }),
        data: profileVisibility.toJson(),
      );
    } on DioException catch (dioError) {
      throw Exception('Error updating profile visibility: ${dioError.message}');
    }
  }

   Future<BlockedUsersResponse> getBlockedUsers() async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await dio.get(
        '$baseUrl2/privacy/settings/blocked-users',
        options: Options(headers: {
          'Authorization': 'token $token',
        }),
      );

      return BlockedUsersResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      throw Exception('Error fetching blocked users: ${dioError.message}');
    }
  }

////////////////////////////////////////////////////////Stories
    Future<StoryResponse> getUserStories() async {
      try {
        String? token = await getit.get<TokenStorageService>().getToken();
        // print(token);
        final response = await dio.get(
          '$baseUrl2/user/stories',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
        );
        //  print(response.data) ;
        return StoryResponse.fromJson(response.data);
      } on DioException catch (dioError) {
        throw Exception('Error fetching user stories: ${dioError.message}');
      }
    }

      // Create a new story
  Future<void> createStory(StoryCreation storyCreation) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      // Send POST request to create a new story
      print(token);
      await dio.post(
        '$baseUrl2/user/stories',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: storyCreation.toJson(), // Only send content and media for creation
      );
      print("Story created successfully.");
    } on DioException catch (dioError) {
      throw Exception('Error creating story: ${dioError.message}');
    }
  }
  
    Future<void> deleteStory(String storyId) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      print(storyId);
      await dio.delete(
        '$baseUrl2/user/stories/$storyId',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
    } on DioException catch (dioError) {
      throw Exception('Error deleting story: ${dioError.message}');
    }
  }
}