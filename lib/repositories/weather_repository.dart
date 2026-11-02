import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/weather_model.dart';
import '../data/services/weather_api_service.dart';

class WeatherRepository {
  final WeatherApiService _apiService;
  static const String _historyKey = 'recent_searches_list';

  WeatherRepository(this._apiService);

  Future<WeatherModel> getWeather(String city) async {
    final weather = await _apiService.fetchWeatherByCity(city);
    await _saveToHistory(weather.cityName);
    return weather;
  }

  Future<void> _saveToHistory(String city) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(_historyKey) ?? [];
    list.removeWhere((item) => item.toLowerCase() == city.toLowerCase());
    list.insert(0, city);
    if (list.length > 5) {
      list = list.sublist(0, 5);
    }
    await prefs.setStringList(_historyKey, list);
  }

  Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_historyKey) ?? [];
  }
}
