import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dartz/dartz.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/cores/services/auth_api_service.dart';
import 'package:telegrammy/cores/services/messaging_api_service.dart';
import 'package:telegrammy/cores/services/messages_api_service.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/data/models/media.dart';
import 'package:telegrammy/features/messages/data/repos/messages_repo.dart';
import 'package:mime/mime.dart';
import 'package:universal_html/html.dart';

class MessagesRepoImplementaion extends MessagesRepo {
  MessagingApiService apiService = MessagingApiService();

  @override
  Future<Map<String,dynamic>> getChats({int page = 1}) async {
    return await getit.get<ApiService>().fetchChats();
  }

  @override
  Future<Either<Failure, dynamic>> uploadMedia(dynamic mediaFile) async {
    try {
      String? fileType;
      if (!kIsWeb) {
        fileType = lookupMimeType(mediaFile.path);
      } else {
        fileType = lookupMimeType('', headerBytes: mediaFile.bytes);
      }

      if (fileType == null) {
        fileType = 'file';
      } else if (fileType.contains('image')) {
        fileType = 'image';
      } else if (fileType.contains('video')) {
        fileType = 'video';
      } else {
        fileType = 'file';
      }

      dynamic data;
      if (fileType == 'image' || fileType == 'video') {
        data = await apiService.uploadMedia(mediaFile, fileType);
      } else {
        data = await apiService.uploadFile(mediaFile);
      }
      return Right(data);
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure,Media>> uploadAudio(String filePath) async {
    try {
      dynamic data = await apiService.uploadAudio(filePath);
      return Right(data);
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  Future<Map<String, dynamic>> getMessages({required String chatId}) async {
    final result = await getit.get<MessagesApiService>().getMessages(chatId);
    return result.fold(
      (error) {
        // Handle the error case
        return {'error': error};
      },
      (data) {
        // Handle the success case
        return data;
      },
    );
  }
}
