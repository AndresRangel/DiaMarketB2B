import 'package:permission_handler/permission_handler.dart';
import 'permissions_service.dart';

/// Implementación móvil de permisos usando permission_handler.
class PermissionsServiceMobile implements PermissionsService {
  @override
  Future<bool> requestCamera() async =>
      (await Permission.camera.request()).isGranted;

  @override
  Future<bool> requestLocation() async =>
      (await Permission.locationWhenInUse.request()).isGranted;

  @override
  Future<bool> requestNotifications() async =>
      (await Permission.notification.request()).isGranted;

  @override
  Future<bool> isCameraGranted() async =>
      (await Permission.camera.status).isGranted;

  @override
  Future<bool> isLocationGranted() async =>
      (await Permission.locationWhenInUse.status).isGranted;
}
