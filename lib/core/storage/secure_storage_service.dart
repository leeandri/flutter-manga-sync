import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'jwt_token';

  SecureStorageService(this._storage);

  // Variable de secours en mémoire si le Keyring Linux est verrouillé
  String? _inMemoryToken;

  Future<void> saveToken(String token) async {
    _inMemoryToken = token;
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      // Fallback gracieux sur Linux Desktop si libsecret échoue
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
}
