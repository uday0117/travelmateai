import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:travelmateai/app/routes/app_routes.dart';
import 'package:travelmateai/core/constants/home_constants.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/core/services/currency_service.dart';
import 'package:travelmateai/core/services/weather_service.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/home/presentation/controllers/home_controller.dart';
import 'package:travelmateai/features/home/presentation/widgets/home_dashboard_widgets.dart';
import 'package:travelmateai/features/maps/presentation/pages/maps_page.dart';
import 'package:travelmateai/shared/widgets/ad_native_widget.dart';
import 'package:travelmateai/shared/widgets/app_loading_view.dart';

class ExploreTabPage extends StatefulWidget {
  const ExploreTabPage({super.key});

  @override
  State<ExploreTabPage> createState() => _ExploreTabPageState();
}

class _ExploreTabPageState extends State<ExploreTabPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  WeatherData? _weather;
  Map<String, double> _rates = {};
  final _amountCtrl = TextEditingController(text: '100');
  String _from = 'USD';
  String _to = 'EUR';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
    _load();
  }

  Future<void> _load() async {
    final weather = Get.find<WeatherService>();
    final currency = Get.find<CurrencyService>();
    final w = await weather.getWeather('London');
    final r = await currency.getRates();
    if (mounted) {
      setState(() {
        _weather = w;
        _rates = r;
        _loading = false;
      });
    }
  }

  void _openDestination(String destination) {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().recordDestinationView(destination);
    }
    Get.toNamed(AppRoutes.createTrip);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.travel_explore), text: 'Discover'),
            Tab(icon: Icon(Icons.wb_sunny_outlined), text: 'Weather'),
            Tab(icon: Icon(Icons.currency_exchange), text: 'Currency'),
            Tab(icon: Icon(Icons.map_outlined), text: 'Maps'),
          ],
        ),
      ),
      body: _loading
          ? const AppLoadingView()
          : TabBarView(
              controller: _tabs,
              children: [
                _discoverTab(),
                _weatherTab(),
                _currencyTab(),
                const MapsView(logAnalytics: true),
              ],
            ),
    );
  }

  Widget _discoverTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text(
          'Travel Inspiration',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Trending destinations, weekend getaways & hidden gems',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Get.toNamed(AppRoutes.aiHub),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Destination Ideas',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          'Get personalized recommendations from Gemini',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Get.toNamed(AppRoutes.toolsHub),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(
                    Icons.widgets_outlined,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 32,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Travel Tools',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          'Visa checker, phrasebook, emergency contacts & more',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const HomeSectionHeader(title: 'Trending Destinations'),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: HomeConstants.trendingDestinations.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, i) {
              final d = HomeConstants.trendingDestinations[i];
              return HomeDestinationCard(
                title: d.name,
                subtitle: '${d.category} · ${d.country}',
                emoji: d.emoji,
                gradient: d.gradient,
                onTap: () => _openDestination('${d.name}, ${d.country}'),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const HomeSectionHeader(title: 'Weekend Trips'),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: HomeConstants.weekendTrips.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, i) {
              final d = HomeConstants.weekendTrips[i];
              return HomeDestinationCard(
                title: d.name,
                subtitle: d.country,
                emoji: d.emoji,
                gradient: d.gradient,
                onTap: () => _openDestination('${d.name}, ${d.country}'),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const AdNativeWidget(templateType: TemplateType.medium),
        const SizedBox(height: AppSpacing.lg),
        const HomeSectionHeader(title: 'Hidden Gems'),
        const SizedBox(height: AppSpacing.md),
        ...HomeConstants.hiddenGems.map(
          (d) => Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ListTile(
              leading: Text(d.emoji, style: const TextStyle(fontSize: 28)),
              title: Text(d.name),
              subtitle: Text('${d.category} · ${d.country}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openDestination('${d.name}, ${d.country}'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _weatherTab() {
    final w = _weather;
    if (w == null) return const Center(child: Text('Weather unavailable'));
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Text(w.city, style: Theme.of(context).textTheme.titleLarge),
                Text(
                  '${w.temperature.toStringAsFixed(1)}°C',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(w.description[0].toUpperCase() + w.description.substring(1)),
                Text('Humidity ${w.humidity}% · Wind ${w.windSpeed} m/s'),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('7-Day Forecast', style: Theme.of(context).textTheme.titleMedium),
        ...w.forecast.map(
          (d) => ListTile(
            title: Text('${d.date.day}/${d.date.month}'),
            subtitle: Text(d.description),
            trailing: Text(
              '${d.tempMin.toStringAsFixed(0)}° / ${d.tempMax.toStringAsFixed(0)}°',
            ),
          ),
        ),
      ],
    );
  }

  Widget _currencyTab() {
    final rate = _rates[_to] ?? 1;
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          TextField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixIcon: Icon(Icons.attach_money),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _from,
                  items: _rates.keys
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    setState(() => _from = v ?? _from);
                    _logCurrencyConversion();
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.arrow_forward),
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _to,
                  items: _rates.keys
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    setState(() => _to = v ?? _to);
                    _logCurrencyConversion();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                '${(amount * rate).toStringAsFixed(2)} $_to',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _logCurrencyConversion() {
    if (Get.isRegistered<AnalyticsService>()) {
      Get.find<AnalyticsService>().logCurrencyConverted(from: _from, to: _to);
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }
}
