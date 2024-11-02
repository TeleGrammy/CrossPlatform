import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'privacy_state.dart';


class PrivacySettingsCubit extends Cubit<PrivacyState> {
  PrivacySettingsCubit() : super(PrivacyInitial()) {
    loadPrivacyOptions(); // Load privacy options during initialization
  }

  void loadPrivacyOptions() {
    final initialOptions = {
      'Last Seen': PrivacyOption.everyone,
      'Profile Photo': PrivacyOption.everyone,
      'Stories': PrivacyOption.everyone,
      'Groups': PrivacyOption.everyone,
    };

    emit(PrivacyOptionsLoaded(privacyOptions: initialOptions));
  }

  
  void updatePrivacyOption(String optionKey, PrivacyOption selectedValue) {
    if (state is PrivacyOptionsLoaded) {
      final currentOptions = (state as PrivacyOptionsLoaded).privacyOptions;

     
      currentOptions[optionKey] = selectedValue;

      emit(PrivacyOptionsLoaded(
        privacyOptions: currentOptions,
       
      ));
    }
  }
}
////////////////////////////////////////
///
class SecurityCubit extends Cubit<SecurityState> {
  SecurityCubit() : super(SecurityInitial()) {
    _loadBlockedUsers();
  }

  void _loadBlockedUsers() {
    final blockedUsers = <User>[];
    emit(BlockedUsersLoaded(blockedUsers: blockedUsers));
  }

  void addBlockedUser(User user) {
    if (state is BlockedUsersLoaded) {
      final updatedBlockedUsers = List<User>.from((state as BlockedUsersLoaded).blockedUsers)
        ..add(user.copyWith(isBlocked: true));
      emit(BlockedUsersLoaded(blockedUsers: updatedBlockedUsers));
    }
  }

  void removeBlockedUser(int userId) {
    if (state is BlockedUsersLoaded) {
      final updatedBlockedUsers = (state as BlockedUsersLoaded).blockedUsers
          .where((user) => user.id != userId)
          .toList();
      emit(BlockedUsersLoaded(blockedUsers: updatedBlockedUsers));
    }
  }
}