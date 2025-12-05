import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  Future<LocationData?> getCurrentLocation() async {
    try {
      // Check if service is enabled
      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
        if (!_serviceEnabled) {
          print('Location services are disabled');
          return null;
        }
      }

      // Check permission
      _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location permission denied');
          return null;
        }
      }

      // Get location
      _locationData = await _location.getLocation();
      return _locationData;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  Future<double?> getLatitude() async {
    final location = await getCurrentLocation();
    return location?.latitude;
  }

  Future<double?> getLongitude() async {
    final location = await getCurrentLocation();
    return location?.longitude;
  }

  Future<bool> isLocationServiceEnabled() async {
    return await _location.serviceEnabled();
  }

  Future<bool> hasLocationPermission() async {
    final status = await _location.hasPermission();
    return status == PermissionStatus.granted ||
           status == PermissionStatus.grantedLimited;
  }

  // Check both service and permission
  Future<bool> canGetLocation() async {
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) return false;
    
    final hasPermission = await hasLocationPermission();
    return hasPermission;
  }
}