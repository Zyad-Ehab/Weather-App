import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/favorite_city.dart';

class StorageService {
  static const String _favoritesKey = 'favorite_cities';
  static const String _settingsKey = 'app_settings';

  Future<List<FavoriteCity>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoritesKey);
    
    if (jsonString == null) {
      return [];
    }
    
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((item) => FavoriteCity.fromJson(item)).toList();
    } catch (e) {
      print('Error parsing favorites: $e');
      return [];
    }
  }

  Future<void> saveFavorite(FavoriteCity city) async {
    // ... existing code ...
  }

  Future<void> removeFavorite(String cityId) async {
    // ... existing code ...
  }

  Future<void> _saveFavorites(List<FavoriteCity> favorites) async {
    // ... existing code ...
  }

  // Get settings as Map (simpler version)
  Future<Map<String, dynamic>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_settingsKey);
    
    if (jsonString == null) {
      return {
        'temperatureUnit': 'metric',
        'language': 'en',
        'useGps': false,
        'themeMode': 0, // 0 = system, 1 = light, 2 = dark
      };
    }
    
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      print('Error parsing settings: $e');
      return {
        'temperatureUnit': 'metric',
        'language': 'en',
        'useGps': false,
        'themeMode': 0,
      };
    }
  }

  // Save settings as Map
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString(_settingsKey, jsonEncode(settings));
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  // Helper methods for specific settings
  Future<void> saveTemperatureUnit(String unit) async {
    final settings = await getSettings();
    settings['temperatureUnit'] = unit;
    await saveSettings(settings);
  }

  Future<void> saveUseGps(bool useGps) async {
    final settings = await getSettings();
    settings['useGps'] = useGps;
    await saveSettings(settings);
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final settings = await getSettings();
    settings['themeMode'] = mode.index;
    await saveSettings(settings);
  }
}