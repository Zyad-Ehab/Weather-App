import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherCardWidget extends StatelessWidget {
  final WeatherData weatherData;
  final String unit;

  const WeatherCardWidget({
    Key? key, 
    required this.weatherData,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format wind speed based on unit
    String windSpeedText;
    if (unit == 'imperial') {
      windSpeedText = '${(weatherData.windSpeed * 2.237).toStringAsFixed(1)} mph';
    } else {
      windSpeedText = '${weatherData.windSpeed} m/s';
    }

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  weatherData.cityName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Image.network(
                  weatherData.iconUrl,
                  width: 50,
                  height: 50,
                  color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white 
                    : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${weatherData.temperature.toStringAsFixed(1)}${unit == 'metric' ? '°C' : '°F'}',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              weatherData.description.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              'Feels like ${weatherData.feelsLike.toStringAsFixed(1)}${unit == 'metric' ? '°C' : '°F'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherInfo('Humidity', '${weatherData.humidity}%', context),
                _buildWeatherInfo('Wind', windSpeedText, context),
                _buildWeatherInfo('Pressure', '1013 hPa', context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(String label, String value, BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}