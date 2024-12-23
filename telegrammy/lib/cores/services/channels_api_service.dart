import 'package:dio/dio.dart';
import 'package:telegrammy/cores/constants/api_constants.dart';
import 'package:telegrammy/cores/models/channel_model.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';

class ChannelsApiService {
  final dio = getit.get<Dio>();

  Future<String> createChannel(Channel newchannel) async {
    try {
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

  Future<Channel> getChannelInfo(String channelId) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response =
          await getit.get<Dio>().get('$baseUrl/channels/$channelId',
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                },
              ));
      if (response.statusCode == 200) {
        print(response.data);
        return Channel.fromJson(response.data);
      } else {
        throw Exception('Failed to get Channel info');
      }
    } catch (e) {
      print(e);
      throw Exception('Error: $e');
    }
  }

  Future<dynamic> updateChannelInfo(
      String channelId, String name, String description) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response =
          await getit.get<Dio>().patch('$baseUrl/channels/$channelId',
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                },
              ),
              data: {
            'name': name,
            'description': description,
          });
      print(response);
      if (response.statusCode == 200) {
        return Channel.fromJson(response.data);
      } else {
        throw Exception('Failed to update Channel');
      }
    } catch (e) {
      print(e);
      throw Exception('Error: $e');
    }
  }

  Future<dynamic> updateChannelprivacy(String channelId, String privacy) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response =
          await getit.get<Dio>().patch('$baseUrl/channels/$channelId/privacy',
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                },
              ),
              data: {'privacy': privacy});
      print(response);
      if (response.statusCode == 200) {
        return response.data['chatId'];
      } else {
        throw Exception('Failed to update Channel');
      }
    } catch (e) {
      print(e);
      throw Exception('Error: $e');
    }
  }

  Future<dynamic> changeChannelPrivacy(String channelId, String privacy) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response =
          await getit.get<Dio>().patch('$baseUrl/channels/$channelId/privacy',
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                },
              ),
              data: {'privacy': privacy});
      print(response);
      if (response.statusCode == 200) {
        return response.data['chatId'];
      } else {
        throw Exception('Failed to update Channel');
      }
    } catch (e) {
      print(e);
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getThreadMessages(String postId,
      {int page = 1, int limit = 20}) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await getit.get<Dio>().get(
        '$baseUrl/channels/thread/$postId/messages',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to retrieve messages');
      }
    } catch (e) {
      print(e);
      throw Exception('Error: $e');
    }
  }
}
