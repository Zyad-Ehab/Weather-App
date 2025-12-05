import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';  // Add this import
import 'settings_provider.dart';
import 'package:provider/provider.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();  // Add this
  WeatherData? _currentWeather;
  bool _isLoading = false;
  String _error = '';

  WeatherData? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchWeather(String city, BuildContext context) async {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final unit = settingsProvider.temperatureUnit;
    
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getWeatherByCity(city, unit);
      _error = '';
    } catch (e) {
      _error = e.toString();
      _currentWeather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByLocation(BuildContext context) async {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final unit = settingsProvider.temperatureUnit;
    
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final locationData = await _locationService.getCurrentLocation();
      
      if (locationData == null) {
        throw Exception('Could not get current location. Please enable location services.');
      }
      
      _currentWeather = await _weatherService.getWeatherByLocation(
        locationData.latitude!,
        locationData.longitude!,
        unit,
      );
      
      _error = '';
    } catch (e) {
      _error = 'Location error: ${e.toString()}';
      _currentWeather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}