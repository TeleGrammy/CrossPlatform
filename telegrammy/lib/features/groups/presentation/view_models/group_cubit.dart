import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegrammy/features/groups/data/repos/group_repo_implementation.dart';

import '../../../../cores/services/service_locator.dart';
import '../../data/models/group.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitial());

  Future<XFile?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  Future<void> getGroupInfo(String groupId) async {
    try {
      emit(GroupLoading());
      final Group result =
          await getit.get<GroupRepoImplementation>().getGroupInfo(groupId);
      emit(GroupLoaded(groupData: result));
    } catch (e) {
      emit(GroupError(errorMessage: e.toString()));
    }
  }

  Future<void> updateGroupInfo(
      {required String groupId,
      required String name,
      required String description}) async {
    await getit
        .get<GroupRepoImplementation>()
        .updateBasicGroupInfo(groupId, name, description);
    try {} catch (e) {
      emit(GroupError(errorMessage: e.toString()));
    }
  }

  Future<void> updateGroupPicture() async {
    if (state is GroupLoaded) {
      String groupId = (state as GroupLoaded).groupData.groupId;
      final pickedFile = await pickImage();
      if (pickedFile != null) {
        final result = await getit
            .get<GroupRepoImplementation>()
            .updateGroupPicture(groupId, pickedFile);
        result.fold((failure) {
          emit(GroupError(errorMessage: failure.errorMessage));
        }, (groupData) {
          emit(GroupLoaded(groupData: groupData));
        });
      }
    }
  }

  Future<void> deleteGroupPicture() async {
    String groupId = (state as GroupLoaded).groupData.groupId;
    final result =
        await getit.get<GroupRepoImplementation>().deleteGroupPicture(groupId);
  }

  Future<void> updateGroupPrivacy(String privacyOption) async {
    Group groupData = (state as GroupLoaded).groupData;
    String groupId = groupData.groupId;
    final result = await getit
        .get<GroupRepoImplementation>()
        .updateGroupPrivacy(groupId, privacyOption);
    print(result);
    groupData.groupPrivacy = privacyOption;
    emit(GroupLoaded(groupData: groupData));
  }

  Future<void> updateGroupSizeLimit(int sizeLimit) async {
    Group groupData = (state as GroupLoaded).groupData;
    String groupId = groupData.groupId;
    final result = await getit
        .get<GroupRepoImplementation>()
        .updateGroupSizeLimit(groupId, sizeLimit);
    print(result);
    groupData.groupSizeLimit = sizeLimit;
    emit(GroupLoaded(groupData: groupData));
  }

  Future<void> addAdminToGroup() async {}
  Future<void> addUsersToGroup() async {}

  Future<void> setMessagingPermissions() async {}
  Future<void> setMediaDownloadPermissions() async {}
}
