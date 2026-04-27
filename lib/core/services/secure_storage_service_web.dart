import 'secure_storage_service.dart';

/// Implementación web del almacenamiento seguro.
/// En web no existe keychain, así que usamos un mapa en memoria.
/// IMPORTANTE: estos datos se pierden al cerrar la pestaña — es intencional.
/// Para web, el token de sesión no debe persistir en localStorage (inseguro).
class SecureStorageServiceWeb implements SecureStorageService {
  final Map<String, String> _memory = {};
  static const _tokenKey = 'session_token';

  @override
  Future<void> saveToken(String token) async => _memory[_tokenKey] = token;

  @override
  Future<String?> getToken() async => _memory[_tokenKey];

  @override
  Future<void> deleteToken() async => _memory.remove(_tokenKey);

  @override
  Future<void> saveString(String key, String value) async =>
      _memory[key] = value;

  @override
  Future<String?> getString(String key) async => _memory[key];

  @override
  Future<void> delete(String key) async => _memory.remove(key);

  @override
  Future<void> deleteAll() async => _memory.clear();
}
