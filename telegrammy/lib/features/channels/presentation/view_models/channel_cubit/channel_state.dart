part of 'channel_cubit.dart';

@immutable
class ChannelState {}

final class ChannelInitial extends ChannelState {}

final class ChannelFailure extends ChannelState {
  final errorMessage;
  ChannelFailure({required this.errorMessage});
}

final class ChannelLoading extends ChannelState {}

final class ChannelLoadedSuccess extends ChannelState {
  final Channel channelData;
  List<MemberData>? subscribers;
  List<MemberData>? admins;
  List<ContactData>? contactsExcludingsubscribers;
  List<MemberData>? nonAdminsubscribers;

  ChannelLoadedSuccess(
      {required this.channelData,
      this.admins,
      this.nonAdminsubscribers,
      this.contactsExcludingsubscribers,
      this.subscribers});
}

final class ChannelUpdatedSuccess extends ChannelState {
  final String name;
  final String description;
  final String image;

  ChannelUpdatedSuccess({
    required this.name,
    required this.description,
    required this.image,
  });
}

final class ChannelCreateLoading extends ChannelState {}

final class getChannelPostsLoading extends ChannelState {}

final class ChannelCreateSuccess extends ChannelState {}

final class ChannelCreateFailure extends ChannelState {
  final String errorMessage;
  ChannelCreateFailure({required this.errorMessage});
}

final class getChannelPostsSuccess extends ChannelState {
  final bool isAdmin;
  final bool isJoined;
  final Channel channel;
  getChannelPostsSuccess({
    required this.isAdmin,
    required this.isJoined,
    required this.channel,
  });
}

final class getChannelPostsFailure extends ChannelState {
  final String errorMessage;
  getChannelPostsFailure({required this.errorMessage});
}

final class addPostSuccess extends ChannelState {}
