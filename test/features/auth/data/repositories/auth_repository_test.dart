import 'package:dio/dio.dart';
import 'package:flutter_manga_sync/core/errors/failures.dart';
import 'package:flutter_manga_sync/core/storage/secure_storage_service.dart';
import 'package:flutter_manga_sync/features/auth/data/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late AuthRepository repository;
  late MockDio mockDio;
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockDio = MockDio();
    mockStorage = MockSecureStorageService();
    repository = AuthRepository(mockDio, mockStorage);
  });

  group('AuthRepository - login', () {
    const tEmail = 'eve.holt@reqres.in';
    const tPassword = 'cityslicka';
    const tToken = 'QpwL5tke4PnpJA7X4';

    test('should return Success(token) when login is successful', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: {'token': tToken},
          statusCode: 200,
        ),
      );
      when(() => mockStorage.saveToken(tToken)).thenAnswer((_) async => {});

      final result = await repository.login(tEmail, tPassword);

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, tToken);
      verify(() => mockStorage.saveToken(tToken)).called(1);
    });

    test('should return Error(ServerFailure) when API returns 400 with error message', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            data: {'error': 'Missing password'},
            statusCode: 400,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repository.login(tEmail, '');

      expect(result, isA<Error<String>>());
      expect((result as Error<String>).failure, isA<ServerFailure>());
    });

    test('should return Error(NetworkFailure) on connection timeout', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await repository.login(tEmail, tPassword);

      expect(result, isA<Error<String>>());
      expect((result as Error<String>).failure, isA<NetworkFailure>());
    });
  });

  group('AuthRepository - logout', () {
    test('should delete token and return Success', () async {
      when(() => mockStorage.deleteToken()).thenAnswer((_) async => {});

      final result = await repository.logout();

      expect(result, isA<Success<void>>());
      verify(() => mockStorage.deleteToken()).called(1);
    });
  });
}
