import 'dart:async';
import 'package:dio/dio.dart';
import 'package:telegrammy/cores/constants/api_constants.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';
import 'package:telegrammy/features/admin_dashboard/data/models/registered_users_model.dart';


class NotificationsApiService {
 NotificationsApiService({required this.dio});

  // Replace with your actual base URL
  final Dio dio;




Future<void> muteNotifications(String chatId) async {
  final String url = "$baseUrl2/notification/mute"; // Append 'block' or 'unblock' to the URL

  try {
    // Retrieve the token
    String? token = await getit.get<TokenStorageService>().getToken();

    // Construct the request body
    final Map<String, String> body = {"chatId": chatId};

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
      print('Successfully updated muting status.');
    } else {
      print('Failed to updatebanning status. Status Code: ${response.statusCode}');
      print('Response: ${response.data}');
    }
  } on DioException catch (dioError) {
    print('Error updating banning status: ${dioError.message}');
  } catch (e) {
    print('An unexpected error occurred: $e');
  }
} 

///////////////////////////////////////////////////
Future<void> unmuteNotifications(String chatId) async {
  final String url = "$baseUrl2/notification/unmute"; // Append 'block' or 'unblock' to the URL

  try {
    // Retrieve the token
    String? token = await getit.get<TokenStorageService>().getToken();

    // Construct the request body
    final Map<String, String> body = {"chatId": chatId};

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
      print('Successfully updated muting status.');
    } else {
      print('Failed to updatebanning status. Status Code: ${response.statusCode}');
      print('Response: ${response.data}');
    }
  } on DioException catch (dioError) {
    print('Error updating banning status: ${dioError.message}');
  } catch (e) {
    print('An unexpected error occurred: $e');
  }
} 
  
}
