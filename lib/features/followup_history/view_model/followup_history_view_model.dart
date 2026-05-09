import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';

part 'followup_history_view_model.g.dart';

@riverpod
class FollowupHistoryViewModel extends _$FollowupHistoryViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }
}

@riverpod
Future<Result<ApiResponse<ApiResponse<List<LeadHistory>?>?>>> leadHistory(
  Ref ref, {
  required int leadId,
  int page = 1,
}) {
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

  return ref
      .watch(leadRepositoryProvider)
      .getLeadHistory(leadId: leadId, page: page);
}

final followupHistoryLead = StateProvider<Lead?>((ref) => null);
