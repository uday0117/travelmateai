import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:travelmateai/core/logging/app_logger.dart';

/// Local Isar database manager for offline-first storage.
class DatabaseService {
  Isar? _isar;

  Isar? get isar => _isar;

  bool get isReady => _isar != null;

  Future<void> init(List<CollectionSchema> schemas) async {
    if (_isar != null) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        schemas,
        directory: dir.path,
        name: 'travelmateai',
      );
      AppLogger.info('Isar database initialized');
    } catch (e, st) {
      AppLogger.error('Isar init failed', e, st);
      rethrow;
    }
  }

  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }

  Future<void> clearAll() async {
    final isar = _isar;
    if (isar == null) return;
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
