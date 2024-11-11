import 'dart:io';

import 'package:flutter/material.dart';

@immutable
abstract class ProfileSettingsState {}

final class ProfileInitial extends ProfileSettingsState {}

final class ProfileLoading extends ProfileSettingsState {}

final class ProfileLoaded extends ProfileSettingsState {
  final User user;
  ProfileLoaded({required this.user});
}

final class ProfileError extends ProfileSettingsState {
  final String errorMessage;
  ProfileError(this.errorMessage);
}

class User {
  String? screenName;
  String? username;
  String email;
  String? phoneNumber;
  String? bio;
  // TODO: figure out compatible image format
  File? profilePic;
  String? status;
  DateTime? lastSeen;
  List<File> stories = [];

  User(
      {this.screenName,
      this.username,
      required this.email,
      this.phoneNumber,
      this.bio,
      this.profilePic,
      this.status,
      this.lastSeen});
}
