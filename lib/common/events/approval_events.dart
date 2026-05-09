import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/approvals/view_model/approvals_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin ApprovalEvents on UiComponentWidget {
  Future sendRequestForApproval({
    int? leadId,
    DiscountApproval? request,
  }) async {
    if (leadId == null) {
      showSnackBar("Send Booking For Approval: lead id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(approvalsViewModelProvider.notifier)
        .sendRequestForApproval(leadId, request: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.status == "error") {
          showSnackBar(data?.error ?? LocaleKeys.defaultErrorMessage.tr());
        } else {
          onApprovalRequestSend();
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future sendDeliveryRequestForApproval({
    int? deliveryId,
    DiscountApproval? request,
  }) async {
    if (deliveryId == null) {
      showSnackBar("Send Delivery For Approval: deliveryId id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(approvalsViewModelProvider.notifier)
        .sendDeliveryRequestForApproval(deliveryId, request: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.status == "error") {
          showSnackBar(data?.error ?? LocaleKeys.defaultErrorMessage.tr());
        } else {
          onDeliveryApprovalRequestSend();
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future sendApproval({int? leadId, DiscountApprovalRequest? request}) async {
    if (leadId == null) {
      showSnackBar("Send Approval: lead id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(approvalsViewModelProvider.notifier)
        .sendApproval(leadId, request: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.status == "error" || data?.error != null) {
          showSnackBar(data?.error ?? LocaleKeys.defaultErrorMessage.tr());
        } else {
          onApprovalSend(data?.data);
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future sendDeliveryApproval({
    int? deliveryId,
    DiscountApprovalRequest? request,
  }) async {
    if (deliveryId == null) {
      showSnackBar("Send Approval: deliveryId id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(approvalsViewModelProvider.notifier)
        .sendDeliveryApproval(deliveryId, request: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.status == "error" || data?.error != null) {
          showSnackBar(data?.error ?? LocaleKeys.defaultErrorMessage.tr());
        } else {
          onDeliveryApprovalSend(data?.data);
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  void onApprovalRequestSend() {}

  void onDeliveryApprovalRequestSend() {}

  void onApprovalSend(DiscountApproval? discountApproval) {}

  void onDeliveryApprovalSend(DiscountApproval? discountApproval) {}

  void showLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(true);
  }

  void hideLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(false);
  }

  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {}

  WidgetRef get eventRef;
}
