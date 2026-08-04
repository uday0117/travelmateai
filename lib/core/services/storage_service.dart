import 'package:get_storage/get_storage.dart';
import 'package:travelmateai/core/constants/app_constants.dart';

/// Local key-value persistence via GetStorage.
class StorageService {
  StorageService(this._box);

  final GetStorage _box;

  bool get hasCompletedOnboarding =>
      _box.read<bool>(AppConstants.onboardingCompleteKey) ?? false;

  Future<void> setOnboardingComplete(bool value) =>
      _box.write(AppConstants.onboardingCompleteKey, value);

  String? get profileAvatarPath => _box.read<String>(AppConstants.profileAvatarPathKey);

  Future<void> setProfileAvatarPath(String? path) async {
    if (path == null || path.isEmpty) {
      await _box.remove(AppConstants.profileAvatarPathKey);
      return;
    }
    await _box.write(AppConstants.profileAvatarPathKey, path);
  }

  String? get profileDisplayName => _box.read<String>(AppConstants.profileDisplayNameKey);

  Future<void> setProfileDisplayName(String? name) async {
    if (name == null || name.trim().isEmpty) {
      await _box.remove(AppConstants.profileDisplayNameKey);
      return;
    }
    await _box.write(AppConstants.profileDisplayNameKey, name.trim());
  }

  String? get themeMode => _box.read<String>(AppConstants.themeModeKey);

  Future<void> setThemeMode(String mode) =>
      _box.write(AppConstants.themeModeKey, mode);

  String? get userId => _box.read<String>(AppConstants.userIdKey);

  Future<void> setUserId(String? id) =>
      _box.write(AppConstants.userIdKey, id);

  T? read<T>(String key) => _box.read<T>(key);

  Future<void> write<T>(String key, T value) => _box.write(key, value);

  Future<void> remove(String key) => _box.remove(key);

  Future<void> clear() => _box.erase();
}
