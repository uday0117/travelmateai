import 'package:get/get.dart';
import 'package:travelmateai/app/routes/app_routes.dart';
import 'package:travelmateai/core/constants/app_constants.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/core/services/search_service.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';
import 'package:travelmateai/features/documents/data/repositories/document_repository_impl.dart';
import 'package:travelmateai/features/journal/data/repositories/journal_repository.dart';
import 'package:travelmateai/features/trips/domain/entities/trip.dart';
import 'package:travelmateai/features/trips/domain/repositories/trip_repository.dart';

enum SearchResultType { trip, journal, document }

class SearchResult {
  const SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    this.trip,
  });

  final String id;
  final String title;
  final String subtitle;
  final SearchResultType type;
  final Trip? trip;
}

class AppSearchController extends GetxController {
  AppSearchController({
    required SearchService searchService,
    required TripRepository tripRepository,
    required JournalRepository journalRepository,
    required DocumentRepositoryImpl documentRepository,
  })  : _searchService = searchService,
        _tripRepository = tripRepository,
        _journalRepository = journalRepository,
        _documentRepository = documentRepository;

  final SearchService _searchService;
  final TripRepository _tripRepository;
  final JournalRepository _journalRepository;
  final DocumentRepositoryImpl _documentRepository;

  final RxString query = ''.obs;
  final RxList<SearchResult> results = <SearchResult>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxBool isSearching = false.obs;
  final Rx<SearchResultType?> filterType = Rx<SearchResultType?>(null);

  String? get _userId => Get.find<AuthController>().user.value?.id;

  @override
  void onInit() {
    super.onInit();
    _loadRecent();
    debounce(
      query,
      (_) => _performSearch(),
      time: AppConstants.debounceDuration,
    );
  }

  void _loadRecent() {
    recentSearches.assignAll(_searchService.getRecentSearches());
  }

  Future<void> _performSearch() async {
    final userId = _userId;
    final q = query.value.trim();
    if (userId == null || q.length < AppConstants.minSearchQueryLength) {
      results.clear();
      return;
    }

    isSearching.value = true;
    try {
      final lower = q.toLowerCase();
      final found = <SearchResult>[];

      if (filterType.value == null || filterType.value == SearchResultType.trip) {
        final trips = await _tripRepository.getFiltered(
          userId: userId,
          filter: TripFilter(searchQuery: q),
        );
        found.addAll(
          trips.map(
            (t) => SearchResult(
              id: t.id,
              title: t.title,
              subtitle: t.destination,
              type: SearchResultType.trip,
              trip: t,
            ),
          ),
        );
      }

      if (filterType.value == null || filterType.value == SearchResultType.journal) {
        final entries = await _journalRepository.getAll(userId);
        for (final e in entries) {
          if (e.title.toLowerCase().contains(lower) ||
              e.content.toLowerCase().contains(lower) ||
              (e.placeName?.toLowerCase().contains(lower) ?? false)) {
            found.add(
              SearchResult(
                id: e.id,
                title: e.title,
                subtitle: e.placeName ?? 'Journal entry',
                type: SearchResultType.journal,
              ),
            );
          }
        }
      }

      if (filterType.value == null || filterType.value == SearchResultType.document) {
        final docs = await _documentRepository.getAll(userId);
        for (final d in docs) {
          if (d.title.toLowerCase().contains(lower) ||
              d.type.name.toLowerCase().contains(lower)) {
            found.add(
              SearchResult(
                id: d.id,
                title: d.title,
                subtitle: d.type.name,
                type: SearchResultType.document,
              ),
            );
          }
        }
      }

      results.assignAll(found);
      await _searchService.recordSearch(q);
      _loadRecent();

      if (Get.isRegistered<AnalyticsService>()) {
        await Get.find<AnalyticsService>().logSearchUsed(
          query: q,
          resultCount: found.length,
        );
      }
    } finally {
      isSearching.value = false;
    }
  }

  void setFilter(SearchResultType? type) {
    filterType.value = type;
    _performSearch();
  }

  void applyRecentSearch(String value) {
    query.value = value;
  }

  Future<void> removeRecentSearch(String value) async {
    await _searchService.removeSearch(value);
    _loadRecent();
  }

  Future<void> clearRecentSearches() async {
    await _searchService.clearRecentSearches();
    _loadRecent();
  }

  void openResult(SearchResult result) {
    switch (result.type) {
      case SearchResultType.trip:
        if (result.trip != null) {
          Get.toNamed(AppRoutes.tripDetail, arguments: result.trip);
        }
      case SearchResultType.journal:
        Get.toNamed(AppRoutes.journal);
      case SearchResultType.document:
        Get.toNamed(AppRoutes.documents);
    }
  }
}
