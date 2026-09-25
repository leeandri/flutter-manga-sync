import 'package:dio/dio.dart';
import 'package:flutter_manga_sync/core/errors/failures.dart';
import 'package:flutter_manga_sync/core/storage/secure_storage_service.dart';

class AuthRepository {
  final Dio _dio;
  final SecureStorageService _storage;

  AuthRepository(this._dio, this._storage);

  Future<Result<String>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'https://reqres.in/api/login',
        data: {'email': email, 'password': password},
      );

      final token = response.data['token']?.toString();
      if (token == null || token.isEmpty) {
        return const Error(
          ServerFailure('Invalid response: Auth token is missing.'),
        );
      }

      await _storage.saveToken(token);
      return Success(token);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const Error(
          NetworkFailure(
            'Network error: Please check your internet connection.',
          ),
        );
      }
      final errorMessage =
          e.response?.data['error']?.toString() ??
          e.message ??
          'Authentication failed.';
      return Error(ServerFailure(errorMessage));
    } catch (e) {
      return Error(ServerFailure('Login failed: $e'));
    }
  }

  Future<Result<String>> register(String email, String password) async {
    try {
      final response = await _dio.post(
        'https://reqres.in/api/register',
        data: {'email': email, 'password': password},
      );

      final token = response.data['token']?.toString();
      if (token == null || token.isEmpty) {
        return const Error(
          ServerFailure(
            'Invalid response: Auth token is missing after registration.',
          ),
        );
      }

      await _storage.saveToken(token);
      return Success(token);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const Error(
          NetworkFailure(
            'Network error: Please check your internet connection.',
          ),
        );
      }
      final errorMessage =
          e.response?.data['error']?.toString() ??
          e.message ??
          'Registration failed.';
      return Error(ServerFailure(errorMessage));
    } catch (e) {
      return Error(ServerFailure('Registration failed: $e'));
    }
  }

  Future<Result<void>> logout() async {
    try {
      await _storage.deleteToken();
      return const Success(null);
    } catch (e) {
      return Error(CacheFailure('Failed to remove token during logout: $e'));
    }
  }

  Future<String?> getToken() async {
    return await _storage.getToken();
  }
}
