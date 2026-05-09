import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/src/network/models/app/check_updates_request.dart';
import 'package:salesdocket_core/src/network/models/app/check_updates_response.dart';
import 'package:salesdocket_mobile/features/splash/view_model/splash_view_model.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin AppEvents on UiComponentWidget {
  Future<void> checkForUpdates({
    required String platform,
    required String version,
  }) async {
    final req = CheckUpdatesRequest(
      appPlatform: platform,
      appLocalVersion: version,
    );
    final result = await eventRef
        .read(splashViewModelProvider.notifier)
        .checkUpdates(req);

    if (!isMounted) return;
    result.when(
      success: (response) {
        final upgrade = response?.data.firstOrNull;
        onUpdateChecked(upgrade);
      },
      failure: (_) => onUpdateChecked(null),
    );
  }

  void onUpdateChecked(CheckUpdatesResponse? upgrade) {}

  WidgetRef get eventRef;
}
