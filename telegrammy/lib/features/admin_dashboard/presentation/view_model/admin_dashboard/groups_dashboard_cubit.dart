import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/cores/services/service_locator.dart';

import 'package:telegrammy/features/admin_dashboard/data/models/groups_dashboard_model.dart';
import 'package:telegrammy/features/admin_dashboard/data/repo/admin_dashboard_repo.dart';
import 'package:telegrammy/features/admin_dashboard/data/repo/admin_dashboard_repo_implementation.dart';
import 'package:telegrammy/features/admin_dashboard/presentation/view_model/admin_dashboard/groups_dashboard_state.dart';


class RegisteredGroupsCubit extends Cubit<RegisteredGroupsState> {
  final AdminDashboardRepo adminDashboardRepo = getit.get<AdminDashboardRepoImplementation>();

  RegisteredGroupsCubit() : super(RegisteredGroupsLoading());

  /// Load registered groups from the repository
  Future<void> loadRegisteredGroups() async {
    emit(RegisteredGroupsLoading());
    
    final Either<Failure, GroupDataResponse> response =
        await adminDashboardRepo.getGroups();

    response.fold(
      (failure) => emit(RegisteredGroupsError(message: _mapFailureToMessage(failure))),
      (groupDataResponse) =>
          emit(RegisteredGroupsLoaded(registeredGroups: groupDataResponse.data)), // Extract the 'data' from the response
    );
  }

  /// Filter media group (ban/unban or any action) and reload groups
  Future<void> filterMediaGroup(bool isBanned, String groupId) async {
    try {
      emit(RegisteredGroupsUpdating()); // Indicate updating status
      
      final Either<Failure, void> response =
          await adminDashboardRepo.filterMediaGroup(isBanned, groupId);

      response.fold(
        (failure) {
          emit(RegisteredGroupsError(message: _mapFailureToMessage(failure)));
        },
        (_) async {
          // After successful filter action, reload the groups and indicate the update
          await loadRegisteredGroups(); // Reload groups after the action
        },
      );
    } catch (e) {
      emit(RegisteredGroupsError(message: "An unexpected error occurred."));
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
