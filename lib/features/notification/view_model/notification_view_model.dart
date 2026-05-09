import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';

part 'notification_view_model.g.dart';

@riverpod
class NotificationViewModel extends _$NotificationViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }

  Future<Result<ApiResponse<ApiResponse<List<SalesdocketNotification>?>?>?>>
  fetchNotifications({int page = 1, GetNotificationRequest? request}) {
    return ref
        .read(notificationRepositoryProvider)
        .getNotifications(page: page, request: request);
  }

  Future<Result> readNotification({required ReadNotificationsRequest request}) {
    return ref.read(notificationRepositoryProvider).readNotifications(request);
  }

  Future<Result> readAllNotification() {
    return ref.read(notificationRepositoryProvider).readAllNotifications();
  }
}

final notificationsDataProvider =
    StateProvider<ApiResponse<List<SalesdocketNotification>?>?>((ref) => null);
final notificationListCountProvider = StateProvider<String>((ref) => "");

@riverpod
Future<Result<ApiResponse<ApiResponse<List<SalesdocketNotification>?>?>?>>
notifications(Ref ref, {int page = 1, GetNotificationRequest? req}) async {
  final cancelToken = CancelToken();
  // When a page is no-longer used, keep it in the cache.
  final link = ref.keepAlive();
  // Declare a timer to be used by the callbacks below
  Timer? timer;
  // When the provider is destroyed, cancel the http request and the timer
  ref.onDispose(() {
    cancelToken.cancel();
    timer?.cancel();
  });
  // When the last listener is removed, start the timer
  ref.onCancel(() {
    timer = Timer(const Duration(seconds: 30), () {
      // Dispose the cached data on timeout
      link.close();
    });
  });
  // If the provider is listened again after it was paused, cancel the timer
  ref.onResume(() {
    timer?.cancel();
  });

  final response = await ref
      .watch(notificationRepositoryProvider)
      .getNotifications(page: page, request: req);

  response.when(
    success: (data) {
      final currentPage = data?.data?.currentPage ?? 0;
      final lastPage = data?.data?.lastPage ?? 0;
      final total = data?.data?.total ?? 0;
      final currentCount = data?.data?.to ?? 0;

      if (lastPage < currentPage && total != 0) return;
      ref
          .read(notificationListCountProvider.notifier)
          .update((state) => state = "$currentCount/$total");
    },
    failure: (error) {},
  );

  return response;
}
