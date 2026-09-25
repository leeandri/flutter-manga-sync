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

  group('login', () {
    test('should store token on successful login', () async {
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          data: {'token': 'fake_jwt_token'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/login'),
        ),
      );
      when(mockStorage.saveToken(any)).thenAnswer((_) async {});

      await repository.login('test@example.com', 'password123');

      verify(mockStorage.saveToken('fake_jwt_token')).called(1);
    });

    test('should throw Exception when login credentials are invalid', () async {
      when(mockDio.post(any, data: anyNamed('data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/login'),
          ),
        ),
      );

      expect(
        () => repository.login('wrong@example.com', 'wrongpass'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('logout', () {
    test('should delete token on logout', () async {
      when(mockStorage.deleteToken()).thenAnswer((_) async {});

      await repository.logout();

      verify(mockStorage.deleteToken()).called(1);
    });
  });
}
