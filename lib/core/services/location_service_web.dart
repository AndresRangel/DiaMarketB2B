import 'location_service.dart';

/// Implementación web de geolocalización.
/// Usa la Geolocation API del navegador — requiere HTTPS y permiso del usuario.
class LocationServiceWeb implements LocationService {
  @override
  Future<LocationResult?> getCurrentLocation() async {
    // TODO(fase9-web): implementar con dart:html Geolocation API
    return null;
  }

  @override
  Future<bool> isLocationAvailable() async => false;
}
