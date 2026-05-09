import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/notification_alert_type.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_mobile/features/notification/view_model/notification_view_model.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';

void logLong(String msg) {
  const int chunkSize = 3000;
  for (var i = 0; i < msg.length; i += chunkSize) {
    Loggy('LongLog').info(
      msg.substring(i, i + chunkSize > msg.length ? msg.length : i + chunkSize),
    );
  }
}

/// Executes navigation **after first frame** (fixes pop-back behaviour)
void safeNavigate(VoidCallback action) {
  action();
}

final notificationNavigationProvider = Provider((ref) {
  return (Map<String, dynamic> data) {
    final router = appRouter;
    final loggy = Loggy("NotificationNavigation");
    logLong(jsonEncode(data));
    loggy.info("Handling notification navigation with data: $data");

    final notificationId = data['id'] as String?;
    if (notificationId == null || notificationId.isEmpty) {
      loggy.warning("Notification data is missing 'id'. Cannot read.");
      return;
    }

    final alertTypeStr = data['alert_type'] as String?;
    if (alertTypeStr == null || alertTypeStr.isEmpty) {
      loggy.warning(
        "Notification data is missing 'alert_type'. Cannot navigate.",
      );
      return;
    }

    final leadIdStr = data['lead_id'] as String?;
    final leadId = int.tryParse(leadIdStr ?? '');
    if (leadId == null) {
      loggy.error("Booking Cancel notification is missing a valid 'lead_id'.");
      return;
    }

    loggy.info(
      "Handling Booking Cancel Response for lead ID: $leadId, $alertTypeStr",
    );

    ref
        .read(notificationViewModelProvider.notifier)
        .readNotification(
          request: ReadNotificationsRequest(ids: notificationId),
        );
    final alertType = fromValue(alertTypeStr);
    final lead = Lead(id: leadId);

    navigate() {
      switch (alertType) {
        case NotificationAlertType.bookingCancelRequest:
        case NotificationAlertType.bookingCancelResponse:
        case NotificationAlertType.discountApproval:
        case NotificationAlertType.discountApprovalResponse:
          ref.invalidate(bookingLeadRequestProvider);
          ref.invalidate(selectedBookingStepProvider);
          ref.read(selectedBookingStepProvider.notifier).state = 4;
          ref.read(prevBookingLeadRequestProvider.notifier).state = lead;
          router.push(const BookingRoute());
          break;

        case NotificationAlertType.deliveryApprovalNormal:
        case NotificationAlertType.deliveryApprovalResponse:
        case NotificationAlertType.deliveryApprovalDiscountApproval:
          ref.invalidate(deliveryLeadRequestProvider);
          ref.invalidate(selectedDeliveryStepProvider);
          ref.read(selectedDeliveryStepProvider.notifier).state = 5;
          ref.read(prevDeliveryLeadRequestProvider.notifier).state = lead;
          router.push(const DeliveryRoute());
          break;

        case NotificationAlertType.followup:
        case NotificationAlertType.leadLostApproval:
        case NotificationAlertType.leadLostApprovalResponse:
        case NotificationAlertType.campaignCCLeadAssigned:
        case NotificationAlertType.campaignHOLeadAssigned:
          ref.invalidate(followupLeadRequestProvider);
          ref.read(followupLeadRequestProvider.notifier).state = lead;
          router.push(const FollowupRoute());
          break;

        case NotificationAlertType.leadReassigned:
        case NotificationAlertType.leadTransfer:
          ref.invalidate(prospectLeadRequestProvider);
          ref.read(prevProspectLeadRequestProvider.notifier).state = lead;
          router.push(const ProspectRoute());
          break;

        case NotificationAlertType.exchangeEvaluationPending:
        case NotificationAlertType.exchangeEvaluationCompleted:
          ref.invalidate(prospectLeadRequestProvider);
          ref.invalidate(selectedProspectSheetStepProvider);
          ref
              .read(selectedProspectSheetStepProvider.notifier)
              .update((state) => state = 2);
          ref
              .read(prevProspectLeadRequestProvider.notifier)
              .update((state) => state = lead);
          router.push(const ProspectRoute());
        default:
          loggy.debug("No navigation logic for type: $alertType");
          break;
      }
    }

    safeNavigate(navigate);
  };
});
