import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';

abstract class MessagesRepo {
  Future<List<Contact>> getChats({int page = 1});
  Future<Either<Failure, dynamic>> sendMedia(XFile image);
  Future<Either<Failure, dynamic>> sendAudio(String filePath);
}
