import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/features/profile/data/repos/profile_repo.dart';
import 'package:telegrammy/features/profile/data/models/profile_visibility_model.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/features/profile/data/repos/profile_repo_implemention.dart';
import 'privacy_state.dart';


class PrivacySettingsCubit extends Cubit<PrivacyState> {
  final ProfileRepo profileRepo = getit.get<ProfileRepoImplementation>();

    PrivacySettingsCubit() : super(PrivacyInitial()) {
    fetchPrivacySettings(); // Call fetchPrivacySettings upon initialization
  }

  Future<void> fetchPrivacySettings() async {
  try {
    final defaultProfileVisibility = ProfileVisibility(
      profilePicture: 'everyone',
      stories: 'everyone',
      lastSeen: 'everyone',
    );

    print('Fetched Privacy Settings: $defaultProfileVisibility'); // Debug print
    emit(PrivacyOptionsLoaded(privacyOptions: defaultProfileVisibility));
  } catch (e) {
    emit(PrivacyOptionsError(message: "Failed to load privacy settings."));
  }
}


  Future<void> updatePrivacySettings(ProfileVisibility updatedVisibility) async {
    emit(PrivacyUpdating());
    final result = await profileRepo.updateProfileVisibility(updatedVisibility);
    result.fold(
      (failure) => emit(PrivacyOptionsError(message: failure.errorMessage)),
      (_) => emit(PrivacyOptionsUpdated(privacyOptions: updatedVisibility)),
    );
  }

  Future<void> updatePrivacyOption(String optionKey, PrivacyOption selectedValue) async {
    if (state is PrivacyOptionsLoaded) {
      final currentVisibility = (state as PrivacyOptionsLoaded).privacyOptions;

      final updatedVisibility = ProfileVisibility(
        profilePicture: optionKey == 'profilePicture' ? selectedValue.name : currentVisibility.profilePicture,
        stories: optionKey == 'stories' ? selectedValue.name : currentVisibility.stories,
        lastSeen: optionKey == 'lastSeen' ? selectedValue.name : currentVisibility.lastSeen,
      );

      await updatePrivacySettings(updatedVisibility);
    }
  }
}
////////////////////////////////////////
///
// class SecurityCubit extends Cubit<SecurityState> {
//   SecurityCubit() : super(SecurityInitial()) {
//     _loadBlockedUsers();
//   }

//   void _loadBlockedUsers() {
//     final blockedUsers = <User>[];
//     emit(BlockedUsersLoaded(blockedUsers: blockedUsers));
//   }

//   void addBlockedUser(User user) {
//     if (state is BlockedUsersLoaded) {
//       final updatedBlockedUsers = List<User>.from((state as BlockedUsersLoaded).blockedUsers)
//         ..add(user.copyWith(isBlocked: true));
//       emit(BlockedUsersLoaded(blockedUsers: updatedBlockedUsers));
//     }
//   }

//   void removeBlockedUser(int userId) {
//     if (state is BlockedUsersLoaded) {
//       final updatedBlockedUsers = (state as BlockedUsersLoaded).blockedUsers
//           .where((user) => user.id != userId)
//           .toList();
//       emit(BlockedUsersLoaded(blockedUsers: updatedBlockedUsers));
//     }
//   }
// }