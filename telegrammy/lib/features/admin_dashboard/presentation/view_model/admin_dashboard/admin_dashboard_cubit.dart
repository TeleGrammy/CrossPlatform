import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/features/admin_dashboard/data/models/registered_users_model.dart';
import 'package:telegrammy/features/admin_dashboard/presentation/view_model/admin_dashboard/admin_dashboard_state.dart';

class RegisteredUsersCubit extends Cubit<RegisteredUsersState> {
  RegisteredUsersCubit() : super(RegisteredUsersLoading());

  final List<RegisteredUsersData> _mockData = [
    RegisteredUsersData(
      id: '1',
      username: 'john_doe',
      screenName: 'John Doe',
      email: 'john.doe@example.com',
      phone: '1234567890',
      picture: 'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      bio: 'Software Developer',
      status: 'active',
      isBanned: false,
    ),
    RegisteredUsersData(
      id: '2',
      username: 'jane_doe',
      screenName: 'Jane Doe',
      email: 'jane.doe@example.com',
      phone: '9876543210',
      picture: 'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      bio: 'Graphic Designer',
      status: 'inactive',
      isBanned: true,
    ),
  ];

  /// Load Registered Users
  Future<void> loadRegisteredUsers() async {
    try {
      emit(RegisteredUsersLoading());
      // Simulate a network delay
      await Future.delayed(Duration(seconds: 2));

      emit(RegisteredUsersLoaded(registeredUsers: _mockData));
    } catch (e) {
      emit(RegisteredUsersError(message: 'Failed to load registered users.'));
    }
  }

  /// Update User Status
  Future<void> updateUserStatus(String userId, bool isEnabled) async {
    try {
      emit(RegisteredUsersUpdating());
      // Simulate a network delay
      await Future.delayed(Duration(seconds: 1));

      // Update mock data
      for (var user in _mockData) {
        if (user.id == userId) {
          user.isBanned = !isEnabled;
        }
      }

      emit(RegisteredUsersUpdated(isEnabled: isEnabled));
      emit(RegisteredUsersLoaded(registeredUsers: _mockData));
    } catch (e) {
      emit(RegisteredUsersError(message: 'Failed to update user status.'));
    }
  }
}
