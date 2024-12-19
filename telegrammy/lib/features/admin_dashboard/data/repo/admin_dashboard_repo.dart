import 'package:dartz/dartz.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/features/admin_dashboard/data/models/registered_users_model.dart';


abstract class AdminDashboardRepo {
  Future<Either<Failure, RegisteredUsersResponse>>  getRegisteredUsers();
  Future<Either<Failure, void>> banOrUnbanUser(bool isBanned,String userId);
}
