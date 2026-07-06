import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/errors/exceptions.dart';
import 'package:travelmateai/core/errors/error_mapper.dart';
import 'package:travelmateai/core/errors/failures.dart';
import 'package:travelmateai/core/extensions/context_extensions.dart';
import 'package:travelmateai/core/services/crash_reporting_service.dart';

/// Centralized error handling — maps errors to friendly messages and optional retry.
class ErrorHandler {
  ErrorHandler._();

  static Failure toFailure(Object error) => ErrorMapper.mapException(error);

  static String messageFor(Object error) =>
      ErrorMapper.userMessage(toFailure(error));

  static void showError(
    Object error, {
    VoidCallback? onRetry,
    bool logNonFatal = true,
  }) {
    final failure = toFailure(error);
    final message = ErrorMapper.userMessage(failure);

    if (logNonFatal && failure is UnknownFailure) {
      _recordNonFatal(error);
    }

    final context = Get.context;
    if (context == null) return;

    if (onRetry != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Theme.of(context).colorScheme.onError,
            onPressed: onRetry,
          ),
        ),
      );
    } else {
      context.showAppSnackBar(message, isError: true);
    }
  }

  static void showFailure(
    Failure failure, {
    VoidCallback? onRetry,
  }) {
    showError(failure, onRetry: onRetry, logNonFatal: failure is UnknownFailure);
  }

  static IconData iconFor(Object error) {
    final failure = toFailure(error);
    return switch (failure) {
      NetworkFailure() => Icons.wifi_off_rounded,
      AuthFailure() => Icons.lock_outline_rounded,
      PermissionFailure() => Icons.block_rounded,
      ValidationFailure() => Icons.info_outline_rounded,
      SyncFailure() => Icons.sync_problem_rounded,
      ServerFailure() => Icons.cloud_off_rounded,
      CacheFailure() => Icons.storage_rounded,
      _ => Icons.error_outline_rounded,
    };
  }

  static void _recordNonFatal(Object error) {
    if (!Get.isRegistered<CrashReportingService>()) return;
    final stack = error is Error ? error.stackTrace : StackTrace.current;
    Get.find<CrashReportingService>().recordError(error, stack);
  }

  /// Maps common Firebase / Dio style errors into typed exceptions.
  static Object normalize(Object error) {
    if (error is Failure) return error;
    if (error is AppException) return error;

    final text = error.toString().toLowerCase();
    if (text.contains('socket') ||
        text.contains('network') ||
        text.contains('connection')) {
      return const NetworkException('No internet connection');
    }
    if (text.contains('timeout') || text.contains('timed out')) {
      return const NetworkException('Request timed out. Please try again.');
    }
    if (text.contains('permission') || text.contains('denied')) {
      return const PermissionException('Permission denied');
    }
    if (text.contains('firebase') || text.contains('firestore')) {
      return ServerException(error.toString());
    }
    return error;
  }
}
