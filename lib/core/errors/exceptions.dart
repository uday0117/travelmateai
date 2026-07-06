/// Base exception for data layer errors.
sealed class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'AppException($code): $message';
}

final class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

final class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}

final class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

final class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

final class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
}

final class PermissionException extends AppException {
  const PermissionException(super.message, {super.code});
}

final class SyncException extends AppException {
  const SyncException(super.message, {super.code});
}
