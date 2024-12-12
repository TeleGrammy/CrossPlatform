import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/data/models/media.dart';

abstract class MessagesRepo {
  Future<Either<Failure, dynamic>> sendMedia(XFile image);
  Future<Either<Failure, dynamic>> sendAudio(String filePath);
  Future<List<Chat>> getChats({int page=1});
  Future<Map<String, dynamic>> getMessages({required String chatId});
  Future<Media>uploadMedia(audioPath);
}
