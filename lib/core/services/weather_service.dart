import 'package:travelmateai/config/env_config.dart';
import 'package:travelmateai/core/constants/api_constants.dart';
import 'package:travelmateai/core/network/api_client.dart';

class WeatherData {
  const WeatherData({
    required this.city,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.forecast,
  });

  final String city;
  final double temperature;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final List<WeatherForecastDay> forecast;
}

class WeatherForecastDay {
  const WeatherForecastDay({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.icon,
  });

  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String description;
  final String icon;
}

class WeatherService {
  WeatherService(this._apiClient);
  final ApiClient _apiClient;

  bool lastResultWasDemo = false;

  Future<WeatherData?> getWeather(String city) async {
    final key = EnvConfig.openWeatherApiKey;
    if (key.isEmpty) {
      lastResultWasDemo = true;
      return _demoWeather(city);
    }

    try {
      final current = await _apiClient.dio.get<Map<String, dynamic>>(
        '${ApiConstants.openWeatherBaseUrl}/weather',
        queryParameters: {'q': city, 'appid': key, 'units': 'metric'},
      );
      final forecast = await _apiClient.dio.get<Map<String, dynamic>>(
        '${ApiConstants.openWeatherBaseUrl}/forecast',
        queryParameters: {'q': city, 'appid': key, 'units': 'metric', 'cnt': 40},
      );
      lastResultWasDemo = false;
      return _parse(current.data!, forecast.data!, city);
    } catch (_) {
      lastResultWasDemo = true;
      return _demoWeather(city);
    }
  }

  WeatherData _parse(Map<String, dynamic> current, Map<String, dynamic> forecast, String city) {
    final main = current['main'] as Map<String, dynamic>;
    final weather = (current['weather'] as List).first as Map<String, dynamic>;
    final wind = current['wind'] as Map<String, dynamic>;
    final list = forecast['list'] as List<dynamic>;

    final days = <WeatherForecastDay>[];
    final seen = <String>{};
    for (final item in list) {
      final dt = DateTime.fromMillisecondsSinceEpoch((item['dt'] as int) * 1000);
      final dayKey = '${dt.year}-${dt.month}-${dt.day}';
      if (seen.contains(dayKey) || days.length >= 7) continue;
      seen.add(dayKey);
      final w = (item['weather'] as List).first as Map<String, dynamic>;
      final m = item['main'] as Map<String, dynamic>;
      days.add(WeatherForecastDay(
        date: dt,
        tempMin: (m['temp_min'] as num).toDouble(),
        tempMax: (m['temp_max'] as num).toDouble(),
        description: w['description'] as String,
        icon: w['icon'] as String,
      ));
    }

    return WeatherData(
      city: city,
      temperature: (main['temp'] as num).toDouble(),
      description: weather['description'] as String,
      icon: weather['icon'] as String,
      humidity: main['humidity'] as int,
      windSpeed: (wind['speed'] as num).toDouble(),
      forecast: days,
    );
  }

  WeatherData _demoWeather(String city) => WeatherData(
        city: city,
        temperature: 24,
        description: 'Partly cloudy',
        icon: '02d',
        humidity: 65,
        windSpeed: 12,
        forecast: List.generate(7, (i) {
          final d = DateTime.now().add(Duration(days: i));
          return WeatherForecastDay(
            date: d,
            tempMin: 18 + i.toDouble(),
            tempMax: 26 + i.toDouble(),
            description: 'Sunny',
            icon: '01d',
          );
        }),
      );
}
