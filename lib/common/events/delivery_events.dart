import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin DeliveryEvents on UiComponentWidget {
  Future createDelivery({Delivery? request}) async {
    showLoader();
    final result = await eventRef
        .read(deliveryViewModelProvider.notifier)
        .createDelivery(request: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          onDeliveryCreated(data?.data);
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future updateDelivery({
    int? deliveryId,
    Delivery? request,
    String method = "PATCH",
  }) async {
    if (deliveryId == null) {
      showSnackBar("Update Delivery: delivery id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(deliveryViewModelProvider.notifier)
        .updateDelivery(deliveryId, request: request, method: method);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          Loggy("").debug(data?.data);
          onDeliveryUpdated(data?.data);
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future uploadDeliveryDocuments({
    int? deliveryId,
    Delivery? request,
    String method = "PATCH",
  }) async {
    showLoader();
    final result = await eventRef
        .read(deliveryViewModelProvider.notifier)
        .uploadDeliveryDocuments(
          deliveryId: deliveryId,
          request: request,
          method: method,
        );
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          Loggy("uploadDeliveryDocuments").debug("Uploaded Successfully");
          onDeliveryDocumentsUploaded(data?.data);
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

  void onDeliveryUpdated(Delivery? delivery) {}

  void onDeliveryDocumentsUploaded(Delivery? delivery) {}

  void onDeliveryCreated(Delivery? delivery) {}

  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {}

  WidgetRef get eventRef;
}
