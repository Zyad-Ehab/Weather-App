import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // THEME SETTING
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'App Theme',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<ThemeMode>(
                          title: const Text('Light'),
                          value: ThemeMode.light,
                          groupValue: settingsProvider.themeMode,
                          onChanged: (value) {
                            settingsProvider.updateThemeMode(value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<ThemeMode>(
                          title: const Text('Dark'),
                          value: ThemeMode.dark,
                          groupValue: settingsProvider.themeMode,
                          onChanged: (value) {
                            settingsProvider.updateThemeMode(value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<ThemeMode>(
                          title: const Text('System'),
                          value: ThemeMode.system,
                          groupValue: settingsProvider.themeMode,
                          onChanged: (value) {
                            settingsProvider.updateThemeMode(value!);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // TEMPERATURE UNIT
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Temperature Unit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: const Text('Celsius (°C)'),
                          value: 'metric',
                          groupValue: settingsProvider.temperatureUnit,
                          onChanged: (value) {
                            settingsProvider.updateTemperatureUnit(value.toString());
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: const Text('Fahrenheit (°F)'),
                          value: 'imperial',
                          groupValue: settingsProvider.temperatureUnit,
                          onChanged: (value) {
                            settingsProvider.updateTemperatureUnit(value.toString());
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // GPS SETTING
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Use GPS Location',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Automatically detect your location',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  Switch(
                    value: settingsProvider.useGps,
                    onChanged: (value) {
                      settingsProvider.toggleUseGps(value);
                    },
                  ),
                ],
              ),
            ),
          ),

          // ABOUT SECTION
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text('Weather App v1.0.0'),
                  const SizedBox(height: 8),
                  const Text('Data provided by OpenWeatherMap'),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Show licenses
                    },
                    child: const Text('View Licenses'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}