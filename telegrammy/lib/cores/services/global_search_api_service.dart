import 'package:dio/dio.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';

import '../../features/search/data/models/search_model.dart';
import '../constants/api_constants.dart';

class GlobalSearchApiService {
  final dio = getit.get<Dio>();

  Future<GlobalSearchResponse> globalSearch(
      String subCategory, String attribute, String query) async {
    try {
      String? token = await getit.get<TokenStorageService>().getToken();
      final response = await dio.get(
        '$baseUrl/search/global-search?type=$subCategory&$attribute=$query',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      print(response.data);
      return GlobalSearchResponse.fromJson(response.data['data'], subCategory);
    } on DioException catch (dioError) {
      throw Exception('Error fetching data: ${dioError.message}');
    }
  }
}
