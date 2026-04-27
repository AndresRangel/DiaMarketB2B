import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_storage_service.dart';

/// Implementación móvil del almacenamiento seguro.
/// Usa flutter_secure_storage que internamente usa:
/// - iOS/macOS: Keychain
/// - Android: AES con KeyStore
class SecureStorageServiceMobile implements SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'session_token';

  @override
  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  @override
  Future<String?> getToken() => _storage.read(key: _tokenKey);

  @override
  Future<void> deleteToken() => _storage.delete(key: _tokenKey);

  @override
  Future<void> saveString(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> getString(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}
