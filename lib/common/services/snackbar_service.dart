import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_ui_component/ui_component_manager.dart';

/// Global snackbar service that can show snackbars without requiring a BuildContext
class SnackbarService {
  SnackbarService._();

  static final SnackbarService _instance = SnackbarService._();
  static SnackbarService get instance => _instance;

  GlobalKey<ScaffoldMessengerState>? _messengerKey;

  /// Initialize the service with the global ScaffoldMessenger key
  /// Call this once in your app's main scaffold
  void init(GlobalKey<ScaffoldMessengerState> key) {
    _messengerKey = key;
  }

  /// Show a snackbar globally
  /// Defers showing to next frame to avoid "deactivated widget ancestor" errors
  void showSnackBar(
    String message, {
    SnackBarType type = SnackBarType.error,
  }) {
    // Defer to next frame to ensure widget tree is stable
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final messengerState = _messengerKey?.currentState;
        if (messengerState == null || !messengerState.mounted) {
          debugPrint('SnackbarService: MessengerState not available');
          return;
        }

        final appColors = UiComponentManager().appColors;
        var backgroundColor = appColors.textPrimary;

        switch (type) {
          case SnackBarType.error:
            backgroundColor = appColors.error;
            break;
          case SnackBarType.success:
            backgroundColor = appColors.success;
            break;
          case SnackBarType.warning:
            backgroundColor = appColors.warning;
            break;
          default:
            break;
        }

        final snackBar = SnackBar(
          content: Text(message.tr()),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: backgroundColor,
          elevation: 4,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        );

        messengerState.showSnackBar(snackBar);
      } catch (e) {
        debugPrint('SnackbarService: Error showing snackbar - $e');
      }
    });
  }
}

/// Convenience function to show snackbar globally
void showGlobalSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
  SnackbarService.instance.showSnackBar(message, type: type);
}
