import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  Map<String, dynamic> _settings = {
    'temperatureUnit': 'metric',
    'language': 'en',
    'useGps': false,
    'themeMode': 0,
  };

  Map<String, dynamic> get settings => _settings;
  ThemeMode get themeMode => ThemeMode.values[_settings['themeMode'] as int];
  String get temperatureUnit => _settings['temperatureUnit'] as String;
  bool get useGps => _settings['useGps'] as bool;

  Future<void> loadSettings() async {
    _settings = await _storageService.getSettings();
    notifyListeners();
  }

  Future<void> updateTemperatureUnit(String unit) async {
    _settings['temperatureUnit'] = unit;
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> toggleUseGps(bool value) async {
    _settings['useGps'] = value;
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    _settings['themeMode'] = mode.index;
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }
}