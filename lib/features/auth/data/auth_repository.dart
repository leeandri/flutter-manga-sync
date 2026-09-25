import 'package:dio/dio.dart';
import 'package:flutter_manga_sync/core/storage/secure_storage_service.dart';

class AuthRepository {
  final Dio _dio;
  final SecureStorageService _storage;

  AuthRepository(this._dio, this._storage);

  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'https://reqres.in/api/login',
        data: {'email': email, 'password': password},
      );

      final token = response.data['token']?.toString() ?? 'mock_jwt_token_123';
      await _storage.saveToken(token);
      return token;
    } on DioException catch (e) {
      throw Exception('Network error or invalid credentials: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    await _storage.deleteToken();
  }

  Future<String?> getToken() async {
    return await _storage.getToken();
  }
}
