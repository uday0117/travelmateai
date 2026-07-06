import 'package:get_storage/get_storage.dart';
import 'package:travelmateai/core/constants/home_constants.dart';

/// Persists recently viewed destination names locally.
class RecentDestinationsService {
  RecentDestinationsService(this._storage);

  final GetStorage _storage;
  static const _maxItems = 12;

  List<String> getRecent() {
    final list = _storage.read<List<dynamic>>(HomeConstants.recentDestinationsKey);
    return list?.cast<String>() ?? [];
  }

  Future<void> record(String destination) async {
    final trimmed = destination.trim();
    if (trimmed.isEmpty) return;

    final recent = getRecent().where((d) => d != trimmed).toList();
    recent.insert(0, trimmed);
    await _storage.write(
      HomeConstants.recentDestinationsKey,
      recent.take(_maxItems).toList(),
    );
  }

  Future<void> clear() => _storage.remove(HomeConstants.recentDestinationsKey);
}
