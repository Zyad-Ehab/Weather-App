import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/favorites_page.dart';
import 'pages/settings_page.dart';
import 'providers/weather_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/settings_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: 'Weather App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              // Light theme customizations
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 2,
              ),
              cardTheme: CardThemeData(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
              ),
              scaffoldBackgroundColor: Colors.grey[50],
              dialogBackgroundColor: Colors.white,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              // Dark theme customizations
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey[900],
                foregroundColor: Colors.white,
                elevation: 2,
              ),
              cardTheme: CardThemeData(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.grey[800],
              ),
              scaffoldBackgroundColor: Colors.grey[900],
              dialogBackgroundColor: Colors.grey[800],
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white70),
              ),
            ),
            themeMode: settingsProvider.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const HomePage(),
              '/favorites': (context) => const FavoritesPage(),
              '/settings': (context) => const SettingsPage(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
