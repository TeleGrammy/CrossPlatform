import 'package:dartz/dartz.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/cores/models/channel_model.dart';

abstract class ChannelsRepo {
  Future<Either<Failure, String>> createChannel(Channel newChannel);
}
