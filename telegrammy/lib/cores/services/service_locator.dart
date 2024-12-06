import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/cores/services/auth_api_service.dart';
import 'package:telegrammy/cores/services/profile_api_service.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';
import 'package:telegrammy/features/auth/data/repos/auth_repo_implemention.dart';
import 'package:telegrammy/features/messages/data/repos/messages_repo_implementaion.dart';
import 'package:telegrammy/features/profile/data/repos/profile_repo_implemention.dart';

final getit = GetIt.instance;

void setupServiceLocator() {
  getit.registerSingleton<ApiService>(ApiService(dio: Dio()));
  getit.registerSingleton<ProfileApiService>(ProfileApiService(dio: Dio()));
  getit.registerSingleton<ProfileRepoImplementation>(ProfileRepoImplementation(
      profileApiService: getit.get<ProfileApiService>()));
  getit.registerSingleton<Dio>(Dio());
  getit.registerSingleton<AuthRepoImplemention>(
      AuthRepoImplemention(apiService: getit.get<ApiService>()));
  getit.registerSingleton<MessagesRepoImplementaion>(
      MessagesRepoImplementaion());
  getit.registerSingleton<TokenStorageService>(TokenStorageService());
  getit.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());
  getit.registerSingleton<RouteNames>(RouteNames());
  getit.registerSingleton<SocketService>(SocketService());
}
