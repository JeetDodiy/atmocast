import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../providers/weather_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch() {
    FocusScope.of(context).unfocus();
    context.read<WeatherProvider>().searchCity(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AtmoCast Weather'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter city name (e.g., Rajkot, London)',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _onSearch,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Consumer<WeatherProvider>(
              builder: (context, provider, _) {
                if (provider.recentSearches.isEmpty) return const SizedBox.shrink();
                return SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.recentSearches.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final city = provider.recentSearches[index];
                      return ActionChip(
                        label: Text(city),
                        backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                        onPressed: () {
                          _searchController.text = city;
                          provider.searchCity(city);
                        },
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<WeatherProvider>(
                builder: (context, provider, _) {
                  switch (provider.status) {
                    case WeatherStatus.initial:
                      return const Center(
                        child: Text(
                          'Search for a city to see live weather metrics.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    case WeatherStatus.loading:
                      return const Center(child: CircularProgressIndicator());
                    case WeatherStatus.error:
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              provider.errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    case WeatherStatus.loaded:
                      final w = provider.weather!;
                      return Column(
                        children: [
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    w.cityName, 
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    )
                                  ),
                                  const SizedBox(height: 8),
                                  Image.network(
                                    w.iconUrl, // Use the full URL provided by WeatherAPI
                                    width: 80,
                                    height: 80,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.cloud, size: 64),
                                  ),
                                  Text(
                                    '${w.temperature.toStringAsFixed(1)}°C',
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    w.description.toUpperCase(),
                                    style: const TextStyle(letterSpacing: 1.2),
                                  ),
                                  const Divider(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          const Icon(Icons.water_drop_outlined, color: Colors.blue),
                                          const SizedBox(height: 4),
                                          Text('${w.humidity}%'),
                                          const Text('Humidity', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Icon(Icons.air, color: Colors.teal),
                                          const SizedBox(height: 4),
                                          Text('${w.windSpeed.toStringAsFixed(1)} km/h'),
                                          const Text('Wind Speed', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FlutterMap(
                                options: MapOptions(
                                  initialCenter: LatLng(w.latitude, w.longitude),
                                  initialZoom: 12.0,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.example.atmocast',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: LatLng(w.latitude, w.longitude),
                                        width: 80,
                                        height: 80,
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
