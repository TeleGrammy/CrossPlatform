import 'package:dio/dio.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';

import '../constants/api_constants.dart';

class GlobalSearchApiService {
  final dio = getit.get<Dio>();

  Future<void> globalSearch(String category, String query) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await dio.get(
        '$baseUrl/search/global-search?type=$category&uuid=$query',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      // return Group.fromJson(response.data['data']['group']);
    } on DioException catch (dioError) {
      throw Exception('Error fetching group info: ${dioError.message}');
    }
  }
}
