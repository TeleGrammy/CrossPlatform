import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegrammy/features/groups/data/models/group.dart';
import '../../../../cores/errors/Failture.dart';

abstract class GroupRepo {
  Future<void> deleteGroup() async {}
  Future<void> leaveGroup() async {}

  Future<void> addAdminToGroup() async {}
  Future<void> addUsersToGroup() async {}

  Future<void> setMessagingPermissions() async {}
  Future<void> setMediaDownloadPermissions() async {}

  Future<Group> getGroupInfo(String groupId);
  Future<Either<Failure, void>> updateBasicGroupInfo(
      String groupId, String name, String description);
  Future<Either<Failure, Group>> updateGroupPicture(
      String groupId, XFile pickedFile);
  Future<Either<Failure, void>> deleteGroupPicture(String groupId);
  Future<Either<Failure, String>> updateGroupPrivacy(
      String groupId, String privacyOption);
  Future<Either<Failure, void>> updateGroupSizeLimit(
      String groupId, int sizeLimit);
}
