import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/favorite_city.dart';
import '../models/weather_model.dart';
import '../providers/favorites_provider.dart';

class WeatherDetailPage extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherDetailPage({Key? key, required this.weatherData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(weatherData.cityName);

    return Scaffold(
      appBar: AppBar(
        title: Text(weatherData.cityName),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              if (isFavorite) {
                favoritesProvider.removeFavorite(weatherData.cityName);
              } else {
                favoritesProvider.addFavorite(
                  FavoriteCity(
                    id: weatherData.cityName,
                    name: weatherData.cityName,
                    addedAt: DateTime.now(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildWeatherIcon(),
              const SizedBox(height: 24),
              _buildWeatherDetails(),
              const SizedBox(height: 24),
              _buildSunTimes(),
              const SizedBox(height: 24),
              _buildLocalTime(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${weatherData.temperature.toStringAsFixed(1)}°',
          style: const TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          weatherData.description.toUpperCase(),
          style: const TextStyle(
            fontSize: 24,
            color: Colors.grey,
          ),
        ),
        Text(
          'Feels like ${weatherData.feelsLike.toStringAsFixed(1)}°',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildWeatherIcon() {
    return Center(
      child: Image.network(
        weatherData.iconUrl,
        width: 100,
        height: 100,
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow('Humidity', '${weatherData.humidity}%'),
            const Divider(),
            _buildDetailRow('Wind Speed', '${weatherData.windSpeed} m/s'),
            const Divider(),
            _buildDetailRow('Pressure', '1013 hPa'), // Add pressure if needed
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSunTimes() {
    final sunrise = DateTime.fromMillisecondsSinceEpoch(weatherData.sunrise * 1000);
    final sunset = DateTime.fromMillisecondsSinceEpoch(weatherData.sunset * 1000);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow('Sunrise', _formatTime(sunrise)),
            const Divider(),
            _buildDetailRow('Sunset', _formatTime(sunset)),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalTime() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Local Time: ${_formatTime(weatherData.getLocalTime())}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}