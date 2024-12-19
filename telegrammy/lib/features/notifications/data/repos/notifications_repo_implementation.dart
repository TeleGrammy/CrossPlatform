import 'package:dartz/dartz.dart';
import 'package:telegrammy/cores/errors/Failture.dart';

import 'package:telegrammy/cores/services/notfications_api_service.dart';
import 'package:telegrammy/features/notifications/data/repos/notifications_repo.dart';




class NotificationsRepoImplementation extends  NotificationsRepo {
  final NotificationsApiService notificationsApiService;

  NotificationsRepoImplementation({required this.notificationsApiService});





  @override
  Future<Either<Failure, void>>  muteNotifications(String chatId) async {
  try {

    await notificationsApiService.muteNotifications(chatId);

    return const Right(null);
  } catch (error) {
    
   
    return Left(ServerError(errorMessage: error.toString()));
  }
  }

 
@override
Future<Either<Failure, void>> unmuteNotifications(String chatId) async {
  try {

    await notificationsApiService.unmuteNotifications(chatId);

    return const Right(null);
  } catch (error) {
    
   
    return Left(ServerError(errorMessage: error.toString()));
  }
}
}
