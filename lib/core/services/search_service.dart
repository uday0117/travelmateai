import 'package:get_storage/get_storage.dart';
import 'package:travelmateai/core/constants/app_constants.dart';

/// Persists recent search queries for fast recall.
class SearchService {
  SearchService(this._box);

  final GetStorage _box;

  static const _storageKey = 'recent_searches';
  static const _maxRecent = 10;

  List<String> getRecentSearches() {
    final raw = _box.read<List<dynamic>>(_storageKey);
    if (raw == null) return [];
    return raw.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
  }

  Future<void> recordSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < AppConstants.minSearchQueryLength) return;

    final recent = getRecentSearches()
      ..removeWhere((s) => s.toLowerCase() == trimmed.toLowerCase());
    recent.insert(0, trimmed);

    await _box.write(
      _storageKey,
      recent.take(_maxRecent).toList(),
    );
  }

  Future<void> removeSearch(String query) async {
    final recent = getRecentSearches()
      ..removeWhere((s) => s.toLowerCase() == query.toLowerCase());
    await _box.write(_storageKey, recent);
  }

  Future<void> clearRecentSearches() async {
    await _box.remove(_storageKey);
  }
}
