import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';
import 'package:telegrammy/features/groups/data/models/group.dart';
import '../constants/api_constants.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';

class GroupApiService {
  final dio = getit.get<Dio>();

  Future<Group> getGroupInfo(String groupId) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await dio.get(
        '$baseUrl/groups/$groupId',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      final data = response.data;
      final result = {
        'name': data['data']['group']['name'],
        'image': data['data']['group']['image'],
        'description': data['data']['group']['description'],
        'groupId': data['data']['group']['_id'],
        'groupPrivacy': data['data']['group']['groupType'],
        'groupSizeLimit': data['data']['group']['groupSizeLimit'],
      };
      return Group.fromJson(response.data['data']['group']);
    } on DioException catch (dioError) {
      throw Exception('Error fetching group info: ${dioError.message}');
    }
  }

  Future<void> updateBasicGroupInfo(
      String groupId, String name, String description) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await dio.patch(
        '$baseUrl/groups/$groupId/info',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: {'name': name, 'description': description},
      );
      print(response);
    } on DioException catch (dioError) {
      throw Exception('Error updating group info: ${dioError.message}');
    }
  }

  Future<Group> updateGroupPicture(String groupId, XFile pickedFile) async {
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
        '$baseUrl2/groups/$groupId/info',
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
        print("Group picture updated successfully: ${response.data}");
      } else {
        print("Failed to update group picture: ${response.data}");
      }

      print(response);
      final data = response.data;
      final result = {
        'name': data['data']['group']['name'],
        'image': data['data']['group']['image'],
        'description': data['data']['group']['description'],
        'groupId': data['data']['group']['_id'],
        'groupPrivacy': data['data']['group']['groupType'],
        'groupSizeLimit': data['data']['group']['groupSizeLimit'],
      };
      return Group.fromJson(response.data['data']['group']);
    } on DioException catch (dioError) {
      throw Exception('Error updating group picture: ${dioError.message}');
    }
  }

  Future<void> deleteGroupPicture(String groupId) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await dio.patch(
        '$baseUrl/groups/$groupId/info',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: {'image': null},
      );
      print(response);
    } on DioException catch (dioError) {
      throw Exception('Error deleting group picture: ${dioError.message}');
    }
  }

  Future<String> updateGroupPrivacy(
      String groupId, String privacyOption) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await dio.patch(
        '$baseUrl/groups/$groupId/group-type',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: {'groupType': privacyOption},
      );
      print(response.data);
      return response.data['status'];
    } on DioException catch (dioError) {
      throw Exception('Error updating group privacy: ${dioError.message}');
    }
  }

  Future<void> updateGroupSizeLimit(String groupId, int sizeLimit) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await dio.patch(
        '$baseUrl/groups/$groupId/size',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: {'groupSize': sizeLimit},
      );
      return null;
    } on DioException catch (dioError) {
      throw Exception('Error updating group size limit: ${dioError.message}');
    }
  }
}
