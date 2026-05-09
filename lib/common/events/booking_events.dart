import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:loggy/loggy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/validation_utils.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin BookingEvents on UiComponentWidget {
  Future createBooking({Booking? request}) async {
    showLoader();
    final result = await eventRef
        .read(bookingViewModelProvider.notifier)
        .createBooking(request: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          onBookingCreated(data?.data);
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future updateBooking({
    int? bookingId,
    Booking? request,
    String method = "PATCH",
  }) async {
    if (bookingId == null) {
      showSnackBar("Update Booking: booking id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(bookingViewModelProvider.notifier)
        .updateBooking(bookingId, request: request, method: method);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          onBookingUpdated(data?.data);
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future uploadBookingDocuments({
    int? bookingId,
    Booking? request,
    String method = "PATCH",
  }) async {
    if (bookingId == null) {
      showSnackBar("Update Booking Documents: booking id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(bookingViewModelProvider.notifier)
        .uploadBookingDocuments(bookingId, request: request, method: method);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          Loggy("uploadBookingDocuments").debug("Uploaded Successfully");
          onBookingDocumentsUploaded(data?.data);
        }
      },
      failure: (error) {
        hideLoader();
        showSnackBar(error.message ?? LocaleKeys.defaultErrorMessage.tr());
      },
    );
  }

  Future sendCPAApproval({
    int? leadId,
    ChangeLeadStatusRequest? request,
    String method = "PATCH",
  }) async {
    if (leadId == null) {
      showSnackBar("Send CPA Approval: lead id can't be null!");
      return;
    }

    showLoader();
    final result = await eventRef
        .read(bookingViewModelProvider.notifier)
        .sendCPAApproval(leadId, request: request);
    if (!isMounted) return;

    result.when(
      success: (data) {
        hideLoader();
        if (data?.error != null) {
          showSnackBar(json.encode(data?.error));
        } else {
          onCPAApprovalSend(data?.data);
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

  Future<void> uploadBookingImages({
    required Booking? booking,
    required Booking? selectedBooking,
  }) async {
    final poPhoto = selectedBooking?.poPhoto;
    final doPhoto = selectedBooking?.doPhoto;

    final hasLocalPoPhoto = poPhoto != null && isLocalFile(poPhoto);
    final hasLocalDoPhoto = doPhoto != null && isLocalFile(doPhoto);

    if (!hasLocalPoPhoto && !hasLocalDoPhoto) return;

    final localDocuments = (selectedBooking?.documents ?? [])
        .where(
          (doc) =>
              doc.fileName != null &&
              !doc.fileName!.startsWith("http") &&
              !doc.fileName!.startsWith("https"),
        )
        .toList();

    await uploadBookingDocuments(
      bookingId: selectedBooking?.id ?? booking?.id,
      request: selectedBooking?.copyWith(
        poPhoto: hasLocalPoPhoto ? poPhoto : null,
        doPhoto: hasLocalDoPhoto ? doPhoto : null,
        documents: localDocuments,
      ),
    );
  }

  void onBookingUpdated(Booking? booking) {}

  void onBookingDocumentsUploaded(Booking? booking) {}

  void onBookingCreated(Booking? booking) {}

  void onCPAApprovalSend(List<String>? data) {}

  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {}

  WidgetRef get eventRef;
}
