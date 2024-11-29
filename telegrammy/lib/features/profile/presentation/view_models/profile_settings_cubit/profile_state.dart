import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/models/profile_info_model.dart';

@immutable
abstract class ProfileSettingsState {}

final class ProfileInitial extends ProfileSettingsState {}

final class ProfileLoading extends ProfileSettingsState {}

final class ProfileLoaded extends ProfileSettingsState {
  final ProfileInfo profileInfo;
  ProfileLoaded({required this.profileInfo});
}

final class ProfileError extends ProfileSettingsState {
  final String errorMessage;
  ProfileError({required this.errorMessage});
}
