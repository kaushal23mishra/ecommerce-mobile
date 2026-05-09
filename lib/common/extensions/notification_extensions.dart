import 'dart:convert';

import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/notification_alert_type.dart';

extension NotificationExtensions on SalesdocketNotification {
  dynamic get decodedAction {
    return actionSent != null ? jsonDecode(actionSent!) : null;
  }

  String get vehicleName {
    final variant =
        decodedAction?['workflow']?['lead']?['primaryvariant']?['variant'] ??
        "";
    final productName =
        decodedAction?['workflow']?['lead']?['primaryvariant']?['product']?['name']
            .toString() ??
        '';

    return "$productName $variant".trim();
  }

  Lead? get workflowLead {
    final leadJson = decodedAction?['workflow']?['lead'];
    try {
      return leadJson != null ? Lead.fromJson(leadJson) : null;
    } catch (e) {
      return null;
    }
  }

  Lead? get leadWithId {
    final leadId = decodedAction?['lead_id'];
    try {
      return leadId != null ? Lead(id: leadId) : null;
    } catch (e) {
      return null;
    }
  }

  Lead? get leadWithAssignment {
    final leadJson = decodedAction?['lead'];
    try {
      return leadJson != null ? Lead.fromJson(leadJson) : null;
    } catch (e) {
      return null;
    }
  }

  Lead? get lead {
    final notificationLead = info?.when(
      discount: (_) => null,
      lead: (lead) => lead,
    );
    final notificationDiscount = info?.when(
      discount: (discount) => discount,
      lead: (_) => null,
    );

    switch (fromValue(alertType)) {
      case NotificationAlertType.bookingCancelRequest:
      case NotificationAlertType.bookingCancelResponse:
      case NotificationAlertType.discountApproval:
        return notificationDiscount?.lead;
      case NotificationAlertType.deliveryApprovalResponse:
      case NotificationAlertType.deliveryApprovalNormal:
      case NotificationAlertType.deliveryApprovalDiscountApproval:
        return notificationDiscount?.delivery?.lead?.copyWith(
          delivery: notificationDiscount.delivery,
        );
      case NotificationAlertType.followup:
        return leadInfo?.workflow?.lead?.copyWith(workflow: leadInfo?.workflow);
      case NotificationAlertType.discountApprovalResponse:
      case NotificationAlertType.leadLostApproval:
      case NotificationAlertType.leadLostApprovalResponse:
      case NotificationAlertType.leadTransfer:
        return notificationDiscount?.lead;
      case NotificationAlertType.exchangeEvaluationPending:
      case NotificationAlertType.exchangeEvaluationCompleted:
      case NotificationAlertType.campaignHOLeadAssigned:
      case NotificationAlertType.campaignCCLeadAssigned:
        return notificationLead;
      case NotificationAlertType.leadReassigned:
        return leadWithAssignment;
      default:
        return notificationDiscount?.lead;
    }
  }

  bool get showEvaluationDetails {
    return alertType == NotificationAlertType.exchangeEvaluationCompleted.value;
  }
}
