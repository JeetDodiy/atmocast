import 'package:flutter/material.dart';
import '../data/models/weather_model.dart';
import '../repositories/weather_repository.dart';

enum WeatherStatus { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _repository;

  WeatherProvider(this._repository) {
    loadRecentSearches();
  }

  WeatherStatus _status = WeatherStatus.initial;
  WeatherModel? _weather;
  String _errorMessage = '';
  List<String> _recentSearches = [];

  WeatherStatus get status => _status;
  WeatherModel? get weather => _weather;
  String get errorMessage => _errorMessage;
  List<String> get recentSearches => _recentSearches;

  Future<void> loadRecentSearches() async {
    _recentSearches = await _repository.getRecentSearches();
    notifyListeners();
  }

  Future<void> searchCity(String city) async {
    if (city.trim().isEmpty) return;

    _status = WeatherStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _weather = await _repository.getWeather(city.trim());
      _status = WeatherStatus.loaded;
      await loadRecentSearches();
    } catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
