part of 'channel_cubit.dart';

@immutable
class ChannelState {}

final class ChannelInitial extends ChannelState {}

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
  getChannelPostsSuccess(
      {required this.isAdmin, required this.isJoined, required this.channel});
}

final class getChannelPostsFailure extends ChannelState {
  final String errorMessage;
  getChannelPostsFailure({required this.errorMessage});
}

final class addPostSuccess extends ChannelState {}
