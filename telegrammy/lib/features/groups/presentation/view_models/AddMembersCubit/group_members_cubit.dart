import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:telegrammy/features/groups/data/models/group.dart';

import '../../../../../cores/services/service_locator.dart';
import '../../../data/repos/group_repo_implementation.dart';

part 'group_members_state.dart';

class GroupMembersCubit extends Cubit<GroupMembersState> {
  GroupMembersCubit() : super(GroupMembersInitial());

  Future<void> getContacts() async {
    emit(GroupMembersLoading());
    final response = await getit.get<GroupRepoImplementation>().getContacts();
    response.fold(
      (failure) => emit(GroupMembersError(errorMessage: failure.toString())),
      (contactsResponse) =>
          emit(GroupMembersLoaded(contacts: contactsResponse.contacts)),
    );
  }

  Future<void> getGroupMembers() async {
    emit(GroupMembersLoading());
  }
}
