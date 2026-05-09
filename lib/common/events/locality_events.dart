import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/locality/view_model/locality_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin LocalityEvents on UiComponentWidget {
  Future setLeadAddress({int? localityId, LeadAddress? address}) async {
    if (localityId == null) {
      showSnackBar("Set Lead Address: locality id can't be null!");
      return;
    }

    showLoader();
    final addressReq =
        (address?.line1?.trim().isEmpty ?? true)
            ? address?.copyWith(line1: "-")
            : address;

    final result = await eventRef
        .read(localityViewModelProvider.notifier)
        .createAddress(localityId, addressReq);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.errors != null) {
          showSnackBar(json.encode(data?.errors));
        } else {
          onAddressCreated(data);
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future searchCities({String? text}) async {
    final result = await eventRef
        .read(localityViewModelProvider.notifier)
        .fetchLocalityCities(LocationSearchRequest(search: text));
    if (!isMounted) return;

    result.when(
      success: (data) {
        onCitiesFetched(data ?? []);
      },
      failure: (err) {
        showSnackBar(
          err.message ?? LocaleKeys.defaultErrorMessage,
          type: SnackBarType.error,
        );
      },
    );
  }

  Future searchLocations(int cityId, LocationSearchRequest req) async {
    final result = await eventRef
        .read(localityViewModelProvider.notifier)
        .fetchLocalityLocations(cityId, req);
    if (!isMounted) return;

    result.when(
      success: (data) {
        onLocationsFetched(data?.data ?? []);
      },
      failure: (err) {
        showSnackBar(
          err.message ?? LocaleKeys.defaultErrorMessage,
          type: SnackBarType.error,
        );
      },
    );
  }

  void showLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(true);
  }

  void hideLoader() {
    eventRef.read(loadingStateProvider.notifier).setLoading(false);
  }

  void onLocationsFetched(List<Location> list) {}

  void onCitiesFetched(List<City> cities) {}

  void onAddressCreated(CreateAddressResponse? data) {}

  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {}

  WidgetRef get eventRef;
}
