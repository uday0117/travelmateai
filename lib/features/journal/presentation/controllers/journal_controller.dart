import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelmateai/core/extensions/context_extensions.dart';
import 'package:travelmateai/core/services/sync_service.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/features/journal/data/repositories/journal_repository.dart';
import 'package:travelmateai/features/journal/domain/entities/journal_entry.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trips_controller.dart';

class JournalController extends GetxController {
  JournalController(this._repo);

  final JournalRepository _repo;
  final RxList<JournalEntry> entries = <JournalEntry>[].obs;
  final RxBool isLoading = true.obs;
  final _picker = ImagePicker();

  String? get _userId => Get.find<AuthController>().user.value?.id;

  @override
  void onInit() {
    super.onInit();
    loadEntries();
  }

  Future<void> loadEntries() async {
    final uid = _userId;
    if (uid == null) return;
    isLoading.value = true;
    try {
      entries.assignAll(await _repo.getAll(uid));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addEntry({required String title, required String content, String? place}) async {
    final uid = _userId;
    final trips = Get.find<TripsController>();
    if (uid == null || trips.trips.isEmpty) {
      Get.context?.showAppSnackBar('Create a trip first', isError: true);
      return;
    }
    await _repo.create(
      userId: uid,
      tripId: trips.trips.first.id,
      title: title,
      content: content,
      placeName: place,
    );
    if (Get.isRegistered<AnalyticsService>()) {
      await Get.find<AnalyticsService>().logJournalCreated(tripId: trips.trips.first.id);
    }
    await loadEntries();
  }

  Future<void> addPhotoEntry() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    await addEntry(
      title: 'Photo memory',
      content: 'Captured at ${DateTime.now()}',
      place: image.path.split('/').last,
    );
  }

  Future<void> deleteEntry(String id) async {
    await _repo.delete(id);
    await loadEntries();
  }
}

class JournalBinding extends Bindings {
  @override
  void dependencies() {
    SyncServiceBinding.registerJournal();
    Get.lazyPut(() => JournalController(Get.find()));
  }
}
