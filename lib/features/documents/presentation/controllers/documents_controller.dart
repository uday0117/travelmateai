import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:travelmateai/core/extensions/context_extensions.dart';
import 'package:travelmateai/core/repositories/base_repository.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/core/services/sync_service.dart';
import 'package:travelmateai/features/documents/data/repositories/document_repository_impl.dart';
import 'package:travelmateai/features/documents/domain/entities/travel_document.dart';
import 'package:uuid/uuid.dart';

class DocumentsController extends GetxController {
  DocumentsController(this._repo);

  final DocumentRepositoryImpl _repo;
  final RxList<TravelDocument> documents = <TravelDocument>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isUnlocked = false.obs;
  final _auth = LocalAuthentication();

  String? get _userId => Get.find<AuthController>().user.value?.id;

  Future<bool> unlockVault() async {
    try {
      final can = await _auth.canCheckBiometrics;
      if (!can) {
        isUnlocked.value = true;
        return true;
      }
      isUnlocked.value = await _auth.authenticate(
        localizedReason: 'Unlock document vault',
        options: const AuthenticationOptions(biometricOnly: false),
      );
      return isUnlocked.value;
    } catch (_) {
      isUnlocked.value = true;
      return true;
    }
  }

  Future<void> loadDocuments() async {
    final uid = _userId;
    if (uid == null || !isUnlocked.value) return;
    isLoading.value = true;
    try {
      documents.assignAll(await _repo.getAll(uid));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDocument({
    required String title,
    required DocumentType type,
    required String notes,
    DateTime? expiry,
  }) async {
    final uid = _userId;
    if (uid == null) return;
    final now = DateTime.now();
    await _repo.save(
      TravelDocument(
        id: const Uuid().v4(),
        userId: uid,
        title: title,
        type: type,
        expiryDate: expiry,
        syncStatus: SyncStatus.pending,
        createdAt: now,
        updatedAt: now,
      ),
      plainNotes: notes,
    );
    if (Get.isRegistered<AnalyticsService>()) {
      await Get.find<AnalyticsService>().logDocumentUploaded();
    }
    Get.context?.showAppSnackBar('Document saved securely');
    await loadDocuments();
  }

  String? getNotes(TravelDocument doc) => _repo.decryptNotes(doc);

  Future<void> deleteDocument(String id) async {
    await _repo.delete(id);
    await loadDocuments();
  }
}

class DocumentsBinding extends Bindings {
  @override
  void dependencies() {
    SyncServiceBinding.registerDocuments();
    Get.lazyPut(() => DocumentsController(Get.find()));
  }
}
