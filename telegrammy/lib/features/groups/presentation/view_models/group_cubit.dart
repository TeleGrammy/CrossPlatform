import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitial());

  Future<void> createGroup(
      String groupName, XFile? groupImage, String groupDescription) async {}
  Future<void> deleteGroup(String groupId) async {}
  Future<void> leaveGroup() async {}

  Future<void> addAdminToGroup() async {}
  Future<void> addUsersToGroup() async {}

  Future<void> setMessagingPermissions() async {}
  Future<void> setMediaDownloadPermissions() async {}
  Future<void> setGroupPrivacy() async {}

  Future<XFile?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }
}
