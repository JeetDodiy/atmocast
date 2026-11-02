import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/errors/app_exceptions.dart';
import '../models/weather_model.dart';

class WeatherApiService {
  final http.Client client;
  WeatherApiService({http.Client? client}) : client = client ?? http.Client();

  Future<WeatherModel> fetchWeatherByCity(String city) async {
    // WeatherAPI endpoint structure
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/current.json?key=${ApiConstants.apiKey}&q=$city&aqi=no',
    );

    try {
      final response = await client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 400) {
        // WeatherAPI uses 400 for bad queries (like city not found)
        final data = json.decode(response.body);
        final errorMessage = data['error']['message'] ?? 'City not found.';
        throw AppException(errorMessage);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw AppException('Invalid or unauthorized API key.');
      } else {
        throw AppException('Server returned status: ${response.statusCode}');
      }
    } on SocketException {
      throw AppException('No internet connection. Please verify network.');
    } on FormatException {
      throw AppException('Invalid data format received from server.');
    }
  }
}
