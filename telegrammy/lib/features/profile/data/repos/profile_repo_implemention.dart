import 'package:dartz/dartz.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/cores/services/profile_api_service.dart';
import 'package:telegrammy/features/profile/data/models/blocked_user_model.dart';
import 'package:telegrammy/features/profile/data/models/stories_model.dart';
import 'package:telegrammy/features/profile/data/repos/profile_repo.dart';
import 'package:telegrammy/features/profile/data/models/profile_visibility_model.dart';

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
  Future<Either<Failure, void>> updateProfileVisibility(ProfileVisibility profileVisibility) async {
    try {
      // Call the API service to update profile visibility
      await profileApiService.updateProfileVisibility(profileVisibility);
      return const Right(null); // Successful update
    } catch (error) {
      // Handle the error and return a failure
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

@override
Future<Either<Failure, BlockedUsersResponse>> getBlockedUser() async {
  try {
    // Call the API service to get blocked users
    final blockedUsersResponse = await profileApiService.getBlockedUsers();
    return Right(blockedUsersResponse); // Successful response
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


  
}