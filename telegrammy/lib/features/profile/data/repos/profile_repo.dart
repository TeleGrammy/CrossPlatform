import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/features/profile/data/models/blocked_user_model.dart';
import 'package:telegrammy/features/profile/data/models/profile_info_model.dart';
import 'package:telegrammy/features/profile/data/models/contacts_toblock_model.dart';
import 'package:telegrammy/features/profile/data/models/profile_visibility_model.dart';
import 'package:telegrammy/features/profile/data/models/settings_user_model.dart';
import 'package:telegrammy/features/profile/data/models/stories_model.dart';

abstract class ProfileRepo {
  // Future<Either<Failure, ProfileVisibility>> fetchProfileVisibility();

  Future<Either<Failure, BlockedUsersResponse>> getBlockedUser();
  Future<Either<Failure, ContactsResponse>> getContacts();
  Future<Either<Failure, StoryResponse>> getUserStories();
  Future<Either<Failure, void>> createStory(StoryCreation storyCreation);
  Future<Either<Failure, void>> deleteStory(String userId);
  Future<Either<Failure, void>> updateProfileInfo(ProfileInfo profileInfo);
  Future<Either<Failure, ProfileInfoResponse>> getProfileInfo();

  Future<Either<Failure, void>> updateUserActivityStatus(String status);
  Future<Either<Failure, void>> updateUserEmail(String email);
  Future<Either<Failure, void>> updateUsername(String username);
  Future<Either<Failure, void>> updateUserPhoneNumber(String phoneNumber);
  Future<Either<Failure, ProfilePictureResponse>> updateProfilePicture(
      XFile pickedFile);
  Future<Either<Failure, void>> deleteProfilePicture();
  Future<Either<Failure, UserPrivacySettingsResponse>> getUserSettings();
  Future<Either<Failure, void>> updateBlockingStatus(
      String action, String userId);
  Future<Either<Failure, void>> updateProfileVisibility(
      ProfileVisibility profileVisibility);
  Future<Either<Failure, void>> updateReadReceiptsStatus(bool isEnabled);
}
