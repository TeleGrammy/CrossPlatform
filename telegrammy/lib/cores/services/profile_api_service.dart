import 'dart:async';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:telegrammy/cores/constants/api_constants.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';
import 'package:telegrammy/features/profile/data/models/profile_info_model.dart';
import 'package:telegrammy/features/profile/data/models/contacts_toblock_model.dart';
import 'package:telegrammy/features/profile/data/models/profile_visibility_model.dart';
import 'package:telegrammy/features/profile/data/models/blocked_user_model.dart';
import 'package:telegrammy/features/profile/data/models/settings_user_model.dart';
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
Future<UserPrivacySettingsResponse> getUserSettings() async {
  try {
    // print('salma');
    String? token = await getit.get<TokenStorageService>().getToken();
    final response = await dio.get(
      '$baseUrl2/privacy/settings',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );
    //  print(UserPrivacySettingsResponse.fromJson(response.data));
    return UserPrivacySettingsResponse.fromJson(response.data);
   
  } on DioException catch (dioError) {
    throw Exception('Error fetching user privacy settings: ${dioError.message}');
  }
}
Future<void> updateProfileVisibility(ProfileVisibility profileVisibility) async {
  try {
    String? token = await getit.get<TokenStorageService>().getToken();
    print(token); 
    await dio.patch(
      '$baseUrl2/privacy/settings/profile-visibility',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      data: profileVisibility.toJson(), // Using the toJson() method of ProfileVisibility
    );
  } on DioException catch (dioError) {
    throw Exception('Error updating profile visibility: ${dioError.message}');
  }
}

  Future<BlockedUsersResponse> getBlockedUsers() async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      //  print('token:$token');
      final response = await dio.get(
        '$baseUrl2/privacy/settings/get-blocked-users',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      // print(BlockedUsersResponse.fromJson(response.data));
      return BlockedUsersResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      // print('error');
      throw Exception('Error fetching blocked users: ${dioError.message}');
    }
  }

  Future<ContactsResponse> getContacts() async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      //  print('token:$token');
      final response = await dio.get(
        '$baseUrl2/privacy/settings/get-contacts',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      // print(response);
      return ContactsResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      // print('error');
      throw Exception('Error fetching blocked users: ${dioError.message}');
    }
  }



Future<void> updateBlockingStatus(String action, String userId) async {
  final String url = "$baseUrl2/privacy/settings/blocking-status/$action"; // Append 'block' or 'unblock' to the URL

  try {
    // Retrieve the token
    String? token = await getit.get<TokenStorageService>().getToken();

    // Construct the request body
    final Map<String, String> body = {"userId": userId};

    // Make the PATCH request with Dio
    final response = await dio.patch(
      url,
      data: body, // Pass the body directly
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      print('Successfully updated blocking status.');
    } else {
      print('Failed to update blocking status. Status Code: ${response.statusCode}');
      print('Response: ${response.data}');
    }
  } on DioException catch (dioError) {
    print('Error updating blocking status: ${dioError.message}');
  } catch (e) {
    print('An unexpected error occurred: $e');
  }
}

Future<void> updateReadReceiptsStatus(bool isEnabled) async {
  final String url = "$baseUrl2/privacy/settings/read-receipts"; // Endpoint for read receipts

  try {
    // Retrieve the token
    String? token = await getit.get<TokenStorageService>().getToken();

    // Ensure token is valid before proceeding
    if (token == null) {
      print('Error: Token is null');
      return;
    }

    // Construct the request body with required fields
    final Map<String, dynamic> body = {
      "isEnabled": isEnabled,  
      "enabled": isEnabled,   
    };

    // Make the PATCH request with Dio
    final response = await dio.patch(
      url,
      data: body, // Pass the body directly
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Handle the response
    if (response.statusCode == 201) {
      print('Successfully updated read receipts status.');
      print('Response: ${response.data}');
    } else {
      print('Failed to update read receipts status. Status Code: ${response.statusCode}');
      print('Response: ${response.data}');
      // Optionally, throw an error or handle as needed
    }
  } on DioException catch (dioError) {
    // Handle Dio-specific errors (e.g., network errors, timeouts)
    print('Error updating read receipts status: ${dioError.message}');
    if (dioError.response != null) {
      print('Error response: ${dioError.response}');
    }
  } catch (e) {
    // Catch any other exceptions
    print('An unexpected error occurred: $e');
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

Future<MultiUserStoryResponse> getOtherUserStories(int page, int limit) async {
  try {
    String? token = await getit.get<TokenStorageService>().getToken();
    
    final response = await dio.get(
      '$baseUrl2/user/stories/contacts',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    print('Multi User Story Response: ${response.data}');
    
    // Parse the response into MultiUserStoryResponse
    return MultiUserStoryResponse.fromJson(response.data);
    
  } on DioException catch (dioError) {
    print('Dio Error: $dioError');
    throw Exception('Error fetching multi-user stories: ${dioError.message}');
  }
}
/////////////////////////////////////
Future<void> markStoryAsViewed(String storyId) async {
  try {
    String? token = await getit.get<TokenStorageService>().getToken();

    await dio.patch(
      '$baseUrl2/user/stories/$storyId/view',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    print('Story marked as viewed successfully');
  } on DioException catch (dioError) {
    throw Exception('Error marking story as viewed: ${dioError.message}');
  }
}
//////////////////////////
Future<void> createStory(StoryCreation storyCreation) async {
  try {
    final String? token = await getit.get<TokenStorageService>().getToken();
    if (token == null) {
      print("Error: No token found.");
      return;
    }

    final dio = Dio();
    final formData = storyCreation.toFormData();
    
    // Debug: Print token and formData content
    print('Token: $token');
    print('FormData: $formData');
    
    final response = await dio.post(
      '$baseUrl2/user/stories',
      options: Options(
        headers: {
          "Content-Type": "multipart/form-data",
          'Authorization': 'Bearer $token',
        },
      ),
      data: formData,
    );

    // Debug: Print the response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Story created successfully.");
    } else {
      print('Unexpected server response: ${response.statusCode}');
    }
  } on DioException catch (dioError) {
    // Handle errors from Dio
    print('Error during request: ${dioError.message}');
    if (dioError.response != null) {
      print('Server Response: ${dioError.response?.data}');
    }
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

  Future<void> deleteProfilePicture() async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await dio.delete(
        '$baseUrl2/user/profile/picture',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        print("Profile picture deleted successfully: ${response.data}");
      } else {
        print("Failed to delete profile picture: ${response.data}");
      }
    } on DioException catch (dioError) {
      throw Exception('Error deleting profile picture: ${dioError.message}');
    }
  }
}
