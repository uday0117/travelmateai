import 'package:get/get.dart';
import 'package:travelmateai/core/services/sync_service.dart';
import 'package:travelmateai/core/extensions/context_extensions.dart';
import 'package:travelmateai/core/services/ai/ai_service.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/features/packing/data/repositories/packing_repository.dart';
import 'package:travelmateai/features/packing/domain/entities/packing_list.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trips_controller.dart';
import 'package:uuid/uuid.dart';

class PackingController extends GetxController {
  PackingController(this._repo, this._ai);

  final PackingRepository _repo;
  final AiService _ai;
  final RxList<PackingList> lists = <PackingList>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isGenerating = false.obs;

  String? get _userId => Get.find<AuthController>().user.value?.id;

  @override
  void onInit() {
    super.onInit();
    loadLists();
  }

  Future<void> loadLists() async {
    final uid = _userId;
    if (uid == null) return;
    isLoading.value = true;
    try {
      lists.assignAll(await _repo.getAll(uid));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createForCurrentTrip() async {
    final uid = _userId;
    final trips = Get.find<TripsController>();
    if (uid == null || trips.trips.isEmpty) {
      Get.context?.showAppSnackBar('Create a trip first', isError: true);
      return;
    }
    final trip = trips.trips.first;
    await _repo.createForTrip(userId: uid, tripId: trip.id, title: '${trip.title} Packing');
    await loadLists();
  }

  Future<void> toggleItem(PackingList list, String itemId) async {
    final items = list.items.map((i) {
      if (i.id == itemId) return i.copyWith(isChecked: !i.isChecked);
      return i;
    }).toList();
    await _repo.save(list.copyWith(items: items));
    final allChecked = items.isNotEmpty && items.every((i) => i.isChecked);
    if (allChecked && Get.isRegistered<AnalyticsService>()) {
      await Get.find<AnalyticsService>().logPackingCompleted(tripId: list.tripId);
    }
    await loadLists();
  }

  Future<void> addCustomItem(PackingList list, String title) async {
    final item = PackingItem(
      id: const Uuid().v4(),
      title: title,
      category: PackingCategory.custom,
      isCustom: true,
    );
    await _repo.save(list.copyWith(items: [...list.items, item]));
    await loadLists();
  }

  Future<void> generateAiSuggestions(PackingList list) async {
    isGenerating.value = true;
    try {
      final trips = Get.find<TripsController>();
      final trip = trips.trips.where((t) => t.id == list.tripId).firstOrNull;
      final items = await _ai.suggestPacking(
        destination: trip?.destination ?? 'unknown destination',
        durationDays: trip?.durationDays ?? 7,
      );
      final newItems = items.map((l) => PackingItem(
            id: const Uuid().v4(),
            title: l,
            category: PackingCategory.custom,
            isCustom: true,
          )).toList();
      await _repo.save(list.copyWith(items: [...list.items, ...newItems]));
      await loadLists();
      Get.context?.showAppSnackBar('AI suggestions added');
    } catch (_) {
      Get.context?.showAppSnackBar('AI unavailable — add items manually', isError: true);
    } finally {
      isGenerating.value = false;
    }
  }
}

class PackingBinding extends Bindings {
  @override
  void dependencies() {
    SyncServiceBinding.registerPacking();
    Get.lazyPut(() => PackingController(Get.find(), Get.find()));
  }
}
