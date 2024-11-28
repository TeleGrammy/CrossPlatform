// look at /features/auth/data/repos/auth_repo.dart
import 'package:dartz/dartz.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/features/profile/data/models/blocked_user_model.dart';
import 'package:telegrammy/features/profile/data/models/contacts_toblock_model.dart';
// import 'package:telegrammy/cores/models/user_model.dart';
import 'package:telegrammy/features/profile/data/models/profile_visibility_model.dart';
import 'package:telegrammy/features/profile/data/models/stories_model.dart';

abstract class ProfileRepo {
  // Future<Either<Failure, ProfileVisibility>> fetchProfileVisibility();
  Future<Either<Failure, void>> updateProfileVisibility(ProfileVisibility profileVisibility);
  Future<Either<Failure, BlockedUsersResponse>> getBlockedUser();
  Future<Either<Failure, ContactsResponse>> getContacts();
  Future<Either<Failure, StoryResponse>> getUserStories();
  Future<Either<Failure, void>> createStory(StoryCreation storyCreation);
  Future<Either<Failure, void>> deleteStory(String userId);  

}