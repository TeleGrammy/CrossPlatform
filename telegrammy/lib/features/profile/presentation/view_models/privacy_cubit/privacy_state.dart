import 'package:meta/meta.dart';
import 'privacy_cubit.dart';
// Define the Privacy Option enum
enum PrivacyOption { everyone, contacts, nobody }

// Privacy state base class
@immutable
abstract class PrivacyState {}

// Initial state when the PrivacySettingsCubit is created
final class PrivacyInitial extends PrivacyState {}

// State when privacy options are successfully loaded
final class PrivacyOptionsLoaded extends PrivacyState {
  final Map<String, PrivacyOption> privacyOptions; // Store the privacy options
  //  final List<User> blockedUsers; // Change to List<User> // List of blocked user IDs

  PrivacyOptionsLoaded({required this.privacyOptions});
}

// State when there is an error loading privacy options
final class PrivacyOptionsError extends PrivacyState {
  final String message;

  PrivacyOptionsError({required this.message});
}

/////////////////////////////////////
///// Security State Classes
class User {
  final int id;
  final String name;
  final bool isBlocked;

  User({required this.id, required this.name, this.isBlocked = false});

  
  User copyWith({bool? isBlocked}) {
    return User(
      id: this.id,
      name: this.name,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
}
@immutable
abstract class SecurityState {}

final class SecurityInitial extends SecurityState {}

final class BlockedUsersLoaded extends SecurityState {
  final List<User> blockedUsers;  // Use the User model if defined
  BlockedUsersLoaded({required this.blockedUsers});
}

final class SecurityError extends SecurityState {
  final String message;
  SecurityError({required this.message});
}