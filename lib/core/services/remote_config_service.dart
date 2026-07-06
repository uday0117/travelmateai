import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:travelmateai/core/logging/app_logger.dart';

/// Remote config and feature flags.
class RemoteConfigService {
  RemoteConfigService(this._remoteConfig);

  final FirebaseRemoteConfig _remoteConfig;

  static const _defaults = <String, dynamic>{
    'enable_ads': true,
    'enable_ai_features': true,
    'min_app_version': '1.0.0',
    'maintenance_mode': false,
    'interstitial_cooldown_minutes': 3,
  };

  Future<void> init() async {
    try {
      await _remoteConfig.setDefaults(_defaults);
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await _remoteConfig.fetchAndActivate();
    } catch (e, st) {
      AppLogger.warning('Remote config init failed', e, st);
    }
  }

  bool get enableAds => _remoteConfig.getBool('enable_ads');
  bool get enableAiFeatures => _remoteConfig.getBool('enable_ai_features');
  bool get maintenanceMode => _remoteConfig.getBool('maintenance_mode');
  int get interstitialCooldownMinutes =>
      _remoteConfig.getInt('interstitial_cooldown_minutes');
  String get minAppVersion => _remoteConfig.getString('min_app_version');

  /// Returns true when [currentVersion] is older than [minAppVersion].
  static bool isUpdateRequired({
    required String currentVersion,
    required String minAppVersion,
  }) {
    final current = _parseVersion(currentVersion);
    final minimum = _parseVersion(minAppVersion);
    for (var i = 0; i < 3; i++) {
      final c = i < current.length ? current[i] : 0;
      final m = i < minimum.length ? minimum[i] : 0;
      if (c < m) return true;
      if (c > m) return false;
    }
    return false;
  }

  static List<int> _parseVersion(String version) {
    final core = version.split('+').first.trim();
    return core
        .split('.')
        .map((part) => int.tryParse(part.trim()) ?? 0)
        .toList();
  }
}
