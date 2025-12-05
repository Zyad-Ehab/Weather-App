🌤️ Flutter Weather App

A feature-rich Flutter mobile application that provides real-time weather information using the OpenWeatherMap Current Weather API. Built with clean architecture, state management, and persistent local storage.

📋 Table of Contents

Features

Installation

API Configuration

Project Structure

Running the App

Real-Time API Calls

Building & Deployment

Troubleshooting

Contributing

License

✨ Features
✅ Core Features

Real-time weather data for any city worldwide

Multi-page navigation with clean routing

Favorite cities with persistent local storage

Temperature unit toggle (°C / °F)

Dark/Light theme support

GPS-based weather fetching (optional)

📱 Screens

Home / Search Screen

Weather Details Screen

Favorites Screen

Settings Screen

🔧 Technical Features

Clean Architecture

Provider / Riverpod / GetX / BLoC (whichever you implemented)

Error handling for:

Invalid city

No internet connection

API errors (401/404)

Pull-to-refresh

Loading indicators

Responsive UI

🚀 Installation
Prerequisites

Flutter SDK 3.0+

Android Studio or VS Code

Git

OpenWeatherMap API Key

Step-by-Step Setup
1. Clone the repository
git clone https://github.com/yourusername/weather-app.git
cd weather-app

2. Install dependencies
flutter pub get

3. Get your OpenWeatherMap API Key

Visit https://openweathermap.org

Create an account

Go to API Keys

Generate a new key

4. Configure the API key

Create a file:

lib/utils/config.dart


Add:

class Config {
  static const String apiKey = 'YOUR_API_KEY_HERE';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
}


⚠️ Do not upload your API key — add config.dart to .gitignore.

🔧 API Configuration
API Endpoints Used

Fetch by city name

https://api.openweathermap.org/data/2.5/weather?q={city}&units={unit}&appid={API_KEY}


Fetch by GPS coordinates

https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&units={unit}&appid={API_KEY}

Free Tier Limits

60 calls/min

~1M calls/month

Data updates every ~10 minutes

📁 Project Structure
weather_app/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── weather_model.dart
│   │   ├── favorite_city.dart
│   │   └── app_settings.dart
│   ├── providers/
│   │   ├── weather_provider.dart
│   │   ├── favorites_provider.dart
│   │   └── settings_provider.dart
│   ├── services/
│   │   └── weather_service.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── details_screen.dart
│   │   ├── favorites_screen.dart
│   │   └── settings_screen.dart
│   ├── widgets/
│   └── utils/
│       ├── config.dart
│       └── helpers.dart

▶️ Running the App

Run on emulator or real device:

flutter run


To specify device:

flutter devices
flutter run -d device_id

🌍 Real-Time API Calls

Weather fetching logic example:

Future<WeatherModel> fetchWeather(String city) async {
  final url = '${Config.baseUrl}/weather?q=$city&units=metric&appid=${Config.apiKey}';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('City not found or API error');
  }

  return WeatherModel.fromJson(json.decode(response.body));
}

📦 Building & Deployment
Build APK
flutter build apk --release


APK will be located in:

build/app/outputs/flutter-apk/app-release.apk

Build App Bundle (Play Store)
flutter build appbundle --release

🛠️ Troubleshooting
Issue	Fix
API not working	Check API key and rate limits
"City not found"	Validate city name in English
App crashes on start	Ensure config.dart exists
GPS permission denied	Enable location manually
🤝 Contributing

Pull requests are welcome!
If you'd like to improve UI, architecture, or add features, feel free to fork and submit changes.
