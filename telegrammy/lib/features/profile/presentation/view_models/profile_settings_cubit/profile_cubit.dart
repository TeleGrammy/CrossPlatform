import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_state.dart';

User user = User(
    screenName: 'Khalid',
    username: 'jayjay',
    email: 'khalid_forreal@gmail.com',
    phoneNumber: '01001010100',
    bio: 'really cool bio and stuff',
    status: 'Online',
    lastSeen: DateTime.now());

class ProfileSettingsCubit extends Cubit<ProfileSettingsState> {
  ProfileSettingsCubit() : super(ProfileInitial());

  Future<void> loadBasicProfileInfo() async {
    emit(ProfileLoading());
    // TODO: fetch data from api

    emit(ProfileLoaded(user: user));
  }

  Future<void> updateBasicProfileInfo(
      {String? screenName,
      String? userName,
      String? email,
      String? phoneNumber,
      String? bio}) async {
    // TODO: send update request through api
    if (state is ProfileLoaded) {
      final user = (state as ProfileLoaded).user;
      user.screenName = screenName;
      user.username = userName;
      user.email = email!;
      user.phoneNumber = phoneNumber;
      user.bio = bio;
      user.lastSeen = DateTime.now();
      emit(ProfileLoaded(user: user));
    }
  }

  void updateUserStatus(String status) {
    if (state is ProfileLoaded) {
      final user = (state as ProfileLoaded).user;
      // TODO: call api to update status
      user.status = status;
      emit(ProfileLoaded(user: user));
    }
  }

  Future<XFile?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  Future<void> updateProfilePicture() async {
    if (state is ProfileLoaded) {
      final pickedFile = await pickImage();
      if (pickedFile != null) {
        // TODO: call api to update profile pic
        User user = (state as ProfileLoaded).user;
        user.profilePic = File(pickedFile.path);
        emit(ProfileLoaded(user: user));
      }
    }
  }

  void deleteProfilePicture() {
    if (state is ProfileLoaded) {
      User user = (state as ProfileLoaded).user;
      user.profilePic = null;
      // TODO: call api to delete profile pic
      emit(ProfileLoaded(user: user));
    }
  }

  Future<void> addStory() async {
    final pickedFile = await pickImage();

    if (pickedFile != null) {
      // TODO: send to backend via API
      User user = (state as ProfileLoaded).user;
      user.stories.add(File(pickedFile.path));
      emit(ProfileLoaded(user: user));
    }
  }

  void removeStory(File storyToRemove) {
    if (state is ProfileLoaded) {
      User user = (state as ProfileLoaded).user;
      user.stories.remove(storyToRemove);
      // TODO: call api to delete story
      emit(ProfileLoaded(user: user));
    }
  }
}
