import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/weather_provider.dart';
// import '../providers/settings_provider.dart';  // Add this import
import 'weather_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);
    // final settingsProvider = Provider.of<SettingsProvider>(context);  // Add this

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cities'),
      ),
      body: favoritesProvider.favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No favorite cities yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favoritesProvider.favorites.length,
              itemBuilder: (context, index) {
                final city = favoritesProvider.favorites[index];
                return ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(city.name),
                  subtitle: Text('Added ${_formatDate(city.addedAt)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      favoritesProvider.removeFavorite(city.id);
                    },
                  ),
                  onTap: () async {
                    try {
                      // FIXED: Pass context instead of 'metric'
                      await weatherProvider.fetchWeather(city.name, context);
                      
                      if (weatherProvider.currentWeather != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeatherDetailPage(
                              weatherData: weatherProvider.currentWeather!,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to load weather for ${city.name}'),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}