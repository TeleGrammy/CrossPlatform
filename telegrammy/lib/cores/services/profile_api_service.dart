import 'dart:async';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:telegrammy/cores/constants/api_constants.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';
import 'package:telegrammy/features/profile/data/models/profile_info_model.dart';
import 'package:telegrammy/features/profile/data/models/profile_visibility_model.dart';
import 'package:telegrammy/features/profile/data/models/blocked_user_model.dart';
import 'package:telegrammy/features/profile/data/models/stories_model.dart';

import 'dart:typed_data'; // For Uint8List
import 'package:http_parser/http_parser.dart'; // For specifying content type in web

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

  Future<void> updateProfileVisibility(
      ProfileVisibility profileVisibility) async {
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
        data:
            storyCreation.toJson(), // Only send content and media for creation
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

  Future<ProfileInfoResponse> getProfileInfo() async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();

      print(token);
      final response = await dio.get(
        '$baseUrl2/user/profile',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      print("Profile info retrieved successfully.");

      return ProfileInfoResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      throw Exception('Error fetching profile info: ${dioError.message}');
    }
  }

  Future<void> updateProfileInfo(ProfileInfo profileInfo) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();

      final response = await dio.patch('$baseUrl2/user/profile/',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: profileInfo.toJson());
      print(response.data);
    } on DioException catch (dioError) {
      throw Exception('Error updating profile info: ${dioError.message}');
    }
  }

  Future<void> updateUserActivityStatus(String status) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      print(token);
      await dio.patch('$baseUrl2/user/profile/',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: {'status': status});
    } on DioException catch (dioError) {
      throw Exception(
          'Error updating user activity status: ${dioError.message}');
    }
  }

  Future<void> updateUserEmail(String email) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();

      final response = await dio.patch('$baseUrl2/user/profile/email',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: {'email': email});
    } on DioException catch (dioError) {
      throw Exception('Error updating user email: ${dioError.message}');
    }
  }

  Future<void> updateUsername(String username) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();

      await dio.patch('$baseUrl2/user/profile/',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: {'username': username});
    } on DioException catch (dioError) {
      throw Exception('Error updating username: ${dioError.message}');
    }
  }

  Future<void> updateUserPhoneNumber(String phoneNumber) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();

      final response = await dio.patch('$baseUrl2/user/profile/',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: {'phone': phoneNumber});
      print(response.data['status']);
    } on DioException catch (dioError) {
      throw Exception('Error updating phone number: ${dioError.message}');
    }
  }

  Future<ProfilePictureResponse> updateProfilePic(XFile pickedFile) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();

      Uint8List fileBytes = await pickedFile.readAsBytes();
      final fileName = pickedFile.name;

      // Construct FormData
      final formData = FormData.fromMap({
        "picture": MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: MediaType("image", "jpeg"), // Adjust based on file type
        ),
      });

      final response = await dio.patch(
        '$baseUrl2/user/profile/picture',
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            'Authorization': 'Bearer $token',
          },
          followRedirects: false,
          validateStatus: (status) =>
              status! < 500, // Accept responses with status < 500
        ),
      );

      if (response.statusCode == 200) {
        print("Profile picture updated successfully: ${response.data}");
      } else {
        print("Failed to update profile picture: ${response.data}");
      }

      return ProfilePictureResponse.fromJSON(response.data);
    } on DioException catch (dioError) {
      throw Exception('Error updating profile picture: ${dioError.message}');
    }
  }

  // Future<ProfilePictureResponse> updateProfilePic(File pickedFile) async {
  //   try {
  //     String? token = await getit.get<TokenStorageService>().getToken();
  //
  //     final fileName = pickedFile.path.split('/').last;
  //     final formData = FormData.fromMap({
  //       "picture": await MultipartFile.fromFile(
  //         pickedFile.path,
  //         filename: fileName,
  //       ),
  //     });
  //
  //     final response = await dio.patch(
  //       '$baseUrl2/user/profile/picture',
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           "Content-Type": "multipart/form-data",
  //           'Authorization': 'Bearer $token',
  //         },
  //         followRedirects: false,
  //         validateStatus: (status) =>
  //             status! < 500, // Accept responses with status < 500
  //       ),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print("Profile picture updated successfully: ${response.data}");
  //     } else {
  //       print("Failed to update profile picture: ${response.data}");
  //     }
  //
  //     return ProfilePictureResponse.fromJSON(response.data);
  //   } on DioException catch (dioError) {
  //     throw Exception('Error updating profile picture: ${dioError.message}');
  //   }
  // }

  Future<void> deleteProfilePicture() async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      await dio.delete(
        '$baseUrl2/user/profile/picture',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
    } on DioException catch (dioError) {
      throw Exception('Error deleting profile picture: ${dioError.message}');
    }
  }
}
