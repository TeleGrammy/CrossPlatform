part of 'messages_cubit.dart';

@immutable
sealed class MessagesState {}

final class MessagesInitial extends MessagesState {}

final class MessagesLoading extends MessagesState {}

final class MessagesSuccess extends MessagesState {
  final Map<String, dynamic> chatData;
  MessagesSuccess({required this.chatData});
}

final class Messagesfailture extends MessagesState {
  final String error;
  Messagesfailture({required this.error});
}
