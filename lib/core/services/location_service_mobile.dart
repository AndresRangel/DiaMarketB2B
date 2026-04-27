import 'package:geolocator/geolocator.dart';
import 'location_service.dart';

/// Implementación móvil de geolocalización usando el paquete geolocator.
class LocationServiceMobile implements LocationService {
  @override
  Future<LocationResult?> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> isLocationAvailable() => Geolocator.isLocationServiceEnabled();
}
