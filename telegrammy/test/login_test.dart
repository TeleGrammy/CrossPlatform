import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:telegrammy/cores/services/api_service.dart';

class MockDio extends Mock implements Dio {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class ApiService {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  ApiService({required this.dio, required this.secureStorage});

  Future<Either<String, void>> login(Map<String, String> userLoginData) async {
    try {
      final response = await dio.post(
        'http://10.0.2.2:8080/api/v1/auth/login',
        data: userLoginData,
      );

      await secureStorage.write(
          key: 'accessToken', value: response.data['data']['accessToken']);

      return const Right(null);
    } on DioException catch (dioException) {
      if (dioException.response != null &&
          dioException.response?.statusCode == 404) {
        return const Left('Invalid email or password.');
      }
      return const Left('Something went wrong.');
    } catch (e) {
      return const Left('Something went wrong.');
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockDio mockDio;
  late MockFlutterSecureStorage mockStorage;
  late ApiService apiService;

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  setUp(() {
    mockDio = MockDio();
    mockStorage = MockFlutterSecureStorage();
    apiService = ApiService(dio: mockDio, secureStorage: mockStorage);
  });

  group('login function', () {
    test('should return Right when login is successful', () async {
      final userLoginData = {
        'email': 'test@example.com',
        'password': 'password123'
      };
      final response = Response(
        data: {
          'data': {'accessToken': 'fake_token'}
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      );

      when(mockDio.post('any', data: anyNamed('data')))
          .thenAnswer((_) async => response);
      when(mockStorage.write(key: 'accessToken', value: 'fake_token'))
          .thenAnswer((_) async => null);

      final result = await apiService.login(userLoginData);

      expect(result, const Right(null));
      verify(mockStorage.write(key: 'accessToken', value: 'fake_token'))
          .called(1);
    });

    test('should return Left when login fails with 404', () async {
      final userLoginData = {
        'email': 'test@example.com',
        'password': 'wrongpassword'
      };
      final response = Response(
        data: null,
        statusCode: 404,
        requestOptions: RequestOptions(path: ''),
      );

      when(mockDio.post('any', data: anyNamed('data'))).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: response,
      ));

      final result = await apiService.login(userLoginData);

      expect(result, const Left('Invalid email or password.'));
      verifyNever(
          mockStorage.write(key: 'accessToken', value: anyNamed('value')));
    });

    test('should return Left when there is a general error', () async {
      final userLoginData = {
        'email': 'test@example.com',
        'password': 'password123'
      };
      when(mockDio.post('any', data: anyNamed('data')))
          .thenThrow(Exception('Some error'));

      final result = await apiService.login(userLoginData);

      expect(result, const Left('Something went wrong.'));
      verifyNever(
          mockStorage.write(key: 'accessToken', value: anyNamed('value')));
    });
  });
}
