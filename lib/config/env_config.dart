/// Environment configuration loaded from .env at startup.
abstract final class EnvConfig {
  static String geminiApiKey = '';
  static String openWeatherApiKey = '';
  static String exchangeRateApiKey = '';
  static String googleMapsApiKey = '';

  static bool get isConfigured =>
      geminiApiKey.isNotEmpty ||
      openWeatherApiKey.isNotEmpty ||
      exchangeRateApiKey.isNotEmpty ||
      googleMapsApiKey.isNotEmpty;

  static void load({
    required String gemini,
    required String openWeather,
    required String exchangeRate,
    required String googleMaps,
  }) {
    geminiApiKey = gemini;
    openWeatherApiKey = openWeather;
    exchangeRateApiKey = exchangeRate;
    googleMapsApiKey = googleMaps;
  }
}
