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

  // Utility to map Failure to a human-readable message
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerError) {
      return failure.errorMessage ?? "Server Error occurred.";
    } else {
      return "An unexpected error occurred.";
    }
  }
}

////////////////////////////////////////////
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

  // /// Update contact details
  // Future<void> updateContact(String contactId) async {
  //   emit(ContactsLoading());
  //   final Either<Failure, ContactsResponse> response =
  //       await profileRepo.updateContact(contactId);

  //   response.fold(
  //     (failure) => emit(ContactsError(message: _mapFailureToMessage(failure))),
  //     (contactsResponse) =>
  //         emit(ContactsLoaded(contacts: [contactsResponse.data])),
  //   );
  // }
  // Utility to map Failure to a human-readable message
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerError) {
      return failure.errorMessage ?? "Server Error occurred.";
    } else {
      return "An unexpected error occurred.";
    }
  }
}

