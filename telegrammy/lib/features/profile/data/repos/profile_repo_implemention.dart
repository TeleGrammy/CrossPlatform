import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/cores/services/profile_api_service.dart';
import 'package:telegrammy/features/profile/data/models/blocked_user_model.dart';
import 'package:telegrammy/features/profile/data/models/contacts_toblock_model.dart';
import 'package:telegrammy/features/profile/data/models/settings_user_model.dart';
import 'package:telegrammy/features/profile/data/models/stories_model.dart';
import 'package:telegrammy/features/profile/data/repos/profile_repo.dart';
import 'package:telegrammy/features/profile/data/models/profile_visibility_model.dart';

import '../models/profile_info_model.dart';

class ProfileRepoImplementation extends ProfileRepo {
  final ProfileApiService profileApiService;

  ProfileRepoImplementation({required this.profileApiService});

  // @override
  // Future<Either<Failure, ProfileVisibility>> fetchProfileVisibility() async {
  //   try {
  //     // Fetch the profile visibility from the API service
  //     final profileVisibility = await profileApiService.fetchProfileVisibility();
  //     return Right(profileVisibility); // Successful fetch
  //   } catch (error) {
  //     // Handle the error and return a failure
  //     return Left(ServerError(errorMessage: error.toString()));
  //   }
  // }



@override
Future<Either<Failure, BlockedUsersResponse>> getBlockedUser() async {
  try {
    // print('salma');
    // Call the API service to get blocked users
    final blockedUsersResponse = await profileApiService.getBlockedUsers();
    
    return Right(blockedUsersResponse); // Successful response
  } catch (error) {
    // print('error');
    // Handle the error and return a failure
    return Left(ServerError(errorMessage: error.toString()));
  }
}
@override
Future<Either<Failure, ContactsResponse>> getContacts() async {
  try {
    // print('salma');
    // Call the API service to get blocked users
    final contactsResponse = await profileApiService.getContacts();
    
    return Right(contactsResponse); // Successful response
  } catch (error) {
    // print('error');
    // Handle the error and return a failure
    return Left(ServerError(errorMessage: error.toString()));
  }
}
@override
Future<Either<Failure, void>> updateBlockingStatus(String action, String userId) async {
  try {
    // Call the API service to update the blocking status
    await profileApiService.updateBlockingStatus(action, userId);

    // Return success (void) as a Right value
    return const Right(null);
  } catch (error) {
    // Handle the error and return a failure
   
    return Left(ServerError(errorMessage: error.toString()));
  }
}
@override
Future<Either<Failure, void>> updateReadReceiptsStatus(bool isEnabled) async {
  try {
    // Call the API service to update the blocking status
    await profileApiService.updateReadReceiptsStatus(isEnabled);

    // Return success (void) as a Right value
    return const Right(null);
  } catch (error) {
    // Handle the error and return a failure
   
    return Left(ServerError(errorMessage: error.toString()));
  }
}

///////////////////////////////////////////
  @override
  Future<Either<Failure, StoryResponse>> getUserStories() async {
    try {
      // Call the API service to get user stories
      final storyResponse = await profileApiService.getUserStories();
      return Right(storyResponse); // Successful response
    } catch (error) {
      // Handle the error and return a failure
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

@override
Future<Either<Failure, UserPrivacySettingsResponse>> getUserSettings() async {
  try {
    // Call the API service to get user privacy settings
    final userSettingsResponse = await profileApiService.getUserSettings();
    return Right(userSettingsResponse); // Successful response
  } catch (error) {
    // Handle the error and return a failure
    return Left(ServerError(errorMessage: error.toString()));
  }
}

@override
Future<Either<Failure, void>> updateProfileVisibility(ProfileVisibility profileVisibility) async {
  try {
    // Call the API service to update the user profile visibility
    await profileApiService.updateProfileVisibility(profileVisibility);
    return const Right(null); // Successful response (void)
  } catch (error) {
    // Handle the error and return a failure
    return Left(ServerError(errorMessage: error.toString()));
  }
}


  Future<Either<Failure, void>> createStory(StoryCreation storyCreation) async {
    try {
      // Call the API service to create a new story
      await profileApiService.createStory(storyCreation);
      return const Right(null); // Successful creation
    } catch (error) {
      // Handle the error and return a failure
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStory(String storyId) async {
    try {
      await profileApiService.deleteStory(storyId);
      return const Right(null); // Successful deletion
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileInfoResponse>> getProfileInfo() async {
    try {
      final ProfileInfoResponse = await profileApiService.getProfileInfo();
      print(ProfileInfoResponse);
      return Right(ProfileInfoResponse);
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfileInfo(
      ProfileInfo profileInfo) async {
    try {
      await profileApiService.updateProfileInfo(profileInfo);
      return const Right(null);
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserActivityStatus(String status) async {
    try {
      print(status);
      await profileApiService.updateUserActivityStatus(status);
      return const Right(null);
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserEmail(String email) async {
    try {
      await profileApiService.updateUserEmail(email);
      return const Right(null);
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUsername(String username) async {
    try {
      await profileApiService.updateUsername(username);
      return const Right(null);
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserPhoneNumber(
      String phoneNumber) async {
    try {
      await profileApiService.updateUserPhoneNumber(phoneNumber);
      return const Right(null);
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfilePictureResponse>> updateProfilePicture(
      XFile pickedFile) async {
    try {
      print('hello from repo');
      final profilePictureResponse =
          await profileApiService.updateProfilePic(pickedFile);
      return Right(profilePictureResponse);
    } catch (error) {
      print('hello from repo failure');
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfilePicture() async {
    try {
      final profilePictureResponse =
          await profileApiService.deleteProfilePicture();
      return const Right(null);
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }
}
