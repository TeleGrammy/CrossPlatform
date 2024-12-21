import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/errors/Failture.dart';

import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/features/admin_dashboard/data/models/registered_users_model.dart';
import 'package:telegrammy/features/admin_dashboard/data/repo/admin_dashboard_repo.dart';
import 'package:telegrammy/features/admin_dashboard/data/repo/admin_dashboard_repo_implementation.dart';
import 'package:telegrammy/features/admin_dashboard/presentation/view_model/admin_dashboard/admin_dashboard_state.dart';

class RegisteredUsersCubit extends Cubit<RegisteredUsersState> {
  final AdminDashboardRepo adminDashboardRepo = getit.get<AdminDashboardRepoImplementation>();

  RegisteredUsersCubit() : super(RegisteredUsersLoading());

  /// Load registered users from the repository
  Future<void> loadRegisteredUsers() async {
    emit(RegisteredUsersLoading());
    
    final Either<Failure, RegisteredUsersResponse> response =
        await adminDashboardRepo.getRegisteredUsers();

    response.fold(
      (failure) => emit(RegisteredUsersError(message: _mapFailureToMessage(failure))),
      (registeredUsersResponse) =>
          emit(RegisteredUsersLoaded(registeredUsers: registeredUsersResponse.data)), // Extract the 'data' from the response
    );
  }

  /// Block a user and reload the contacts
  Future<void> banorUnbanUser(String isBanned,String userId) async {
    try {
      print(userId);
      emit(RegisteredUsersLoading()); // Optional: Indicate loading when blocking
      final Either<Failure, void> response =
          await adminDashboardRepo.banOrUnbanUser(isBanned, userId);  // Example of banning a user

      response.fold(
        (failure) {
          emit(RegisteredUsersError(message: _mapFailureToMessage(failure)));
        },
        (_) async {
          // After successful block, reload the contacts and indicate the action
          await loadRegisteredUsers(); // Reload users after block action
        },
      );
    } catch (e) {
      emit(RegisteredUsersError(message: "An unexpected error occurred."));
    }
  }


  // Utility to map Failure to a human-readable message
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerError) {
      return failure.errorMessage;
    } else {
      return "An unexpected error occurred.";
    }
  }
}
