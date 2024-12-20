import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/cores/services/admin_dashboard_api_service.dart';
import 'package:telegrammy/cores/services/auth_api_service.dart';
import 'package:telegrammy/cores/services/channel_socket.dart';
import 'package:telegrammy/cores/services/global_search_api_service.dart';
import 'package:telegrammy/cores/services/group_api_service.dart';
import 'package:telegrammy/cores/services/groups_socket.dart';
import 'package:telegrammy/cores/services/messages_api_service.dart';
import 'package:telegrammy/cores/services/notfications_api_service.dart';
import 'package:telegrammy/cores/services/profile_api_service.dart';
import 'package:telegrammy/cores/services/socket.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';
import 'package:telegrammy/features/admin_dashboard/data/repo/admin_dashboard_repo_implementation.dart';
import 'package:telegrammy/features/auth/data/repos/auth_repo_implemention.dart';
import 'package:telegrammy/features/groups/data/repos/group_repo_implementation.dart';
import 'package:telegrammy/features/messages/data/repos/messages_repo_implementaion.dart';
import 'package:telegrammy/features/notifications/data/repos/notifications_repo_implementation.dart';
import 'package:telegrammy/features/profile/data/repos/profile_repo_implemention.dart';

final getit = GetIt.instance;

void setupServiceLocator() {
  getit.registerSingleton<ApiService>(ApiService(dio: Dio()));
  getit.registerSingleton<MessagesApiService>(MessagesApiService(dio: Dio()));
  getit.registerSingleton<ProfileApiService>(ProfileApiService(dio: Dio()));
  getit.registerSingleton<ProfileRepoImplementation>(ProfileRepoImplementation(
      profileApiService: getit.get<ProfileApiService>()));

  getit.registerSingleton<AdminDashboardApiService>(
      AdminDashboardApiService(dio: Dio()));
  getit.registerSingleton<AdminDashboardRepoImplementation>(
      AdminDashboardRepoImplementation(
          adminDashboardApiService: getit.get<AdminDashboardApiService>()));

  getit.registerSingleton<NotificationsApiService>(
      NotificationsApiService(dio: Dio()));
  getit.registerSingleton<NotificationsRepoImplementation>(
      NotificationsRepoImplementation(
          notificationsApiService: getit.get<NotificationsApiService>()));

  getit.registerSingleton<Dio>(Dio());
  getit.registerSingleton<AuthRepoImplemention>(
      AuthRepoImplemention(apiService: getit.get<ApiService>()));
  getit.registerSingleton<MessagesRepoImplementaion>(
      MessagesRepoImplementaion());
  getit.registerSingleton<TokenStorageService>(TokenStorageService());
  getit.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());
  getit.registerSingleton<RouteNames>(RouteNames());
  getit.registerSingleton<SocketService>(SocketService());
  getit.registerSingleton<ChannelSocketService>(ChannelSocketService());
  getit.registerSingleton<GroupApiService>(GroupApiService());
  getit.registerSingleton<GroupRepoImplementation>(GroupRepoImplementation());
  getit.registerSingleton<GroupSocketService>(GroupSocketService());
  getit.registerSingleton<GlobalSearchApiService>(GlobalSearchApiService());
}
