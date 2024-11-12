import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:telegrammy/cores/errors/Failture.dart';
import 'package:telegrammy/features/profile/data/models/stories_model.dart';
import 'package:telegrammy/features/profile/data/repos/profile_repo.dart';
import 'story_state.dart';
import 'package:telegrammy/features/profile/data/repos/profile_repo_implemention.dart';
import 'package:telegrammy/cores/services/service_locator.dart';

class StoriesCubit extends Cubit<StoryState> {
  final ProfileRepo profileRepo = getit.get<ProfileRepoImplementation>();

  StoriesCubit() : super(StoryInitial()) {
    getUserStories(); // Call getUserStories upon initialization
  }

  // Method to fetch user stories
  Future<void> getUserStories() async {
    emit(StoryLoading()); // Emit loading state

    final Either<Failure, StoryResponse> result = await profileRepo.getUserStories();

    result.fold(
      (failure) => emit(StoryError(message: failure.errorMessage)), // Emit error state
      (storyResponse) => emit(StoryLoaded(storyResponse: storyResponse)), // Emit loaded state
    );
  }


  // Method to update a story
Future<void> updateStory(StoryCreation story) async {
  emit(StoryUpdating()); // Emit updating state

  final Either<Failure, void> result = await profileRepo.createStory(story);

  result.fold(
    (failure) => emit(StoryError(message: failure.errorMessage)), // Emit error state
    (_) => emit(StoryUpdated()), // Emit updated state with no data since `createStory` returns void
  );
}


 Future<void> deleteStory(String storyId) async {
    emit(StoryDeleting()); // Emit deleting state

    final Either<Failure, void> result = await profileRepo.deleteStory(storyId);

    result.fold(
      (failure) => emit(StoryError(message: failure.errorMessage)), // Emit error state if deletion fails
      (_) => emit(StoryDeleted()), // Emit deleted state after successful deletion
    );
  }
}