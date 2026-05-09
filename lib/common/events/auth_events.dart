import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/features/auth/view_model/auth_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';

// Global flag to prevent multiple simultaneous logout navigation
bool _isNavigatingToAuth = false;

mixin AuthEvents {
  Future logout() async {
    if (_isNavigatingToAuth) return; // Prevent multiple logout attempts

    _isNavigatingToAuth = true;
    try {
      await eventRef.read(authViewModelProvider.notifier).removeAppId();
      Loggy("").debug("Token Removed Successfully!!!");
      await CacheManager.remove(keyToken);
      await CacheManager.remove(keyProfile);
      eventRef
          .read(profileProvider.notifier)
          .update((profile) => profile = null);

      // Longer delay to ensure cache operations complete and avoid race conditions
      await Future.delayed(const Duration(milliseconds: 250));
      moveToAuthScreen();
    } catch (e) {
      // Log error but don't rethrow to prevent UI crashes
      print('Logout error: $e');
    } finally {
      // Reset flag after a longer delay to ensure navigation completes
      Future.delayed(const Duration(milliseconds: 2000), () {
        _isNavigatingToAuth = false;
      });
    }
  }

  void moveToAuthScreen() {}

  WidgetRef get eventRef;
}
