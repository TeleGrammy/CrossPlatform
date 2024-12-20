import 'package:dartz/dartz.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/cores/models/channel_model.dart';
import 'package:telegrammy/cores/services/channels_api_service.dart';
import 'package:telegrammy/features/channels/data/repos/channel_repo.dart';

class ChannelsRepoImplementaion extends ChannelsRepo {
  ChannelsApiService apiService = ChannelsApiService();

  @override
  Future<Either<Failure, String>> createChannel(Channel newChannel) async {
    try {
      final channelId = await apiService.createChannel(newChannel);
      return Right(channelId);
    } catch (error) {
      return Left(ServerError(errorMessage: error.toString()));
    }
  }
}
