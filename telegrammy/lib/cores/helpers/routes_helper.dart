import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/services/token_storage_service.dart';

class RoutesHelper {
  Future<bool> isSignedUp() async {
    String? email = await getit.get<TokenStorageService>().getEmail();
    if (email != null && email.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    String? token = await getit.get<TokenStorageService>().getToken();
    if (token != null && token.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
