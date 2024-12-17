import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/features/profile/data/models/contacts_toblock_model.dart';
import 'package:telegrammy/features/profile/data/repos/profile_repo.dart';
import 'package:telegrammy/features/profile/data/models/blocked_user_model.dart';
import 'package:telegrammy/features/profile/data/repos/profile_repo_implemention.dart';
import 'package:telegrammy/features/profile/presentation/view_models/blocked_users_cubit/blocked_users_state.dart';
import 'package:telegrammy/cores/services/service_locator.dart';

class BlockedUsersCubit extends Cubit<BlockedUsersState> {
  final ProfileRepo profileRepo = getit.get<ProfileRepoImplementation>();

  BlockedUsersCubit() : super(BlockedUsersInitial());

  Future<void> loadBlockedUsers() async {
    emit(BlockedUsersLoading());
    final Either<Failure, BlockedUsersResponse> response =
        await profileRepo.getBlockedUser();

    response.fold(
      (failure) => emit(BlockedUsersError(message: _mapFailureToMessage(failure))),
      (blockedUsersResponse) => emit(BlockedUsersLoaded(blockedUsers: blockedUsersResponse.data)),
    );
  }

  Future<void> updateBlockedUsers(String userId) async {
    emit(BlockedUsersUpdating());
    final Either<Failure, BlockedUsersResponse> response =
        await profileRepo.getBlockedUser();

    response.fold(
      (failure) => emit(BlockedUsersError(message: _mapFailureToMessage(failure))),
      (blockedUsersResponse) => emit(BlockedUsersUpdated(blockedUsers: blockedUsersResponse.data)),
    );
  }

  //   Future<void> blockUser(String userId) async {
  //   emit(BlockedUsersUpdating());
  //   final Either<Failure, void> response =
  //       await profileRepo.updateBlockingStatus("block", userId);

  //   response.fold(
  //     (failure) => emit(BlockedUsersError(message: _mapFailureToMessage(failure))),
  //     (_) async {
  //       await loadBlockedUsers(); // Refresh blocked users list after action
  //       emit(BlockedUsersBlockAction());
  //     },
  //   );
  // }

  // Unblock a user
Future<void> unblockUser(String userId) async {
  emit(BlockedUsersUpdating());
  final Either<Failure, void> response =
      await profileRepo.updateBlockingStatus('unblock', userId);

  response.fold(
    (failure) {
      // Emit error state if unblocking fails
      emit(BlockedUsersError(message: _mapFailureToMessage(failure)));
    },
    (_) async {
      // Reload the blocked users list to reflect changes
      final Either<Failure, BlockedUsersResponse> blockedUsersResponse =
          await profileRepo.getBlockedUser();

      blockedUsersResponse.fold(
        (failure) {
          emit(BlockedUsersError(message: _mapFailureToMessage(failure)));
        },
        (success) {
          emit(BlockedUsersLoaded(blockedUsers: success.data));
        },
      );
    },
  );
}

  // Utility to map Failure to a human-readable message
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerError) {
      return failure.errorMessage ?? "Server Error occurred.";
    } else {
      return "An unexpected error occurred.";
    }
  }
}

class ContactstoCubit extends Cubit<ContactstoState> {
  final ProfileRepo profileRepo = getit.get<ProfileRepoImplementation>();

  ContactstoCubit() : super(ContactsInitial());

  /// Load contacts from the repository
  Future<void> loadContacts() async {
    emit(ContactsLoading());
    final Either<Failure, ContactsResponse> response =
        await profileRepo.getContacts();

    response.fold(
      (failure) => emit(ContactsError(message: _mapFailureToMessage(failure))),
      (contactsResponse) =>
          emit(ContactsLoaded(contacts: contactsResponse.contacts)),
    );
  }

  /// Block a user and reload the contacts
  Future<void> blockUser(String userId) async {
    try {
      print(userId);
      emit(ContactsLoading()); // Optional: Indicate loading when blocking
      final Either<Failure, void> response =
          await profileRepo.updateBlockingStatus("block", userId);

      response.fold(
        (failure) {
          emit(ContactsError(message: _mapFailureToMessage(failure)));
        },
        (_) async {
          // After successful block, reload the contacts and indicate the action
          await loadContacts(); // Reload contacts after block action
        },
      );
    } catch (e) {
      emit(ContactsError(message: "An unexpected error occurred."));
    }
  }

  // Utility to map Failure to a human-readable message
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerError) {
      return failure.errorMessage ?? "Server Error occurred.";
    } else {
      return "An unexpected error occurred.";
    }
  }
}

