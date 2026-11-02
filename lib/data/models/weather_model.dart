class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final String iconUrl;
  final int humidity;
  final double windSpeed;
  final double latitude;
  final double longitude;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconUrl,
    required this.humidity,
    required this.windSpeed,
    required this.latitude,
    required this.longitude,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['location']['name'] ?? '',
      temperature: (json['current']['temp_c'] as num).toDouble(),
      description: json['current']['condition']['text'] ?? '',
      iconUrl: 'https:${json['current']['condition']['icon']}', // weatherapi provides full URL (without https:)
      humidity: json['current']['humidity'] ?? 0,
      windSpeed: (json['current']['wind_kph'] as num).toDouble(), // Keep in km/h directly
      latitude: (json['location']['lat'] as num).toDouble(),
      longitude: (json['location']['lon'] as num).toDouble(),
    );
  }
}
