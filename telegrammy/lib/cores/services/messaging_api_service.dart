import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegrammy/cores/constants/api_constants.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';

class MessagingApiService {
  final dio = getit.get<Dio>();

  Future<dynamic> uploadMedia(dynamic mediaFile, String fileType) async {
    try {
      if (mediaFile == null) {
        throw Exception("No media file selected.");
      }

      String? token = await getit.get<TokenStorageService>().getToken();

      FormData formData;
      // Check if we are on the web or mobile
      if (kIsWeb) {
        if (mediaFile is PlatformFile) {
          Uint8List fileBytes = mediaFile.bytes!;
          formData = FormData.fromMap({
            'media':
                MultipartFile.fromBytes(fileBytes, filename: mediaFile.name),
          });
        } else {
          throw Exception("Invalid file for web");
        }
      } else {
        if (mediaFile is XFile) {
          formData = FormData.fromMap({
            'media': await MultipartFile.fromFile(
              mediaFile.path,
              filename: mediaFile.name,
            ),
          });
        } else {
          throw Exception("Invalid file for mobile");
        }
      }
      Response response = await dio.post(
        '$baseUrl/messaging/upload/media',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        print("Media uploaded successfully!");
        print(response);
        print("Media Key: ${response.data['mediaKey']}");
        print("Signed URL: ${response.data['signedUrl']}");
        return {
          "signedUrl": response.data['signedUrl'],
          "mediaKey": response.data['mediaKey'],
          "fileType": fileType
        };
      } else {
        print("Failed to upload media: ${response.statusMessage}");
        throw Exception("Failed to upload media: ${response.statusMessage}");
      }
    } on DioException catch (dioError) {
      print(
          'Error uploading media: ${dioError.response?.data['message'] ?? dioError.message}');
      throw Exception(
          'Error uploading media: ${dioError.response?.data['message'] ?? dioError.message}');
    } catch (error) {
      throw Exception('Unexpected error: $error');
    }
  }

  Future<dynamic> uploadAudio(String? filePath) async {
    try {
      if (filePath == null) {
        throw Exception("No media file selected.");
      }

      String? token = await getit.get<TokenStorageService>().getToken();

      MultipartFile multipartFile = await MultipartFile.fromFile(
        filePath,
      );

      FormData formData = FormData.fromMap({
        'audio': multipartFile,
      });

      Response response = await dio.post(
        '$baseUrl/messaging/upload/audio',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        print("audio uploaded successfully!");
        print(response);
        print("Media Key: ${response.data['mediaKey']}");
        print("Signed URL: ${response.data['signedUrl']}");
        return {
          "signedUrl": response.data['signedUrl'],
          "mediaKey": response.data['mediaKey'],
          "fileType": "Audio",
        };
      } else {
        print("Failed to upload audio: ${response.statusMessage}");
        throw Exception("Failed to upload audio: ${response.statusMessage}");
      }
    } on DioException catch (dioError) {
      print(
          'Error uploading audio: ${dioError.response?.data['message'] ?? dioError.message}');
      throw Exception(
          'Error uploading audio: ${dioError.response?.data['message'] ?? dioError.message}');
    } catch (error) {
      throw Exception('Unexpected error: $error');
    }
  }

  Future<dynamic> uploadFile(PlatformFile file) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      FormData formData;

      if (kIsWeb) {
        Uint8List fileBytes = file.bytes!;
        formData = FormData.fromMap({
          'document': MultipartFile.fromBytes(fileBytes, filename: file.name),
        });
      } else {
        formData = FormData.fromMap({
          'document': await MultipartFile.fromFile(
            file.path!,
            filename: file.name,
          ),
        });
      }

      Response response = await dio.post(
        '$baseUrl/messaging/upload/document',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        print("audio uploaded successfully!");
        print(response);
        print("Media Key: ${response.data['mediaKey']}");
        print("Signed URL: ${response.data['signedUrl']}");
        return {
          "signedUrl": response.data['signedUrl'],
          "mediaKey": response.data['mediaKey'],
          "fileType": "file",
        };
      } else {
        print("Failed to upload audio: ${response.statusMessage}");
        throw Exception("Failed to upload audio: ${response.statusMessage}");
      }
    } on DioException catch (dioError) {
      print(
          'Error uploading audio: ${dioError.response?.data['message'] ?? dioError.message}');
      throw Exception(
          'Error uploading audio: ${dioError.response?.data['message'] ?? dioError.message}');
    } catch (error) {
      throw Exception('Unexpected error: $error');
    }
  }
}
