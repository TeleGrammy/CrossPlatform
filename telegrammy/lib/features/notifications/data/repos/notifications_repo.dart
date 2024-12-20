import 'package:dartz/dartz.dart';
import 'package:telegrammy/cores/errors/Failture.dart';



abstract class NotificationsRepo {
  Future<Either<Failure, void>>  muteNotifications(String chatId);
  Future<Either<Failure, void>> unmuteNotifications(String chatId);
}
