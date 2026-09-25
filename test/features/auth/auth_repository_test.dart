import 'package:dio/dio.dart';
import 'package:flutter_manga_sync/core/storage/secure_storage_service.dart';
import 'package:flutter_manga_sync/features/auth/data/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([Dio, SecureStorageService])
void main() {
  late AuthRepository repository;
  late MockDio mockDio;
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockDio = MockDio();
    mockStorage = MockSecureStorageService();
    repository = AuthRepository(mockDio, mockStorage);
  });

  group('AuthRepository Login', () {
    test('login returns token and saves it on HTTP 200 success', () async {
      when(
        mockDio.post(
          'https://reqres.in/api/login',
          data: {'email': 'eve.holt@reqres.in', 'password': 'cityslicka'},
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {'token': 'QpwL5tke4Pnpja7X4'},
        ),
      );

      when(mockStorage.saveToken('QpwL5tke4Pnpja7X4'))
          .thenAnswer((_) async => true);

      final token = await repository.login('eve.holt@reqres.in', 'cityslicka');

      expect(token, equals('QpwL5tke4Pnpja7X4'));
      verify(mockStorage.saveToken('QpwL5tke4Pnpja7X4')).called(1);
    });

    test('login throws Exception when token is missing in response', () async {
      when(
        mockDio.post(
          'https://reqres.in/api/login',
          data: {'email': 'test@test.com', 'password': 'pass'},
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {},
        ),
      );

      expect(
        () async => repository.login('test@test.com', 'pass'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('AuthRepository Register', () {
    test('register returns token and saves it on HTTP 200 success', () async {
      when(
        mockDio.post(
          'https://reqres.in/api/register',
          data: {'email': 'eve.holt@reqres.in', 'password': 'pistol'},
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {'token': 'QpwL5tke4Pnpja7X4'},
        ),
      );

      when(mockStorage.saveToken('QpwL5tke4Pnpja7X4'))
          .thenAnswer((_) async => true);

      final token = await repository.register('eve.holt@reqres.in', 'pistol');

      expect(token, equals('QpwL5tke4Pnpja7X4'));
      verify(mockStorage.saveToken('QpwL5tke4Pnpja7X4')).called(1);
    });
  });
}
