import 'package:dio/dio.dart';
import 'package:flutter_manga_sync/core/network/auth_interceptor.dart';
import 'package:flutter_manga_sync/core/storage/secure_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_interceptor_test.mocks.dart';

@GenerateMocks([SecureStorageService, RequestInterceptorHandler])
void main() {
  late AuthInterceptor interceptor;
  late MockSecureStorageService mockStorage;
  late MockRequestInterceptorHandler mockHandler;

  setUp(() {
    mockStorage = MockSecureStorageService();
    mockHandler = MockRequestInterceptorHandler();
    interceptor = AuthInterceptor(mockStorage);
  });

  test('should append Authorization header when token exists', () async {
    when(mockStorage.getToken()).thenAnswer((_) async => 'bearer_token_123');
    final options = RequestOptions(path: '/protected');

    await interceptor.onRequest(options, mockHandler);

    expect(options.headers['Authorization'], 'Bearer bearer_token_123');
    verify(mockHandler.next(options)).called(1);
  });

  test('should not append Authorization header when token is null', () async {
    when(mockStorage.getToken()).thenAnswer((_) async => null);
    final options = RequestOptions(path: '/public');

    await interceptor.onRequest(options, mockHandler);

    expect(options.headers.containsKey('Authorization'), isFalse);
    verify(mockHandler.next(options)).called(1);
  });
}
