import 'package:meta/meta.dart';
import 'package:telegrammy/features/profile/data/models/stories_model.dart';
import 'story_cubit.dart';

@immutable
abstract class StoryState {}

final class StoryInitial extends StoryState {}

final class StoryLoading extends StoryState {}

final class StoryLoaded extends StoryState {
  final StoryResponse storyResponse;

  StoryLoaded({required this.storyResponse});
}

final class StoryUpdating extends StoryState {}

final class StoryUpdated extends StoryState {
  StoryUpdated(); // No need for parameters since it's just an indication of success
}

final class StoryDeleting extends StoryState {}

final class StoryDeleted extends StoryState {}

final class StoryError extends StoryState {
  final String message;

  StoryError({required this.message});
}



///////////////////////////////////////////
@immutable
abstract class OthersStoryState {}

final class OthersStoryInitial extends OthersStoryState {}

final class OthersStoryLoading extends OthersStoryState {}

final class OthersStoryLoaded extends OthersStoryState {
  final MultiUserStoryResponse usersStoriesModel;

 OthersStoryLoaded({required this.usersStoriesModel});
}

final class StoryViewing extends OthersStoryState {}

final class StoryViewed extends OthersStoryState {
  StoryViewed(); // No need for parameters since it's just an indication of success
}

final class OthersStoryError extends OthersStoryState {
  final String message;

  OthersStoryError({required this.message});
}