import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/action.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/receipt.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/providers/form_fields_error_notifier.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';

part 'receipt_view_model.g.dart';

@riverpod
class ReceiptViewModel extends _$ReceiptViewModel {
  @override
  FutureOr<void> build() {
    // return a value (or do nothing if the return type is void)
  }

  Future<Result<ApiResponse>> addReceipt({Receipt? request}) {
    return ref.read(receiptsRepositoryProvider).addReceipt(req: request);
  }

  Future<Result<ApiResponse>> updateReceipt(int receiptId, {Receipt? request}) {
    return ref
        .read(receiptsRepositoryProvider)
        .updateReceipt(receiptId, req: request);
  }

  Future<Result<ApiResponse<List<Receipt>?>>> fetchReceipts({
    required int leadId,
  }) {
    return ref.read(receiptsRepositoryProvider).fetchReceipts(leadId);
  }

  Future<Result<ApiResponse<List<ReceiptReason>?>>> fetchReceiptReasons({
    required int leadId,
  }) {
    return ref.read(receiptsRepositoryProvider).fetchReceiptReasons(leadId);
  }

  Future<Result<ApiResponse>> sendReceiptReason({ReceiptReason? request}) {
    return ref.read(receiptsRepositoryProvider).sendReceiptReason(req: request);
  }

  Future<Result<ApiResponse>> updateReceiptReason(
    int receiptReasonId, {
    ReceiptReason? request,
  }) {
    return ref
        .read(receiptsRepositoryProvider)
        .updateReceiptReason(receiptReasonId, req: request);
  }
  FormFieldError? validateAmountCap() {
    final request = ref.read(sendReceiptRequestProvider);
    if (request?.type != ReceiptType.postDelivery.value ||
        request?.paymentType == null) {
      return null;
    }

    final maxAmount = ref.read(receiptAmountCapProvider);
    final enteredAmount = request?.amount ?? 0;
    if (maxAmount > 0 && enteredAmount > maxAmount) {
      return FormFieldError(
        field: ReceiptFormFields.receiptAmount,
        message: LocaleKeys.errAmountExceedsPending.tr(
          namedArgs: {'amount': '$maxAmount'},
        ),
      );
    }
    return null;
  }

  void prepareAddDeliveryReceipt(Lead lead) {
    ref.read(receiptLeadProvider.notifier).update(lead);
    ref.read(receiptSourceProvider.notifier).update(ReceiptType.postDelivery);
    ref.read(sendReceiptRequestProvider.notifier).update(
      Receipt(leadId: lead.id, type: ReceiptType.postDelivery.value),
    );
  }

  void prepareViewDeliveryReceipt(Lead lead) {
    ref.read(receiptLeadProvider.notifier).update(lead);
    ref.read(receiptSourceProvider.notifier).update(ReceiptType.postDelivery);
    ref.read(canEditReceiptProvider.notifier).set(false);
  }

    List<LeadListItemMenuAction> filterDeliveryReceiptActions({
    required List<LeadListItemMenuAction> actions,
    required int? leadId,
  }) {
    if (leadId == null) return actions;
    final visibility = ref.read(deliveryReceiptMenuVisibilityProvider(leadId));
    return actions.where((a) {
      if (a == LeadListItemMenuAction.addDeliveryReceipt) return visibility.showAdd;
      if (a == LeadListItemMenuAction.viewDeliveryReceipt) return visibility.showView;
      return true;
    }).toList();
  }
}

@riverpod
class ReceiptLead extends _$ReceiptLead {
  @override
  Lead? build() => null;
  void update(Lead? lead) => state = lead;
}

@riverpod
class ReceiptSource extends _$ReceiptSource {
  @override
  ReceiptType build() => ReceiptType.all;
  void update(ReceiptType type) => state = type;
}

@riverpod
class SendReceiptRequest extends _$SendReceiptRequest {
  @override
  Receipt? build() => null;
  void update(Receipt? request) => state = request;
}

@riverpod
class ReceiptFormErrors extends _$ReceiptFormErrors {
  @override
  List<FormFieldError> build() => [];
  void addError(FormFieldError error) => state = [...state, error];
  void clearErrors() => state = [];
}

@riverpod
class CanEditReceipt extends _$CanEditReceipt {
  @override
  bool build() => false;
  void set(bool value) => state = value;
}

@riverpod
class Receipts extends _$Receipts {
  @override
  List<Receipt> build() => [];
  void update(List<Receipt> list) => state = list;
}

@riverpod
class LoadingReceiptsState extends _$LoadingReceiptsState {
  @override
  bool build() => false;
  void set(bool value) => state = value;
}

typedef DeliveryLeadPendingData = ({
  List<ReceiptReason> reasons,
  bool hasReceipts,
});

@riverpod
Future<DeliveryLeadPendingData> deliveryLeadPendingReasons(
  DeliveryLeadPendingReasonsRef ref,
  int leadId,
) async {
  final repo = ref.read(receiptsRepositoryProvider);

  final reasonsFuture = repo.fetchReceiptReasons(leadId);
  final receiptsFuture = repo.fetchReceipts(leadId);
  final reasonsResult = await reasonsFuture;
  final receiptsResult = await receiptsFuture;

  final reasons = reasonsResult.when(
    success: (apiRes) => apiRes?.data ?? <ReceiptReason>[],
    failure: (_) => <ReceiptReason>[],
  );

  final receipts = receiptsResult.when(
    success: (apiRes) => apiRes?.data ?? <Receipt>[],
    failure: (_) => <Receipt>[],
  );

  final hasReceipts = receipts.any(
    (r) => r.type == ReceiptType.postDelivery.value,
  );

  int oldCarCollected = 0;
  int creditCollected = 0;
  for (final receipt in receipts) {
    if (receipt.type != ReceiptType.postDelivery.value) continue;
    final amount = receipt.amount ?? 0;
    if (receipt.paymentType ==
        ReceiptPaymentType.oldCarPaymentReceived.value) {
      oldCarCollected += amount;
    } else if (receipt.paymentType ==
        ReceiptPaymentType.customerCreditReceived.value) {
      creditCollected += amount;
    }
  }

  final updatedReasons = reasons.map((reason) {
    if (reason.reason ==
        ReceiptReasonType.oldCarPaymentPendingFromAgent.value) {
      final original = reason.pendingAmount ?? 0;
      final remaining = (original - oldCarCollected).clamp(0, original);
      return reason.copyWith(pendingAmount: remaining);
    } else if (reason.reason ==
        ReceiptReasonType.creditGivenToCustomer.value) {
      final original = reason.pendingAmount ?? 0;
      final remaining = (original - creditCollected).clamp(0, original);
      return reason.copyWith(pendingAmount: remaining);
    }
    return reason;
  }).toList();

  return (reasons: updatedReasons, hasReceipts: hasReceipts);
}

@riverpod
Future<List<ReceiptReason>> deliveryLeadPendingDisplayReasons(
  DeliveryLeadPendingDisplayReasonsRef ref,
  int leadId,
) async {
  final data = await ref.watch(deliveryLeadPendingReasonsProvider(leadId).future);
  return data.reasons.where((reason) {
    if ((reason.pendingAmount ?? 0) <= 0) return false;
    return reason.reason ==
            ReceiptReasonType.oldCarPaymentPendingFromAgent.value ||
        reason.reason == ReceiptReasonType.creditGivenToCustomer.value;
  }).toList();
}

@riverpod
Future<List<String>> deliveryLeadPaymentTypeOptions(
  DeliveryLeadPaymentTypeOptionsRef ref,
  int leadId,
) async {
  final data = await ref.watch(deliveryLeadPendingReasonsProvider(leadId).future);
  final options = <String>[];
  for (final reason in data.reasons) {
    if ((reason.pendingAmount ?? 0) > 0) {
      if (reason.reason ==
          ReceiptReasonType.oldCarPaymentPendingFromAgent.value) {
        options.add(ReceiptPaymentType.oldCarPaymentReceived.value);
      } else if (reason.reason ==
          ReceiptReasonType.creditGivenToCustomer.value) {
        options.add(ReceiptPaymentType.customerCreditReceived.value);
      }
    }
  }
  return options;
}

@riverpod
bool? deliveryLeadHasPendingAmount(
  DeliveryLeadHasPendingAmountRef ref,
  int leadId,
) {
  final data = ref.watch(deliveryLeadPendingReasonsProvider(leadId)).valueOrNull;
  if (data == null) return null;
  return data.reasons.any((r) => (r.pendingAmount ?? 0) > 0);
}

typedef DeliveryReceiptMenuVisibility = ({bool showAdd, bool showView});

@riverpod
DeliveryReceiptMenuVisibility deliveryReceiptMenuVisibility(
  DeliveryReceiptMenuVisibilityRef ref,
  int leadId,
) {
  final hasPending = ref.watch(deliveryLeadHasPendingAmountProvider(leadId));
  final hasReceipts =
      ref.watch(deliveryLeadPendingReasonsProvider(leadId)).valueOrNull?.hasReceipts;
  return (
    showAdd: hasPending != false,
    showView: hasReceipts != false,
  );
}

@riverpod
int receiptAmountCap(ReceiptAmountCapRef ref) {
  final request = ref.watch(sendReceiptRequestProvider);
  final leadId = ref.watch(receiptLeadProvider.select((l) => l?.id));

  if (leadId == null ||
      request?.type != ReceiptType.postDelivery.value ||
      request?.paymentType == null) {
    return 0;
  }

  final reasons =
      ref.watch(deliveryLeadPendingReasonsProvider(leadId)).valueOrNull?.reasons ??
      <ReceiptReason>[];

  ReceiptReason? matched;
  if (request?.paymentType == ReceiptPaymentType.oldCarPaymentReceived.value) {
    matched = reasons
        .where((r) => r.reason == ReceiptReasonType.oldCarPaymentPendingFromAgent.value)
        .firstOrNull;
  } else if (request?.paymentType ==
      ReceiptPaymentType.customerCreditReceived.value) {
    matched = reasons
        .where((r) => r.reason == ReceiptReasonType.creditGivenToCustomer.value)
        .firstOrNull;
  }

  return matched?.pendingAmount ?? 0;
}
