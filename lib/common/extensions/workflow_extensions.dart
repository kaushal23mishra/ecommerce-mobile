import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/follow_up_plan_type.dart';
import 'package:salesdocket_mobile/common/constants/workflow_state.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';

extension WorkflowExtensions on Workflow? {
  bool get isBooking {
    return this?.state?.toUpperCase() == WorkflowState.booking.value;
  }

  bool get isBooked {
    return this?.state?.toUpperCase() == WorkflowState.booked.value;
  }

  bool get isCompetitor {
    return this?.lostTo?.toUpperCase() == WorkflowState.competitor.value;
  }

  bool get isBPR {
    return this?.state?.toUpperCase() == WorkflowState.bpr.value;
  }

  bool get isCancelled {
    return this?.state?.toUpperCase() == WorkflowState.cancelled.value;
  }

  bool get isClosed {
    return this?.state?.toUpperCase() == WorkflowState.closed.value;
  }

  bool get isCPA {
    return this?.state?.toUpperCase() == WorkflowState.cpa.value;
  }

  bool get isDelivered {
    return this?.state?.toUpperCase() == WorkflowState.delivered.value;
  }

  bool get isDPR {
    return this?.state?.toUpperCase() == WorkflowState.dpr.value;
  }

  bool get isEPR {
    return this?.state?.toUpperCase() == WorkflowState.epr.value;
  }

  bool get isInactive {
    return this?.state?.toUpperCase() == WorkflowState.inactive.value;
  }

  bool get isLost {
    return this?.state?.toUpperCase() == WorkflowState.lost.value;
  }

  bool get isLPA {
    return this?.state?.toUpperCase() == WorkflowState.lpa.value;
  }

  bool get isRegistered {
    return this?.state?.toUpperCase() == WorkflowState.registered.value;
  }

  bool get isInactiveBooking {
    return this?.state?.toUpperCase() == WorkflowState.inactiveBooking.value;
  }

  bool get isDeliveryGroup {
    return isDelivered || isDPR || this?.state?.toUpperCase() == 'DELIVERY';
  }

  bool get isBookingGroup {
    return isBooking ||
        isBooked ||
        isBPR ||
        isCPA ||
        isCancelled ||
        isInactiveBooking;
  }

  bool get isNone {
    return this?.state?.toUpperCase() == WorkflowState.none.value;
  }

  LeadAction? get followupAction {
    return this?.actions?.firstWhereOrNull(
      (toFilter) => toFilter.status != null && toFilter.status == 1,
    );
  }

  String? get followupType {
    final action = followupAction?.action;
    if (action == null) return null;

    final lowerAction = action.toLowerCase();

    if (lowerAction == FollowUpPlanType.dealerVisit.value.toLowerCase()) {
      return "Showroom visit on";
    }

    if (lowerAction == "lpa_call") {
      return "LPA Call on";
    }

    if (lowerAction == FollowUpPlanType.bookingCall.value.toLowerCase()) {
      return "Booking Call on";
    }

    if (lowerAction == FollowUpPlanType.call.value.toLowerCase()) {
      return "Call on";
    }

    return "$action on";
  }

  String? get followupDate {
    final date = followupAction?.dueDate;
    if (date == null) return null;

    return date.formatDateTime();
  }
}
