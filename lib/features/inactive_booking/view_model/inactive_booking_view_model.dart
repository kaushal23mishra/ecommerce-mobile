import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/providers/form_fields_error_notifier.dart';

part 'inactive_booking_view_model.g.dart';

@riverpod
class InactiveBookingViewModel extends _$InactiveBookingViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }
}

final inactiveBookingLeadProvider = StateProvider<Lead?>((ref) => null);
final inactiveBookingRequestProvider = StateProvider<ChangeLeadStatusRequest?>(
  (ref) => null,
);
final inactiveBookingFormErrorsProvider =
    StateNotifierProvider<FormFieldsErrorNotifier, List<FormFieldError>>(
      (ref) => FormFieldsErrorNotifier(),
    );
