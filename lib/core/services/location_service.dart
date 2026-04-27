import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'location_service_mobile.dart';
import 'location_service_web.dart';

part 'location_service.g.dart';

/// Resultado de una consulta de ubicación.
class LocationResult {
  final double latitude;
  final double longitude;
  const LocationResult({required this.latitude, required this.longitude});
}

/// Contrato para el servicio de geolocalización.
abstract class LocationService {
  /// Devuelve la ubicación actual del dispositivo.
  /// Retorna null si no hay permiso o el GPS está apagado.
  Future<LocationResult?> getCurrentLocation();

  /// Verifica si el servicio de ubicación está disponible.
  Future<bool> isLocationAvailable();
}

@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) {
  if (kIsWeb) return LocationServiceWeb();
  return LocationServiceMobile();
}
