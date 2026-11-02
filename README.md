# AtmoCast Weather 🌤️

AtmoCast is a beautifully designed, modern Flutter application that provides real-time weather metrics and interactive location mapping. Built with a strict adherence to Clean Architecture, it serves as a robust portfolio piece demonstrating state management, networking, and responsive UI design.

## Features ✨
* **Real-time Weather:** Fetches live temperature, humidity, and wind speed (in km/h) using the WeatherAPI.
* **Interactive Mapping:** Features a fully integrated, pannable, and zoomable OpenStreetMap view centered directly on the searched city.
* **Search History:** Automatically caches your 5 most recent searches using `shared_preferences` and displays them as quick-action chips.
* **State Management:** Utilizes `Provider` to cleanly handle explicitly defined UI states (`initial`, `loading`, `loaded`, `error`).
* **Error Handling:** Robustly catches network failures, offline states, and invalid API keys to display user-friendly error messages.

## App Workflow 🔄
1. **Launch (`initial` state):** The app opens to a clean search bar and prompts the user to enter a city name. If previous searches exist in local storage, they are displayed as actionable chips.
2. **Search (`loading` state):** The user types a city (e.g., "New Delhi") and hits enter. The UI transitions to a loading spinner.
3. **Network Request:** 
    * `WeatherProvider` calls the `WeatherRepository`.
    * The repository asks `WeatherApiService` to execute the HTTP GET request to WeatherAPI.
4. **Data Parsing:** The raw JSON is intercepted by `WeatherModel` and safely mapped to Dart objects (extracting temperature, custom icons, wind in km/h, and lat/long coordinates).
5. **Persistence:** `WeatherRepository` intercepts the successful fetch and saves the city name to `SharedPreferences`.
6. **Result (`loaded` state):** `WeatherProvider` notifies the UI. The screen splits into two sections:
    * **Top:** A beautiful card detailing the weather metrics.
    * **Bottom:** A `flutter_map` widget smoothly rendering an OpenStreetMap view pinned exactly to the city's coordinates.

## Architecture Structure 🏗️
The project strictly separates concerns to ensure scalability and testability:
* **`core/`**: App-wide constants (like API keys) and custom Exception classes.
* **`data/`**: The raw data layer. Contains the `WeatherModel` (JSON parsing) and `WeatherApiService` (HTTP requests).
* **`repositories/`**: The coordinator. `WeatherRepository` acts as the single source of truth, managing both the API service and local caching (`shared_preferences`).
* **`providers/`**: The business logic layer. `WeatherProvider` manages the `WeatherStatus` enum and holds the current weather data.
* **`presentation/`**: The UI layer. `HomeScreen` listens to the provider and rebuilds reactively.

## Tech Stack 🛠️
* **Framework:** Flutter (Dart 3+)
* **State Management:** `provider`
* **Networking:** `http`
* **Local Storage:** `shared_preferences`
* **Mapping:** `flutter_map` & `latlong2`

## How to Run 🚀
1. Ensure you have the Flutter SDK installed.
2. Clone this repository.
3. Run `flutter pub get` to fetch dependencies.
4. Open `lib/core/constants/api_constants.dart` and verify your WeatherAPI key is present.
5. Run `flutter run`.
# atmocast
