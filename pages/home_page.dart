import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/search_bar.dart';
import '../widgets/weather_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_display.dart';
import 'weather_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    // Check if GPS location should be used on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkGpsSetting(context);
    });
  }

  void _checkGpsSetting(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    
    if (settingsProvider.useGps) {
      // Fetch weather for current location
      weatherProvider.fetchWeatherByLocation(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          // GPS Location Button
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return IconButton(
                icon: Icon(
                  settings.useGps ? Icons.location_on : Icons.location_off,
                  color: settings.useGps ? Colors.green : null,
                ),
                onPressed: () async {
                  if (settings.useGps) {
                    // Fetch current location weather
                    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
                    await weatherProvider.fetchWeatherByLocation(context);
                  }
                },
                tooltip: 'Get current location weather',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchBarWidget(
                  controller: _searchController,
                  onSearch: (city) {
                    if (city.isNotEmpty) {
                      _searchHistory.insert(0, city);
                      if (_searchHistory.length > 5) {
                        _searchHistory.removeLast();
                      }
                      weatherProvider.fetchWeather(city, context);
                      _searchController.clear();
                    }
                  },
                ),
              ),
              
              Consumer<SettingsProvider>(
                builder: (context, settings, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (settings.useGps)
                          Chip(
                            avatar: const Icon(Icons.location_on, size: 16),
                            label: const Text('Using GPS'),
                            backgroundColor: Colors.green.withOpacity(0.2),
                          ),
                        Chip(
                          label: Text(
                            settings.temperatureUnit == 'metric' 
                              ? '°C' 
                              : '°F',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.blue.withOpacity(0.2),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              if (_searchHistory.isNotEmpty)
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _searchHistory.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Chip(
                          label: Text(_searchHistory[index]),
                          onDeleted: () {
                            setState(() {
                              _searchHistory.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              
              Expanded(
                child: _buildBody(weatherProvider),
              ),
            ],
          );
        },
      ),
      // Add Floating Action Button for GPS location
      floatingActionButton: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          if (settings.useGps) {
            return FloatingActionButton(
              onPressed: () {
                final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
                weatherProvider.fetchWeatherByLocation(context);
              },
              child: const Icon(Icons.my_location),
              backgroundColor: Colors.green,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(WeatherProvider weatherProvider) {
    if (weatherProvider.isLoading) {
      return const LoadingIndicatorWidget();
    }
    
    if (weatherProvider.error.isNotEmpty) {
      return ErrorDisplayWidget(
        message: weatherProvider.error,
        onRetry: () {
          if (_searchHistory.isNotEmpty) {
            weatherProvider.fetchWeather(_searchHistory.first, context);
          }
        },
      );
    }
    
    if (weatherProvider.currentWeather != null) {
      final weather = weatherProvider.currentWeather!;
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WeatherDetailPage(weatherData: weather),
            ),
          );
        },
        child: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return WeatherCardWidget(
              weatherData: weather,
              unit: settings.temperatureUnit,
            );
          },
        ),
      );
    }
    
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Search for a city to see weather',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}