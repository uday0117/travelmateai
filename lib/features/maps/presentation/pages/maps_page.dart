import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maps')),
      body: const MapsView(logAnalytics: true),
    );
  }
}

class MapsView extends StatefulWidget {
  const MapsView({super.key, this.logAnalytics = false});

  final bool logAnalytics;

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  static const _defaultLocation = LatLng(51.5074, -0.1278);

  @override
  void initState() {
    super.initState();
    if (widget.logAnalytics && Get.isRegistered<AnalyticsService>()) {
      Get.find<AnalyticsService>().logMapOpened();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _defaultLocation,
              zoom: 12,
            ),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: {
              Marker(
                markerId: const MarkerId('trip'),
                position: _defaultLocation,
                infoWindow: const InfoWindow(title: 'London'),
              ),
            },
          ),
        ),
        SizedBox(
          height: 72,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppSpacing.sm),
            children: const [
              _PlaceChip(icon: Icons.hotel, label: 'Hotels', query: 'hotels'),
              _PlaceChip(icon: Icons.local_hospital, label: 'Hospitals', query: 'hospitals'),
              _PlaceChip(icon: Icons.local_police, label: 'Police', query: 'police station'),
              _PlaceChip(icon: Icons.atm, label: 'ATMs', query: 'ATMs'),
              _PlaceChip(icon: Icons.local_gas_station, label: 'Fuel', query: 'gas station'),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlaceChip extends StatelessWidget {
  const _PlaceChip({
    required this.icon,
    required this.label,
    required this.query,
  });
  final IconData icon;
  final String label;
  final String query;

  Future<void> _openSearch() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent('$query near me')}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ActionChip(
        avatar: Icon(icon, size: 18),
        label: Text(label),
        onPressed: _openSearch,
      ),
    );
  }
}
