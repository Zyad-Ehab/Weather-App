import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../utils/config.dart';
import '../utils/constants.dart';

class WeatherService {
  Future<WeatherData> getWeatherByCity(String cityName, String unit) async {
    final units = unit; // Now using the actual unit parameter
    final url = Uri.parse(
      '${Config.baseUrl}/weather?q=$cityName&units=$units&appid=${Config.apiKey}',
    );

    try {
      final response = await http
          .get(url)
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return WeatherData.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key');
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<WeatherData> getWeatherByLocation(double lat, double lon, String unit) async {
    final units = unit;
    final url = Uri.parse(
      '${Config.baseUrl}/weather?lat=$lat&lon=$lon&units=$units&appid=${Config.apiKey}',
    );

    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return WeatherData.fromJson(jsonData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}