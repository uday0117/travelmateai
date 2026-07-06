import 'package:get/get.dart';
import 'package:travelmateai/core/errors/error_handler.dart';
import 'package:travelmateai/core/errors/exceptions.dart';
import 'package:travelmateai/core/network/network_info.dart';
import 'package:travelmateai/core/constants/app_constants.dart';
import 'package:travelmateai/core/services/database_service.dart';
import 'package:travelmateai/core/services/storage_service.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';
import 'package:travelmateai/features/documents/data/datasources/document_remote_datasource.dart';
import 'package:travelmateai/features/documents/data/repositories/document_repository_impl.dart';
import 'package:travelmateai/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:travelmateai/features/explore/data/datasources/travel_stats_remote_datasource.dart';
import 'package:travelmateai/features/explore/data/datasources/visited_place_remote_datasource.dart';
import 'package:travelmateai/features/explore/data/repositories/travel_stats_repository.dart';
import 'package:travelmateai/features/explore/data/repositories/visited_place_repository.dart';
import 'package:travelmateai/features/favorites/data/repositories/favorite_repository.dart';
import 'package:travelmateai/features/journal/data/datasources/journal_remote_datasource.dart';
import 'package:travelmateai/features/journal/data/repositories/journal_repository.dart';
import 'package:travelmateai/features/packing/data/datasources/packing_remote_datasource.dart';
import 'package:travelmateai/features/packing/data/repositories/packing_repository.dart';
import 'package:travelmateai/features/trips/domain/repositories/trip_repository.dart';

class SyncService extends GetxService {
  SyncService(this._networkInfo, this._storageService);

  final NetworkInfo _networkInfo;
  final StorageService _storageService;

  final RxBool isSyncing = false.obs;
  bool _activeSync = false;

  Future<bool> syncAll() async {
    if (_activeSync) return false;
    if (!await _networkInfo.isConnected) {
      ErrorHandler.showError(
        const NetworkException('No internet connection'),
      );
      return false;
    }

    _activeSync = true;
    isSyncing.value = true;
    try {
      SyncServiceBinding.registerAll();

      if (Get.isRegistered<TripRepository>()) {
        await Get.find<TripRepository>().sync();
      }
      if (Get.isRegistered<ExpenseRepositoryImpl>()) {
        await Get.find<ExpenseRepositoryImpl>().sync();
      }

      final userId = Get.isRegistered<AuthController>()
          ? Get.find<AuthController>().user.value?.id
          : null;

      if (userId != null) {
        if (Get.isRegistered<FavoriteRepository>()) {
          await Get.find<FavoriteRepository>().sync(userId);
        }
        if (Get.isRegistered<DocumentRepositoryImpl>()) {
          await Get.find<DocumentRepositoryImpl>().sync(userId);
        }
        if (Get.isRegistered<JournalRepository>()) {
          await Get.find<JournalRepository>().sync(userId);
        }
        if (Get.isRegistered<PackingRepository>()) {
          await Get.find<PackingRepository>().sync(userId);
        }
        if (Get.isRegistered<TravelStatsRepository>()) {
          await Get.find<TravelStatsRepository>().sync(userId);
        }
        if (Get.isRegistered<VisitedPlaceRepository>()) {
          await Get.find<VisitedPlaceRepository>().sync(userId);
        }
      }

      await _storageService.write(
        AppConstants.lastBackupAtKey,
        DateTime.now().toIso8601String(),
      );
      return true;
    } catch (e) {
      ErrorHandler.showError(ErrorHandler.normalize(e), onRetry: syncAll);
      return false;
    } finally {
      _activeSync = false;
      isSyncing.value = false;
    }
  }

  DateTime? get lastBackupAt {
    final raw = _storageService.read<String>(AppConstants.lastBackupAtKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  void startAutoSync() {
    _networkInfo.onConnectivityChanged.listen((connected) {
      if (connected) syncAll();
    });
  }
}

class SyncServiceBinding {
  static void registerAll() {
    registerFavorites();
    registerExplore();
    registerDocuments();
    registerJournal();
    registerPacking();
  }

  static void registerFavorites() {
    if (!Get.isRegistered<FavoriteRepository>()) {
      Get.lazyPut(() => FavoriteRepository(Get.find<DatabaseService>()));
    }
  }

  static void registerExplore() {
    if (!Get.isRegistered<TravelStatsRepository>()) {
      Get.lazyPut(
        () => TravelStatsRepository(
          Get.find<DatabaseService>(),
          networkInfo: Get.find<NetworkInfo>(),
          remote: TravelStatsRemoteDataSource(),
        ),
      );
    }
    if (!Get.isRegistered<VisitedPlaceRepository>()) {
      Get.lazyPut(
        () => VisitedPlaceRepository(
          Get.find<DatabaseService>(),
          networkInfo: Get.find<NetworkInfo>(),
          remote: VisitedPlaceRemoteDataSource(),
        ),
      );
    }
  }

  static void registerDocuments() {
    if (!Get.isRegistered<DocumentLocalDataSource>()) {
      Get.lazyPut(() => DocumentLocalDataSource(Get.find(), Get.find()));
    }
    if (!Get.isRegistered<DocumentRepositoryImpl>()) {
      Get.lazyPut(
        () => DocumentRepositoryImpl(
          local: Get.find(),
          remote: DocumentRemoteDataSource(),
          networkInfo: Get.find<NetworkInfo>(),
        ),
      );
    }
  }

  static void registerJournal() {
    if (!Get.isRegistered<JournalRepository>()) {
      Get.lazyPut(
        () => JournalRepository(
          Get.find<DatabaseService>(),
          networkInfo: Get.find<NetworkInfo>(),
          remote: JournalRemoteDataSource(),
        ),
      );
    }
  }

  static void registerPacking() {
    if (!Get.isRegistered<PackingRepository>()) {
      Get.lazyPut(
        () => PackingRepository(
          Get.find<DatabaseService>(),
          networkInfo: Get.find<NetworkInfo>(),
          remote: PackingRemoteDataSource(),
        ),
      );
    }
  }
}
