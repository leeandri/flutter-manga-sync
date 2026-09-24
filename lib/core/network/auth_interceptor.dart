import 'package:dio/dio.dart';
import 'package:flutter_manga_sync/core/storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. On récupère le token stocké
    final token = await _secureStorage.getToken();

    // 2. Si le token existe, on l'injecte dans le header 'Authorization'
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // 3. On laisse la requête continuer son cours
    super.onRequest(options, handler);
  }
}
