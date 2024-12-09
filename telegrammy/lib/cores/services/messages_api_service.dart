import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:telegrammy/features/messages/data/models/chat_data.dart';
import 'package:telegrammy/features/messages/data/models/contacts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:telegrammy/cores/constants/api_constants.dart';
// import 'package:flutter_web_auth_plus/flutter_web_auth_plus.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';

class MessagesApiService {
  MessagesApiService({required this.dio});
  final Dio dio;

  Future<Either<String, Map<String, dynamic>>> getMessages(
      String chatId) async {
    try {
      // Fetch the token
      String? token = await getit.get<TokenStorageService>().getToken();
      // Make the API call
      final response = await getit.get<Dio>().get(
            '$baseUrl/chats/chat/$chatId?page=1&limit=30',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
              },
            ),
          );
      // Check response status
      if (response.statusCode == 200) {
        final data = response.data;
        // Parse participants
        List<Participant> participants = (data['chat']['participants'] as List)
            .map((p) => Participant.fromJson(p))
            .toList();
        print(participants[0]);
        // Parse messages
        List<Message> messages = (data['messages']['data'] as List)
            .map((m) => Message.fromJson(m))
            .toList();
        print(messages);
        // Return success with parsed data
        return Right({
          'participants': participants,
          'messages': messages,
        });
      } else {
        // Return error for non-200 status codes
        return Left(
            'Failed to fetch messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Return error message in case of an exception
      print(e);
      return Left('Error: $e');
    }
  }
}
