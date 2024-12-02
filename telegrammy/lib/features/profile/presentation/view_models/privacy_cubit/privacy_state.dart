import 'package:meta/meta.dart';
import 'package:telegrammy/features/profile/data/models/profile_visibility_model.dart';

// Define the Privacy Option enum
enum PrivacyOption { everyone, contacts, nobody }

// Privacy state base class
@immutable
abstract class PrivacyState {}

final class PrivacyInitial extends PrivacyState {}

final class PrivacyOptionsLoaded extends PrivacyState {
  final ProfileVisibility privacyOptions;

  PrivacyOptionsLoaded({required this.privacyOptions});
}

final class PrivacyLoading extends PrivacyState {} // Add this state

final class PrivacyUpdating extends PrivacyState {}

final class PrivacyOptionsUpdated extends PrivacyState {
  final ProfileVisibility privacyOptions;

  PrivacyOptionsUpdated({required this.privacyOptions});
}

final class PrivacyOptionsError extends PrivacyState {
  final String message;

  PrivacyOptionsError({required this.message});
}
