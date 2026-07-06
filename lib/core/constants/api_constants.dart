/// External API endpoints and configuration keys.
abstract final class ApiConstants {
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const String openWeatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String exchangeRateBaseUrl = 'https://v6.exchangerate-api.com/v6';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  static const int maxRetryAttempts = 3;
}
