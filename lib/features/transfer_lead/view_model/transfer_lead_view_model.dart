import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/providers/form_fields_error_notifier.dart';

import '../../../common/constants/user_type.dart';

part 'transfer_lead_view_model.g.dart';

@riverpod
class TransferLeadViewModel extends _$TransferLeadViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }
}

@riverpod
Future<Result<ApiResponse<List<User>?>?>> getUsers3(Ref ref, {int page = 1}) {
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
      .read(userRepositoryProvider)
      .getUsers(
        req: GetUsersRequest(
          type: UserType.salesConsultant.value,
          returnAll: "yes",
        ),
        page: page,
      );
}

final transferLeadUsersProvider = StateProvider<List<User>>((ref) => []);

final transferringLeadProvider = StateProvider<Lead?>((ref) => null);
final transferringLeadsProvider = StateProvider<List<Lead>>((ref) => []);
final transferLeadFollowupRequestProvider = StateProvider<LeadFollowupRequest?>(
  (ref) => null,
);
final transferLeadFormErrorsProvider =
    StateNotifierProvider<FormFieldsErrorNotifier, List<FormFieldError>>(
      (ref) => FormFieldsErrorNotifier(),
    );
