import 'dart:async';
import 'package:dio/dio.dart';
import 'package:telegrammy/cores/constants/api_constants.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';
import 'package:telegrammy/features/admin_dashboard/data/models/groups_dashboard_model.dart';
import 'package:telegrammy/features/admin_dashboard/data/models/registered_users_model.dart';


class AdminDashboardApiService {
 AdminDashboardApiService({required this.dio});

  // Replace with your actual base URL
  final Dio dio;

Future<RegisteredUsersResponse> getRegisteredUsers() async {
  try {
    // print('salma');
    String? token = await getit.get<TokenStorageService>().getToken();
    final response = await dio.get(
      '$baseUrl2/admins/users',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );
    //  print(response.data);
    return RegisteredUsersResponse.fromJson(response.data);
   
  } on DioException catch (dioError) {
    throw Exception('Error fetching registered Users: ${dioError.message}');
  }
}
Future<GroupDataResponse> getGroups() async {
  try {
    // print('salma');
    String? token = await getit.get<TokenStorageService>().getToken();
    final response = await dio.get(
      '$baseUrl2/admins/groups',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );
    //  print(response.data);
    return GroupDataResponse.fromJson(response.data);
   
  } on DioException catch (dioError) {
    throw Exception('Error fetching registered Users: ${dioError.message}');
  }
}


Future<void> banOrUnbanUser(String isBanned, String userId) async {
  final String url = "$baseUrl2/admins/users/$userId"; // Append 'block' or 'unblock' to the URL

  try {
    // Retrieve the token
    String? token = await getit.get<TokenStorageService>().getToken();

    // Construct the request body
    final Map<String, String> body = {"status": isBanned};

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
      print('Successfully updated banning status.');
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
Future<void> filterMediaGroup(bool isBanned, String groupId) async {
  final String url = "$baseUrl2/admins/filter/$groupId"; // Append 'block' or 'unblock' to the URL

  try {
    // Retrieve the token
    String? token = await getit.get<TokenStorageService>().getToken();

    // Construct the request body
    final Map<String, bool> body = {"applyFilter": isBanned};

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
      print('Successfully updated banning status.');
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
