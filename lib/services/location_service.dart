import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission != LocationPermission.deniedForever;
  }

  static Future<Position?> determinePosition() async {
    bool hasPermission = await checkPermissions();
    if (hasPermission) {
      return await Geolocator.getCurrentPosition();
    }
    return null;
  }
}
