import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/features/profile/data/models/settings_user_model.dart';
import 'package:telegrammy/features/profile/data/repos/profile_repo.dart';
import 'package:telegrammy/features/profile/data/models/profile_visibility_model.dart';

import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/features/profile/data/repos/profile_repo_implemention.dart';
import 'privacy_state.dart';

class PrivacySettingsCubit extends Cubit<PrivacyState> {
  final ProfileRepo profileRepo = getit.get<ProfileRepoImplementation>();

  PrivacySettingsCubit() : super(PrivacyLoading()) {
    fetchPrivacySettings(); // Fetch privacy settings on initialization
  }

  // Fetch privacy settings from the API
  Future<void> fetchPrivacySettings() async {
    try {
      emit(PrivacyLoading()); // Emit loading state while fetching

      final result = await profileRepo.getUserSettings();
      result.fold(
        (failure) => emit(PrivacyOptionsError(message: failure.errorMessage)),
        (userSettings) {
          final privacyOptions = _mapUserPrivacySettingsToProfileVisibility(userSettings);
          emit(PrivacyOptionsLoaded(privacyOptions: privacyOptions)); // Emit loaded state with privacy options
        },
      );
    } catch (e) {
      emit(PrivacyOptionsError(message: "Failed to load privacy settings.")); // Handle unexpected errors
    }
  }

  // Map the UserPrivacySettingsResponse to ProfileVisibility model
  ProfileVisibility _mapUserPrivacySettingsToProfileVisibility(UserPrivacySettingsResponse userSettings) {
    return ProfileVisibility(
      profilePicture: userSettings.data.profilePictureVisibility,
      stories: userSettings.data.storiesVisibility,
      lastSeen: userSettings.data.lastSeenVisibility,
    );
  }

  // Update the entire profile visibility
  Future<void> updatePrivacySettings(ProfileVisibility updatedVisibility) async {
    emit(PrivacyUpdating()); // Emit updating state while privacy settings are being updated
    final result = await profileRepo.updateProfileVisibility(updatedVisibility);
    result.fold(
      (failure) => emit(PrivacyOptionsError(message: failure.errorMessage)),
      (_) => emit(PrivacyOptionsUpdated(privacyOptions: updatedVisibility)),
    );
  }

  // Update a specific privacy option (profile picture, stories, last seen)
  Future<void> updatePrivacyOption(String optionKey, PrivacyOption selectedValue) async {
    if (state is PrivacyOptionsLoaded) {
      final currentVisibility = (state as PrivacyOptionsLoaded).privacyOptions;

      // Create a new ProfileVisibility object with the updated privacy option
      final updatedVisibility = ProfileVisibility(
        profilePicture: optionKey == 'profilePicture' 
            ? _mapPrivacyOptionToString(selectedValue) 
            : currentVisibility.profilePicture,
        stories: optionKey == 'stories' 
            ? _mapPrivacyOptionToString(selectedValue) 
            : currentVisibility.stories,
        lastSeen: optionKey == 'lastSeen' 
            ? _mapPrivacyOptionToString(selectedValue) 
            : currentVisibility.lastSeen,
      );

      await updatePrivacySettings(updatedVisibility); // Update privacy settings after modifying one option
    }
  }


  // Helper method to map PrivacyOption to string values
  String _mapPrivacyOptionToString(PrivacyOption option) {
    switch (option) {
      case PrivacyOption.everyone:
        return 'EveryOne';  // Ensure the backend expects 'EveryOne', not 'Everyone'
      case PrivacyOption.contacts:
        return 'Contacts';
      case PrivacyOption.nobody:
        return 'Nobody';
      default:
        return 'EveryOne'; // Default case
    }
  }
}


////////////////////////////////////////
class ReadReceiptCubit extends Cubit<ReadReceiptState> {
  final ProfileRepo profileRepo = getit.get<ProfileRepoImplementation>();

  ReadReceiptCubit() : super(ReadReceiptsLoading()) {
    fetchReadReceiptSetting(); // Fetch the read receipt setting when the cubit is initialized
  }

  // Fetch the current read receipt setting
  Future<void> fetchReadReceiptSetting() async {
    try {
      emit(ReadReceiptsLoading()); // Emit loading state while fetching the data

      final result = await profileRepo.getUserSettings();
      result.fold(
        (failure) => emit(ReadReceiptsError(message: failure.errorMessage)), // Emit error state if the request fails
        (userSettings) {
          final readReceiptSetting = _mapReadReceiptToSetting(userSettings);
          emit(ReadReceiptsLoaded(isEnabled: readReceiptSetting)); // Emit loaded state with the current setting
        },
      );
    } catch (e) {
      emit(ReadReceiptsError(message: "Failed to load read receipt settings.")); // Emit error if an exception occurs
    }
  }

  // Update the read receipt setting (enable or disable)
  Future<void> updateReadReceiptSetting(bool enable) async {
    try {
      emit(ReadReceiptsUpdating()); // Emit updating state while updating the setting

      final result = await profileRepo.updateReadReceiptsStatus(enable);
      result.fold(
        (failure) => emit(ReadReceiptsError(message: failure.errorMessage)), // Emit error state if the request fails
        (success) {
          emit(ReadReceiptsUpdated(isEnabled: enable)); // Emit updated state if the setting is updated successfully
          
          // Fetch the updated state immediately after the update
          fetchReadReceiptSetting(); // This will ensure UI gets the most recent state
        },
      );
    } catch (e) {
      emit(ReadReceiptsError(message: "Failed to update read receipt settings.")); // Emit error if an exception occurs
    }
  }

  // Helper method to map user settings to the read receipt state
  bool _mapReadReceiptToSetting(UserPrivacySettingsResponse userSettings) {
    return userSettings.data.readReceipts; // Assuming readReceipts is a boolean in the response
  }
}

