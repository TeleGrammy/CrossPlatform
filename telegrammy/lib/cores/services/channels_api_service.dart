import 'package:dio/dio.dart';
import 'package:telegrammy/cores/constants/api_constants.dart';
import 'package:telegrammy/cores/models/channel_model.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';

class ChannelsApiService {
  final dio = getit.get<Dio>();

  Future<String> createChannel(Channel newchannel) async {
    try {
      print('inside create channel api');
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await getit.get<Dio>().post('$baseUrl/channels',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
          data: {
            'name': newchannel.name,
            'description': newchannel.description,
          });
      print(response);
      if (response.statusCode == 200) {
        return response.data['chatId'];
      } else {
        throw Exception('Failed to create Channel');
      }
    } catch (e) {
      print(e);
      throw Exception('Error: $e');
    }
  }
}
