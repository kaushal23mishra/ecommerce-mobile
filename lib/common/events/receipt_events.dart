import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin ReceiptEvents on UiComponentWidget {
  Future addReceipt({Receipt? request}) async {
    showLoader();
    final result = await eventRef
        .read(receiptViewModelProvider.notifier)
        .addReceipt(request: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          onReceiptAdded();
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future updateReceipt({int? receiptId, Receipt? request}) async {
    if (receiptId == null) {
      showSnackBar("Update Receipt: receipt id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(receiptViewModelProvider.notifier)
        .updateReceipt(receiptId, request: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          onReceiptUpdated();
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future fetchReceipts({int? leadId, Receipt? request}) async {
    if (leadId == null) {
      showSnackBar("Fetch Receipt: lead id can't be null!");
      return;
    }

    final result = await eventRef
        .read(receiptViewModelProvider.notifier)
        .fetchReceipts(leadId: leadId);
    if (!isMounted) return;

    result.when(
      success: (data) {
        onReceiptsFetched(data?.data ?? []);
      },
      failure: (error) {
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future fetchReceiptReasons({int? leadId, Receipt? request}) async {
    if (leadId == null) {
      showSnackBar("Fetch Receipt Reasons: lead id can't be null!");
      return;
    }

    final result = await eventRef
        .read(receiptViewModelProvider.notifier)
        .fetchReceiptReasons(leadId: leadId);
    if (!isMounted) return;

    result.when(
      success: (data) {
        onReceiptReasonsFetched(data?.data ?? []);
      },
      failure: (error) {
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future sendReceiptReason({ReceiptReason? request}) async {
    showLoader();
    final result = await eventRef
        .read(receiptViewModelProvider.notifier)
        .sendReceiptReason(request: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          onReceiptReasonSend();
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future updateReceiptReason({
    int? receiptReasonId,
    ReceiptReason? request,
  }) async {
    if (receiptReasonId == null) {
      showSnackBar("Update Receipt Reason: receipt reason id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(receiptViewModelProvider.notifier)
        .updateReceiptReason(receiptReasonId, request: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          onReceiptReasonUpdated();
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  void showLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(true);
  }

  void hideLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(false);
  }

  void onReceiptAdded() {}

  void onReceiptUpdated() {}

  void onReceiptsFetched(List<Receipt> receipts) {}

  void onReceiptReasonsFetched(List<ReceiptReason> receiptReasons) {}

  void onReceiptReasonSend() {}

  void onReceiptReasonUpdated() {}

  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {}

  WidgetRef get eventRef;
}
