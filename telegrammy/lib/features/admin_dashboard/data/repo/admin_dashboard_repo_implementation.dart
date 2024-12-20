import 'package:dartz/dartz.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/cores/services/admin_dashboard_api_service.dart';
import 'package:telegrammy/features/admin_dashboard/data/models/groups_dashboard_model.dart';
import 'package:telegrammy/features/admin_dashboard/data/models/registered_users_model.dart';

import 'package:telegrammy/features/admin_dashboard/data/repo/admin_dashboard_repo.dart';


class AdminDashboardRepoImplementation extends AdminDashboardRepo {
  final AdminDashboardApiService adminDashboardApiService;

  AdminDashboardRepoImplementation({required this.adminDashboardApiService});





  @override
  Future<Either<Failure, RegisteredUsersResponse>>  getRegisteredUsers() async {
    try {
      // print('salma');
      // Call the API service to get blocked users
      final registeredUsersResponse = await adminDashboardApiService. getRegisteredUsers();
      // print(registeredUsersResponse);
      return Right(registeredUsersResponse); // Successful response
    } catch (error) {
      // print('error');
      // Handle the error and return a failure
      return Left(ServerError(errorMessage: error.toString()));
    }
  }
  
  @override
  Future<Either<Failure, GroupDataResponse>>  getGroups() async {
    try {
      // print('salma');
      // Call the API service to get blocked users
      final groupDataResponse = await adminDashboardApiService.getGroups() ;
      // print(registeredUsersResponse);
      return Right(groupDataResponse); // Successful response
    } catch (error) {
      // print('error');
      // Handle the error and return a failure
      return Left(ServerError(errorMessage: error.toString()));
    }
  }


 
@override
Future<Either<Failure, void>> banOrUnbanUser(String isBanned, String userId) async {
  try {
    // Call the API service to update the blocking status
    print(isBanned);
    await adminDashboardApiService.banOrUnbanUser(isBanned, userId);

    // Return success (void) as a Right value
    return const Right(null);
  } catch (error) {
    // Handle the error and return a failure
   
    return Left(ServerError(errorMessage: error.toString()));
  }
}
@override
Future<Either<Failure, void>> filterMediaGroup(bool isBanned, String userId) async {
  try {
    // Call the API service to update the blocking status
    await adminDashboardApiService.filterMediaGroup(isBanned, userId);

    // Return success (void) as a Right value
    return const Right(null);
  } catch (error) {
    // Handle the error and return a failure
   
    return Left(ServerError(errorMessage: error.toString()));
  }
}
}
