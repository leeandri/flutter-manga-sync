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

      final token = response.data['token']?.toString();
      if (token == null || token.isEmpty) {
        throw Exception('Invalid response: Auth token is missing.');
      }

      await _storage.saveToken(token);
      return token;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Network error: Please check your internet connection.',
        );
      }
      final errorMessage =
          e.response?.data['error'] ?? e.message ?? 'Authentication failed.';
      throw Exception('Login failed: $errorMessage');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<String> register(String email, String password) async {
    try {
      final response = await _dio.post(
        'https://reqres.in/api/register',
        data: {'email': email, 'password': password},
      );

      final token = response.data['token']?.toString();
      if (token == null || token.isEmpty) {
        throw Exception(
          'Invalid response: Auth token is missing after registration.',
        );
      }

      await _storage.saveToken(token);
      return token;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Network error: Please check your internet connection.',
        );
      }
      final errorMessage =
          e.response?.data['error'] ?? e.message ?? 'Registration failed.';
      throw Exception('Registration failed: $errorMessage');
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    await _storage.deleteToken();
  }

  Future<String?> getToken() async {
    return await _storage.getToken();
  }
}
