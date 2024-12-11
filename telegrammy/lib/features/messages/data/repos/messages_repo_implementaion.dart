import 'package:image_picker/image_picker.dart';
import 'package:dartz/dartz.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/cores/services/auth_api_service.dart';
import 'package:telegrammy/cores/services/messaging_api_service.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:telegrammy/features/messages/data/repos/messages_repo.dart';

class MessagesRepoImplementaion extends MessagesRepo {
  MessagingApiService apiService=MessagingApiService();

  @override
  Future<List<Contact>> getChats({int page = 1}) async {
    return await getit.get<ApiService>().fetchChats();
  }

  @override
  Future<Either<Failure,dynamic>> sendMedia(XFile mediaFile) async{
    try {
      dynamic data=await apiService.sendMedia(mediaFile);
      return Right(data); 
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }
  
  @override
  Future<Either<Failure, dynamic>> sendAudio(String filePath)async {
    try {
      dynamic data=await apiService.sendAudio(filePath);
      return Right(data); 
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }
}
