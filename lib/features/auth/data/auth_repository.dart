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
      final token = response.data['token']?.toString() ?? 'token_jwt_secour';
      await _storage.write(key: 'jwt_token', value: token);
      return token;
    } catch (e) {
      throw Exception('Erreur d’authentification : ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }
}
