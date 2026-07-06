import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/core/services/weather_service.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/home/presentation/controllers/home_controller.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trips_controller.dart';
import 'package:travelmateai/shared/widgets/app_loading_view.dart';
import 'package:travelmateai/shared/widgets/demo_data_banner.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _cityCtrl = TextEditingController();
  WeatherData? _weather;
  bool _loading = true;
  bool _isDemo = false;

  @override
  void initState() {
    super.initState();
    _cityCtrl.text = _defaultCity();
    _load();
  }

  String _defaultCity() {
    if (Get.isRegistered<HomeController>() && Get.find<HomeController>().weather.value != null) {
      return Get.find<HomeController>().weather.value!.city;
    }
    final trips = Get.isRegistered<TripsController>() ? Get.find<TripsController>() : null;
    final dest = trips?.activeTrips.firstOrNull?.destination ??
        trips?.upcomingTrips.firstOrNull?.destination;
    if (dest != null) return dest.split(',').first.trim();
    return 'London';
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final weather = Get.find<WeatherService>();
    final w = await weather.getWeather(_cityCtrl.text.trim());
    if (mounted) {
      setState(() {
        _weather = w;
        _isDemo = weather.lastResultWasDemo;
        _loading = false;
      });
    }
    if (Get.isRegistered<AnalyticsService>() && w != null) {
      await Get.find<AnalyticsService>().logWeatherViewed(city: w.city);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: _loading
          ? const AppLoadingView()
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                if (_isDemo)
                  const DemoDataBanner(
                    message: 'Sample weather — add OPENWEATHER_API_KEY to .env for live data.',
                  ),
                if (_isDemo) const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cityCtrl,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          prefixIcon: Icon(Icons.location_city_outlined),
                        ),
                        onSubmitted: (_) => _load(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    FilledButton(
                      onPressed: _load,
                      child: const Text('Go'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                if (_weather != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          Text(
                            _weather!.city,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '${_weather!.temperature.toStringAsFixed(1)}°C',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          Text(
                            _weather!.description[0].toUpperCase() +
                                _weather!.description.substring(1),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Humidity ${_weather!.humidity}% · Wind ${_weather!.windSpeed} m/s',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('7-Day Forecast', style: Theme.of(context).textTheme.titleMedium),
                  ..._weather!.forecast.map(
                    (d) => ListTile(
                      title: Text('${d.date.day}/${d.date.month}'),
                      subtitle: Text(d.description),
                      trailing: Text(
                        '${d.tempMin.toStringAsFixed(0)}° / ${d.tempMax.toStringAsFixed(0)}°',
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    super.dispose();
  }
}
