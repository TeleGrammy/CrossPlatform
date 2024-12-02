import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:telegrammy/cores/services/profile_api_service.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';
import 'package:telegrammy/features/profile/data/models/profile_info_model.dart';
import 'package:telegrammy/features/profile/data/repos/profile_repo_implemention.dart';
import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_cubit.dart';
import 'package:telegrammy/features/profile/presentation/view_models/profile_settings_cubit/profile_state.dart';

class MockProfileApiService extends Mock implements ProfileApiService {}

class MockTokenStorageService extends Mock implements TokenStorageService {}

class MockProfileRepository extends Mock implements ProfileRepoImplementation {}

void main() {
  late ProfileSettingsCubit profileSettingsCubit;

  setUp(() async {
    GetIt.instance.reset();

    // Register mock services in GetIt
    GetIt.instance
        .registerSingleton<ProfileApiService>(MockProfileApiService());
    GetIt.instance
        .registerSingleton<TokenStorageService>(MockTokenStorageService());
    GetIt.instance
        .registerSingleton<ProfileRepoImplementation>(MockProfileRepository());

    profileSettingsCubit = ProfileSettingsCubit();

    // Mock the token to be returned
    when(() => GetIt.instance.get<TokenStorageService>().getToken())
        .thenAnswer((_) async => 'mock_token');
  });

  tearDown(() {
    // Reset GetIt to avoid side effects between tests
    GetIt.instance.reset();
  });

  blocTest<ProfileSettingsCubit, ProfileSettingsState>(
    'emits ProfileLoading then ProfileLoaded '
    'when retrieval of profile info is successful',
    build: () {
      when(() =>
              GetIt.instance.get<ProfileRepoImplementation>().getProfileInfo())
          .thenAnswer((_) async => Right(ProfileInfoResponse.fromJson({
                'status': 'success',
                'data': {
                  'user': {
                    'username': 'test_user',
                    'email': 'test@example.com',
                    'phone': '01234567891',
                    'screenName': 'user123',
                    'bio': 'cool bio',
                    'status': 'active',
                    'picture': 'imageUrl'
                  }
                }
              }))); // Mocking the response
      return profileSettingsCubit;
    },
    act: (cubit) async {
      await profileSettingsCubit.loadBasicProfileInfo();
    },
    expect: () => [
      isA<ProfileLoading>(),
      isA<ProfileLoaded>(),
    ],
  );
}
