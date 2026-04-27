import 'permissions_service.dart';

/// Implementación web de permisos.
/// En web los permisos los maneja el navegador directamente —
/// no existe permission_handler. Se retorna true como no-op
/// para no bloquear el flujo; el navegador pedirá el permiso
/// cuando el feature lo necesite.
class PermissionsServiceWeb implements PermissionsService {
  @override
  Future<bool> requestCamera() async => true;

  @override
  Future<bool> requestLocation() async => true;

  @override
  Future<bool> requestNotifications() async => true;

  @override
  Future<bool> isCameraGranted() async => true;

  @override
  Future<bool> isLocationGranted() async => true;
}
