import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'jwt_token';

  SecureStorageService(this._storage);

  String? _inMemoryToken;

  Future<void> saveToken(String token) async {
    _inMemoryToken = token;
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      print(
        'Warning: Secure storage unavailable ($e). Using in-memory fallback.',
      );
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      return token ?? _inMemoryToken;
    } catch (e) {
      return _inMemoryToken;
    }
  }

  Future<void> deleteToken() async {
    _inMemoryToken = null;
    try {
      await _storage.delete(key: _tokenKey);
    } catch (e) {
      // Ignore cleanup error on Linux fallback
    }
  }

  Future<void> write({required String key, required String value}) async {
    if (key == _tokenKey) {
      await saveToken(value);
    } else {
      try {
        await _storage.write(key: key, value: value);
      } catch (_) {}
    }
  }

  Future<void> delete({required String key}) async {
    if (key == _tokenKey) {
      await deleteToken();
    } else {
      try {
        await _storage.delete(key: key);
      } catch (_) {}
    }
  }

  Future<String?> read({required String key}) async {
    if (key == _tokenKey) {
      return await getToken();
    }
    try {
      return await _storage.read(key: key);
    } catch (_) {
      return null;
    }
  }
}
