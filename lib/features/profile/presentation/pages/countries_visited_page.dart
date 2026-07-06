import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/services/sync_service.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';
import 'package:travelmateai/features/explore/data/repositories/visited_place_repository.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trips_controller.dart';
import 'package:travelmateai/shared/widgets/app_empty_view.dart';

class CountriesVisitedPage extends StatefulWidget {
  const CountriesVisitedPage({super.key});

  @override
  State<CountriesVisitedPage> createState() => _CountriesVisitedPageState();
}

class _CountriesVisitedPageState extends State<CountriesVisitedPage> {
  List<_CountryGroup> _groups = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final auth = Get.find<AuthController>();
    final userId = auth.user.value?.id;
    if (userId == null) {
      setState(() => _loading = false);
      return;
    }

    SyncServiceBinding.registerExplore();
    final placesRepo = Get.find<VisitedPlaceRepository>();
    final trips = Get.find<TripsController>();
    await placesRepo.recordFromCompletedTrips(userId, trips.trips);
    final places = await placesRepo.getAll(userId);

    final grouped = <String, List<String>>{};
    for (final place in places) {
      grouped.putIfAbsent(place.country, () => []).add(place.name);
    }

    if (mounted) {
      setState(() {
        _groups = grouped.entries
            .map((e) => _CountryGroup(country: e.key, cities: e.value.toSet().toList()))
            .toList()
          ..sort((a, b) => a.country.compareTo(b.country));
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countries Visited')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _groups.isEmpty
              ? const AppEmptyView(
                  title: 'No countries yet',
                  subtitle: 'Complete a trip and your visited places will appear here.',
                  icon: Icons.public,
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: _groups.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) {
                    final group = _groups[i];
                    return Card(
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          child: Text(group.country.isNotEmpty ? group.country[0] : '?'),
                        ),
                        title: Text(group.country),
                        subtitle: Text('${group.cities.length} place${group.cities.length == 1 ? '' : 's'}'),
                        children: group.cities
                            .map(
                              (city) => ListTile(
                                dense: true,
                                leading: const Icon(Icons.place_outlined, size: 18),
                                title: Text(city),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
    );
  }
}

class _CountryGroup {
  const _CountryGroup({required this.country, required this.cities});
  final String country;
  final List<String> cities;
}
