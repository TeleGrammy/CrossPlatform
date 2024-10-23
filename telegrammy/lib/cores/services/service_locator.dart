import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:telegrammy/cores/services/api_service.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';
import 'package:telegrammy/features/auth/data/repos/auth_repo_implemention.dart';

final getit = GetIt.instance;

void setupServiceLocator() {
  getit.registerSingleton<ApiService>(ApiService(dio: Dio()));
  getit.registerSingleton<AuthRepoImplemention>(
      AuthRepoImplemention(apiService: getit.get<ApiService>()));
  getit.registerSingleton<TokenStorageService>(TokenStorageService());
}
