import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegrammy/features/profile/data/models/profile_info_model.dart';
import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_state.dart';

import '../../../../../cores/errors/Failture.dart';
import '../../../../../cores/services/service_locator.dart';
import '../../../data/repos/profile_repo.dart';
import '../../../data/repos/profile_repo_implemention.dart';

class ProfileSettingsCubit extends Cubit<ProfileSettingsState> {
  final ProfileRepo profileRepo = getit.get<ProfileRepoImplementation>();

  ProfileSettingsCubit() : super(ProfileInitial()) {
    loadBasicProfileInfo();
  }

  Future<void> loadBasicProfileInfo() async {
    emit(ProfileLoading());
    final Either<Failure, ProfileInfoResponse> result =
        await profileRepo.getProfileInfo();
    result.fold(
      (failure) => emit(
          ProfileError(errorMessage: failure.errorMessage)), // Emit error state
      (ProfileInfoResponse) => emit(ProfileLoaded(
          profileInfo: ProfileInfoResponse.data)), // Emit loaded state
    );
  }

  Future<void> updateBasicProfileInfo(
      {String? screenName, String? userName, String? bio}) async {
    if (state is ProfileLoaded) {
      final ProfileInfo newProfileInfo = ProfileInfo(
        screenName: screenName,
        bio: bio,
        lastSeen: DateTime.now(),
      );
      final profileInfo = (state as ProfileLoaded).profileInfo;

      profileInfo.screenName = screenName;
      profileInfo.bio = bio!;
      profileInfo.lastSeen = DateTime.now();

      final result = await profileRepo.updateProfileInfo(newProfileInfo);

      result.fold(
        (failure) => emit(ProfileError(errorMessage: failure.errorMessage)),
        (_) => emit(ProfileLoaded(profileInfo: profileInfo)),
      );
    }
  }

  Future<void> updateUserStatus(String status) async {
    if (state is ProfileLoaded) {
      final profileInfo = (state as ProfileLoaded).profileInfo;

      final result = await profileRepo.updateUserActivityStatus(status);
      result.fold(
          (failure) => emit(ProfileError(errorMessage: failure.errorMessage)),
          (_) {
        profileInfo.status = status;
        emit(ProfileLoaded(profileInfo: profileInfo));
      });
    }
  }

  Future<bool> updateUserEmail(String email) async {
    bool success = true;
    if (state is ProfileLoaded) {
      final profileInfo = (state as ProfileLoaded).profileInfo;
      final result = await profileRepo.updateUserEmail(email);
      result.fold((failure) => success = false, (_) {
        profileInfo.email = email;
        emit(ProfileLoaded(profileInfo: profileInfo));
        success = true;
      });
    }
    return success;
  }

  Future<bool> updateUsername(String username) async {
    bool success = true;
    if (state is ProfileLoaded) {
      final profileInfo = (state as ProfileLoaded).profileInfo;
      final result = await profileRepo.updateUsername(username);
      result.fold((failure) => success = false, (_) {
        profileInfo.username = username;
        emit(ProfileLoaded(profileInfo: profileInfo));
        success = true;
      });
    }
    return success;
  }

  Future<bool> updateUserPhoneNumber(String phoneNumber) async {
    bool success = true;
    if (state is ProfileLoaded) {
      final profileInfo = (state as ProfileLoaded).profileInfo;
      final result = await profileRepo.updateUserPhoneNumber(phoneNumber);
      result.fold((failure) => success = false, (_) {
        profileInfo.phoneNumber = phoneNumber;
        emit(ProfileLoaded(profileInfo: profileInfo));
        success = true;
      });
    }
    return success;
  }

  Future<XFile?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  Future<void> updateProfilePicture() async {
    if (state is ProfileLoaded) {
      final pickedFile = await pickImage();
      if (pickedFile != null) {
        ProfileInfo profileInfo = (state as ProfileLoaded).profileInfo;
        print('hello from cubit');
        final result = await profileRepo.updateProfilePicture(pickedFile);
        result.fold((failure) {
          print('hello from cubit failure');
          emit(ProfileError(errorMessage: failure.errorMessage));
        }, (ProfilePictureResponse) {
          profileInfo.profilePic = ProfilePictureResponse.imageUrl;
          emit(ProfileLoaded(profileInfo: profileInfo));
        });
      }
    }
  }

  Future<void> deleteProfilePicture() async {
    if (state is ProfileLoaded) {
      ProfileInfo profileInfo = (state as ProfileLoaded).profileInfo;
      final result = await profileRepo.deleteProfilePicture();
      result.fold(
          (failure) => emit(ProfileError(errorMessage: failure.errorMessage)),
          (_) {
        profileInfo.profilePic = null;
        emit(ProfileLoaded(profileInfo: profileInfo));
      });
    }
  }

  Future<void> addStory() async {
    final pickedFile = await pickImage();

    if (pickedFile != null) {
      // User user = (state as ProfileLoaded).user;
      // user.stories.add(File(pickedFile.path));
      // emit(ProfileLoaded(user: user));
    }
  }

  void removeStory(File storyToRemove) {
    if (state is ProfileLoaded) {
      // User user = (state as ProfileLoaded).user;
      // user.stories.remove(storyToRemove);
      // emit(ProfileLoaded(user: user));
    }
  }
}
