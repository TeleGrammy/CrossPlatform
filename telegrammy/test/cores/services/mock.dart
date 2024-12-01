import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart'; // Correct path to your class
import 'package:telegrammy/cores/services/profile_api_service.dart'; // Correct path to your class

@GenerateMocks([ProfileApiService, TokenStorageService])
void main() {}
