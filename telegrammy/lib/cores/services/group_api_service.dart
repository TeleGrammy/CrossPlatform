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

  Future<ContactsResponse> getContacts() async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await dio.get(
        '$baseUrl/privacy/settings/get-contacts',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      return ContactsResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      throw Exception('Error fetching contacts: ${dioError.message}');
    }
  }

  Future<MembersResponse> getGroupMembers(String groupId) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await dio.get(
        '$baseUrl/groups/$groupId/members',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      print(response.data);
      return MembersResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      throw Exception('Error fetching group members: ${dioError.message}');
    }
  }

  Future<List<dynamic>> getGroupRelevantUsers(String groupId) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();

      final contactsResponse = await dio.get(
        '$baseUrl/privacy/settings/get-contacts',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      final membersResponse = await dio.get(
        '$baseUrl/groups/$groupId/members',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      final adminsResponse = await dio.get(
        '$baseUrl/groups/$groupId/admins',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      List<dynamic> result = [
        ContactsResponse.fromJson(contactsResponse.data),
        MembersResponse.fromJson(membersResponse.data),
        AdminsResponse.fromJson(adminsResponse.data),
      ];
      return result;
    } on DioException catch (dioError) {
      throw Exception('Error fetching group users: ${dioError.message}');
    }
  }

  Future<AdminsResponse> getGroupAdmins(String groupId) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await dio.get(
        '$baseUrl/groups/$groupId/admins',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      print(response.data);
      return AdminsResponse.fromJson(response.data);
    } on DioException catch (dioError) {
      throw Exception('Error fetching group admins: ${dioError.message}');
    }
  }

  Future<void> makeAdmin(String groupId, String userId) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await dio.patch(
        '$baseUrl/groups/$groupId/admins/$userId',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      print(response.data['status']);
      return null;
    } on DioException catch (dioError) {
      throw Exception('Error making user an admin: ${dioError.message}');
    }
  }

  Future<void> addContact(String username) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await dio.post('$baseUrl/chats/fetch-contacts',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: {
            'contacts': [username]
          });
      print(response.data['status']);
      return null;
    } on DioException catch (dioError) {
      throw Exception('Error adding contact: ${dioError.message}');
    }
  }
}
