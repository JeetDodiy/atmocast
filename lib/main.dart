import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/services/weather_api_service.dart';
import 'repositories/weather_repository.dart';
import 'providers/weather_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = WeatherApiService();
  final repository = WeatherRepository(apiService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider(repository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AtmoCast',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF8DE), // Lightest yellow
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8CA9FF),
          primary: const Color(0xFF8CA9FF), // Darker blue
          secondary: const Color(0xFFAAC4F5), // Lighter blue
          surface: const Color(0xFFFFF2C6), // Light yellow
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8CA9FF),
          foregroundColor: Colors.white,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFFFFF2C6),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
