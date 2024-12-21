import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/data/models/media.dart';

abstract class MessagesRepo {
  Future<Map<String,dynamic>> getChats({int page=1});
    Future<Map<String, dynamic>> getMessages({required String chatId});
  Future<Either<Failure, dynamic>> uploadMedia(XFile image);
  Future<Either<Failure, Media>> uploadAudio(String filePath);
}
