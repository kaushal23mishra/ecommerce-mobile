import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/notification/view_model/notification_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin NotificationEvents on UiComponentWidget {
  Future fetchNotifications({
    int page = 1,
    GetNotificationRequest? request,
  }) async {
    showLoader();
    final result = await eventRef
        .read(notificationViewModelProvider.notifier)
        .fetchNotifications(page: page, request: request);

    if (!isMounted) return;
    result.when(
      success: (data) {
        hideLoader();
        onNotificationsFetched(data?.data);
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future readNotifications({required ReadNotificationsRequest request}) async {
    showLoader();
    final result = await eventRef
        .read(notificationViewModelProvider.notifier)
        .readNotification(request: request);

    if (!isMounted) return;
    result.when(
      success: (data) {
        hideLoader();
        onNotificationRead();
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future readAllNotifications() async {
    showLoader();
    final result =
        await eventRef
            .read(notificationViewModelProvider.notifier)
            .readAllNotification();

    if (!isMounted) return;
    result.when(
      success: (data) {
        hideLoader();
        onAllNotificationRead();
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  void onNotificationRead() {}

  void onAllNotificationRead() {}

  void onNotificationsFetched(
    ApiResponse<List<SalesdocketNotification>?>? data,
  ) {}

  void showLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(true);
  }

  void hideLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(false);
  }

  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {}

  WidgetRef get eventRef;
}
