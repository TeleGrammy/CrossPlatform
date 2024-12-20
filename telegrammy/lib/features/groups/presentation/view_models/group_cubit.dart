import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegrammy/features/groups/data/repos/group_repo_implementation.dart';

import '../../../../cores/services/service_locator.dart';
import '../../../messages/data/models/contacts.dart';
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

  List<ContactData> getNonMemberContacts(
      List<ContactData> contactList, List<MemberData> memberList) {
    final memberIds = memberList.map((member) => member.userId).toSet();

    return contactList
        .where((contact) => !memberIds.contains(contact.userId))
        .toList();
  }

  List<MemberData> getNonAdminMembers(
      List<MemberData> memberList, List<MemberData> adminList) {
    final adminIds = adminList.map((admin) => admin.userId).toSet();

    return memberList
        .where((contact) => !adminIds.contains(contact.userId))
        .toList();
  }

  Future<void> getGroupInfo(String groupId, Chat chat, String lastSeen) async {
    try {
      emit(GroupLoading());
      final Group groupData =
          await getit.get<GroupRepoImplementation>().getGroupInfo(groupId);

      final List<dynamic> groupRelevantUsers = await getit
          .get<GroupRepoImplementation>()
          .getGroupRelevantUsers(groupId);
      ContactsResponse contactsResponse = groupRelevantUsers[0];
      MembersResponse membersResponse = groupRelevantUsers[1];
      AdminsResponse adminsResponse = groupRelevantUsers[2];

      List<ContactData> contactsExcludingMembers = getNonMemberContacts(
          contactsResponse.contacts, membersResponse.members);

      List<MemberData> nonAdminMembers =
          getNonAdminMembers(membersResponse.members, adminsResponse.admins);

      emit(GroupLoaded(
        groupData: groupData,
        contactsExcludingMembers: contactsExcludingMembers,
        members: membersResponse.members,
        admins: adminsResponse.admins,
        nonAdminMembers: nonAdminMembers,
      ));
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
          emit(GroupLoaded(
            groupData: groupData,
          ));
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
    List<MemberData>? members = (state as GroupLoaded).members;
    List<MemberData>? admins = (state as GroupLoaded).admins;
    List<ContactData>? contactsExcludingMembers =
        (state as GroupLoaded).contactsExcludingMembers;
    List<MemberData>? nonAdminMembers = (state as GroupLoaded).nonAdminMembers;
    String groupId = groupData.groupId;
    final result = await getit
        .get<GroupRepoImplementation>()
        .updateGroupPrivacy(groupId, privacyOption);
    groupData.groupPrivacy = privacyOption;
    emit(GroupLoaded(
        groupData: groupData,
        members: members,
        admins: admins,
        contactsExcludingMembers: contactsExcludingMembers,
        nonAdminMembers: nonAdminMembers));
  }

  Future<void> updateGroupSizeLimit(int sizeLimit) async {
    Group groupData = (state as GroupLoaded).groupData;
    String groupId = groupData.groupId;
    List<MemberData>? members = (state as GroupLoaded).members;
    List<MemberData>? admins = (state as GroupLoaded).admins;
    List<ContactData>? contactsExcludingMembers =
        (state as GroupLoaded).contactsExcludingMembers;
    List<MemberData>? nonAdminMembers = (state as GroupLoaded).nonAdminMembers;
    final result = await getit
        .get<GroupRepoImplementation>()
        .updateGroupSizeLimit(groupId, sizeLimit);
    print(result);
    groupData.groupSizeLimit = sizeLimit;
    emit(GroupLoaded(
        groupData: groupData,
        members: members,
        admins: admins,
        contactsExcludingMembers: contactsExcludingMembers,
        nonAdminMembers: nonAdminMembers));
  }

  Future<void> getGroupMembers(String groupId) async {
    getit.get<GroupRepoImplementation>().getGroupMembers(groupId);
  }

  Future<void> makeAdmin(String groupId, String userId) async {
    await getit.get<GroupRepoImplementation>().makeAdmin(groupId, userId);
  }

  Future<void> setMessagingPermissions() async {}
  Future<void> setMediaDownloadPermissions() async {}
}
