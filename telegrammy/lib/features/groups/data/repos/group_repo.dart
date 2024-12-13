import 'package:dartz/dartz.dart';
import '../../../../cores/errors/Failure.dart';

abstract class GroupRepo {
  //Future<Either<Failure, void>> createGroup() async {}
  Future<void> deleteGroup() async {}
  Future<void> leaveGroup() async {}

  Future<void> addAdminToGroup() async {}
  Future<void> addUsersToGroup() async {}

  Future<void> setMessagingPermissions() async {}
  Future<void> setMediaDownloadPermissions() async {}
  Future<void> setGroupPrivacy() async {}
}
