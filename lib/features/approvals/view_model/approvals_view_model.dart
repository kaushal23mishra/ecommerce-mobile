import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/approval_type.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/providers/form_fields_error_notifier.dart';

part 'approvals_view_model.g.dart';

@riverpod
class ApprovalsViewModel extends _$ApprovalsViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }

  Future<Result<ApiResponse?>> sendRequestForApproval(
    int leadId, {
    DiscountApproval? request,
  }) {
    return ref
        .read(discountRepositoryProvider)
        .sendRequestForApproval(leadId, request);
  }

  Future<Result<ApiResponse<DiscountApproval?>?>> sendApproval(
    int leadId, {
    DiscountApprovalRequest? request,
  }) {
    return ref.read(discountRepositoryProvider).sendApproval(leadId, request);
  }

  Future<Result<ApiResponse?>> sendDeliveryRequestForApproval(
    int deliveryId, {
    DiscountApproval? request,
  }) {
    return ref
        .read(discountRepositoryProvider)
        .sendDeliveryRequestForApproval(deliveryId, request);
  }

  Future<Result<ApiResponse<DiscountApproval?>?>> sendDeliveryApproval(
    int deliveryId, {
    DiscountApprovalRequest? request,
  }) {
    return ref
        .read(discountRepositoryProvider)
        .sendDeliveryApproval(deliveryId, request);
  }
}

final discountApprovalLeadRequestProvider = StateProvider<Lead?>((ref) => null);
final discountApprovalFormErrorsProvider =
    StateNotifierProvider<FormFieldsErrorNotifier, List<FormFieldError>>(
      (ref) => FormFieldsErrorNotifier(),
    );
final discountApprovalRequestProvider = StateProvider<DiscountApproval?>(
  (ref) => null,
);
final moreDiscountApprovalReasonsProvider = StateProvider<List<String>>(
  (ref) => [],
);
final approvalTypeProvider = StateProvider<ApprovalType?>((ref) => null);
final discountApprovalUsersProvider = StateProvider<List<User>>((ref) => []);
final deliveryApprovalRequestProvider = StateProvider<Delivery?>((ref) => null);
