import 'package:meta/meta.dart';
import 'package:telegrammy/features/profile/data/models/profile_visibility_model.dart';
// Define the Privacy Option enum
enum PrivacyOption { everyone, contacts, nobody }

// Privacy state base class
@immutable
abstract class PrivacyState {}

final class PrivacyInitial extends PrivacyState {}

final class PrivacyOptionsLoaded extends PrivacyState {
  final ProfileVisibility privacyOptions; // Change to ProfileVisibility

  PrivacyOptionsLoaded({required this.privacyOptions});
}

final class PrivacyUpdating extends PrivacyState {}

final class PrivacyOptionsUpdated extends PrivacyState {
  final ProfileVisibility privacyOptions; // Change to ProfileVisibility

  PrivacyOptionsUpdated({required this.privacyOptions});
}

final class PrivacyOptionsError extends PrivacyState {
  final String message;

  PrivacyOptionsError({required this.message});
}

/////////////////////////////////////
///// Security State Classes
// class User {
//   final int id;
//   final String name;
//   final bool isBlocked;

//   User({required this.id, required this.name, this.isBlocked = false});

  
//   User copyWith({bool? isBlocked}) {
//     return User(
//       id: this.id,
//       name: this.name,
//       isBlocked: isBlocked ?? this.isBlocked,
//     );
//   }
// }
// @immutable
// abstract class SecurityState {}

// final class SecurityInitial extends SecurityState {}

// final class BlockedUsersLoaded extends SecurityState {
//   final List<User> blockedUsers;  // Use the User model if defined
//   BlockedUsersLoaded({required this.blockedUsers});
// }

// final class SecurityError extends SecurityState {
//   final String message;
//   SecurityError({required this.message});
// }