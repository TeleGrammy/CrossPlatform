import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:telegrammy/cores/models/channel_model.dart';
import 'package:telegrammy/features/channels/data/repos/channel_repo_implementation.dart';
import 'package:telegrammy/features/groups/data/models/group.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';

part 'channel_state.dart';

class ChannelCubit extends Cubit<ChannelState> {
  ChannelCubit() : super(ChannelInitial());
  ChannelsRepoImplementaion repoImplementaion = ChannelsRepoImplementaion();

  Future<void> createChannel(Channel newChannel) async {
    emit(ChannelCreateLoading());
    final result = await repoImplementaion.createChannel(newChannel);
    result.fold((failre) {
      print('Cubit:channel created ${failre.errorMessage}');
      emit(ChannelCreateFailure(errorMessage: failre.errorMessage));
    }, (data) {
      print('Cubit:channel created successfully');
      emit(ChannelCreateSuccess());
    });
  }

  void getChannelInfo(String channelId) async {
    emit(ChannelLoading());
    final result = await repoImplementaion.getChannelInfo(channelId);
    result.fold((failre) {
      print('Cubit:error get channel info ${failre.errorMessage}');
      emit(ChannelFailure(errorMessage: failre.errorMessage));
    }, (data) {
      print('Cubit:loaded channel info successfully');
      emit(ChannelLoadedSuccess(channelData: data));
    });
  }

  void updateChannelPrivacy(String newPrivacy) {}

  Future<void> updateChannelInfo(
      ChatView channel, String name, String description, String privacy) async {
    emit(ChannelLoading());
    final result = await repoImplementaion.updateChannelInfo(
        channel.channelId!, name, description);
    result.fold((failre) {
      print('Cubit:error update channel info ${failre.errorMessage}');
      emit(ChannelFailure(errorMessage: failre.errorMessage));
    }, (data) {
      print('Cubit:updated channel info successfully');
      Channel updatedChannel = Channel(
        name: name,
        channelId: channel.channelId,
        createdAt: channel.createdAt ?? " ",
        description: description,
        privacy: privacy,
      );
      emit(ChannelLoadedSuccess(channelData: updatedChannel));
    });
  }

  void updateChannelPicture() {}

  void deleteGroupPicture() {}

  void deleteChannelPicture() {}
}
