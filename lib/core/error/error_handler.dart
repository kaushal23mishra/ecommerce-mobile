import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_core/src/network/app_error.dart';

/// Centralized error handling service
@immutable
class ErrorHandler {
  const ErrorHandler();

  /// Handle error and show appropriate UI feedback
  void handle(AppError error, {VoidCallback? onRetry, BuildContext? context}) {
    // Log error for debugging
    _logError(error);

    // Handle based on error type
    switch (error.type) {
      case AppErrorType.unauthorized:
        _handleUnauthorized();
        break;
      case AppErrorType.network:
        _showNetworkError(onRetry, context);
        break;
      case AppErrorType.server:
        _showServerError(error.message, context);
        break;
      case AppErrorType.timeout:
        _showTimeoutError(onRetry, context);
        break;
      default:
        _showGenericError(error.message, context);
    }
  }

  void _logError(AppError error) {
    debugPrint('═══════════════════════════════════════');
    debugPrint('AppError Occurred');
    debugPrint('Type: ${error.type}');
    debugPrint('Message: ${error.message}');
    debugPrint('Status Code: ${error.statusCode}');
    debugPrint('═══════════════════════════════════════');
  }

  void _handleUnauthorized() {
    // Clear auth cache to force logout
    // The AuthGuard will automatically redirect to login screen
    CacheManager.remove(keyToken);
    CacheManager.remove(keyProfile);
    debugPrint('Unauthorized error - auth cache cleared, user will be logged out');
  }

  void _showNetworkError(VoidCallback? onRetry, BuildContext? context) {
    _showSnackBar(
      'No internet connection. Please check your network.',
      context: context,
      action:
          onRetry != null
              ? SnackBarAction(label: 'Retry', onPressed: onRetry)
              : null,
    );
  }

  void _showServerError(String? message, BuildContext? context) {
    _showSnackBar(
      message ?? 'Server error. Please try again later.',
      context: context,
    );
  }

  void _showTimeoutError(VoidCallback? onRetry, BuildContext? context) {
    _showSnackBar(
      'Request timeout. Please try again.',
      context: context,
      action:
          onRetry != null
              ? SnackBarAction(label: 'Retry', onPressed: onRetry)
              : null,
    );
  }

  void _showGenericError(String? message, BuildContext? context) {
    _showSnackBar(message ?? 'An unexpected error occurred', context: context);
  }

  void _showSnackBar(
    String message, {
    BuildContext? context,
    SnackBarAction? action,
  }) {
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: action,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      debugPrint('SnackBar Message: $message');
    }
  }
}

/// Provider for error handler
final errorHandlerProvider = Provider<ErrorHandler>((ref) {
  return const ErrorHandler();
});

/// Extension for Result error handling
extension ResultErrorHandling<T> on Result<T> {
  /// Log error if result is failure
  Result<T> logError() {
    ifFailure((error) {
      debugPrint('Error: ${error.type} - ${error.message}');
    });
    return this;
  }

  /// Handle error with ErrorHandler
  Result<T> handleError(
    Ref ref, {
    VoidCallback? onRetry,
    BuildContext? context,
  }) {
    ifFailure((error) {
      ref
          .read(errorHandlerProvider)
          .handle(error, onRetry: onRetry, context: context);
    });
    return this;
  }
}
