import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegrammy/cores/services/group_api_service.dart';
import '../../../../cores/errors/Failture.dart';
import '../models/group.dart';
import 'group_repo.dart';

class GroupRepoImplementation extends GroupRepo {
  GroupApiService apiService = GroupApiService();

  @override
  Future<Group> getGroupInfo(String groupId) async {
    final result = await apiService.getGroupInfo(groupId);
    return result;
  }

  @override
  Future<Either<Failure, void>> updateBasicGroupInfo(
      String groupId, String name, String description) async {
    try {
      await apiService.updateBasicGroupInfo(groupId, name, description);
      return const Right(null);
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, Group>> updateGroupPicture(
      String groupId, XFile pickedFile) async {
    try {
      final response = await apiService.updateGroupPicture(groupId, pickedFile);
      return Right(response);
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGroupPicture(String groupId) async {
    try {
      final response = await apiService.deleteGroupPicture(groupId);
      return Right(response);
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateGroupPrivacy(
      String groupId, String privacyOption) async {
    try {
      final response =
          await apiService.updateGroupPrivacy(groupId, privacyOption);
      return Right(response);
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateGroupSizeLimit(
      String groupId, int sizeLimit) async {
    try {
      final response =
          await apiService.updateGroupSizeLimit(groupId, sizeLimit);
      return Right(null);
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }

  @override
  Future<ContactsResponse> getContacts() async {
    return await apiService.getContacts();
  }

  @override
  Future<MembersResponse> getGroupMembers(String groupId) async {
    return await apiService.getGroupMembers(groupId);
  }

  @override
  Future<AdminsResponse> getGroupAdmins(String groupId) async {
    return await apiService.getGroupAdmins(groupId);
  }

  @override
  Future<List<dynamic>> getGroupRelevantUsers(String groupId) async {
    return await apiService.getGroupRelevantUsers(groupId);
  }

  @override
  Future<void> makeAdmin(String groupId, String userId) async {
    return await apiService.makeAdmin(groupId, userId);
  }
}
