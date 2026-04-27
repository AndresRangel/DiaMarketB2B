import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'secure_storage_service_mobile.dart';

part 'secure_storage_service.g.dart';

/// Contrato (interfaz) para almacenamiento seguro de datos sensibles.
///
/// Los tokens de sesión, credenciales y datos privados SIEMPRE
/// se guardan a través de este servicio — nunca directamente con
/// flutter_secure_storage u otro paquete.
abstract class SecureStorageService {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}

/// Usa [SecureStorageServiceMobile] en todas las plataformas.
///
/// flutter_secure_storage soporta web de forma nativa usando localStorage.
/// La implementación in-memory para web (SecureStorageServiceWeb) fue descartada
/// porque no persiste entre recargas — haciendo imposible el preloading del tema.
/// Para este app B2B (login obligatorio, sin datos ultra-sensibles en localStorage)
/// el tradeoff es aceptable.
@Riverpod(keepAlive: true)
SecureStorageService secureStorage(Ref ref) => SecureStorageServiceMobile();
