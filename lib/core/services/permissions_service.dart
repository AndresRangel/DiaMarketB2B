import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'permissions_service_mobile.dart';
import 'permissions_service_web.dart';

part 'permissions_service.g.dart';

/// Contrato para el servicio de permisos del dispositivo.
abstract class PermissionsService {
  Future<bool> requestCamera();
  Future<bool> requestLocation();
  Future<bool> requestNotifications();
  Future<bool> isCameraGranted();
  Future<bool> isLocationGranted();
}

@Riverpod(keepAlive: true)
PermissionsService permissionsService(Ref ref) {
  if (kIsWeb) return PermissionsServiceWeb();
  return PermissionsServiceMobile();
}
