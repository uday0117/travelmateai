import 'package:travelmateai/core/errors/exceptions.dart';
import 'package:travelmateai/core/errors/failures.dart';

/// Maps exceptions from the data layer to domain failures.
abstract final class ErrorMapper {
  static Failure mapException(Object error) {
    return switch (error) {
      ServerException(:final message, :final code) =>
        ServerFailure(message, code: code),
      CacheException(:final message, :final code) =>
        CacheFailure(message, code: code),
      NetworkException(:final message, :final code) =>
        NetworkFailure(message, code: code),
      AuthException(:final message, :final code) =>
        AuthFailure(message, code: code),
      ValidationException(:final message, :final code) =>
        ValidationFailure(message, code: code),
      PermissionException(:final message, :final code) =>
        PermissionFailure(message, code: code),
      SyncException(:final message, :final code) =>
        SyncFailure(message, code: code),
      Failure failure => failure,
      _ => UnknownFailure(error.toString()),
    };
  }

  static String userMessage(Failure failure) {
    return switch (failure) {
      NetworkFailure() =>
        'No internet connection. Your changes will sync when you\'re back online.',
      AuthFailure() => failure.message,
      ValidationFailure() => failure.message,
      PermissionFailure() => failure.message,
      ServerFailure() => 'Something went wrong on our servers. Please try again.',
      CacheFailure() => 'Unable to load local data. Please restart the app.',
      SyncFailure() => 'Sync failed. We\'ll retry automatically.',
      UnknownFailure() => 'An unexpected error occurred. Please try again.',
    };
  }
}
