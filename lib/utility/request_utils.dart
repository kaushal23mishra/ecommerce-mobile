import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';

import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/follow_up_plan_type.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/test_drive_given_constants.dart';
import 'package:salesdocket_mobile/common/entity/followup_data_given.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';

class RequestUtils {
  static CreateLeadHistoryRequest createLeadHistoryRequest({
    TestDriveGiven? newTestDrive,
  }) {
    return newTestDrive?.given == TestDriveGivenState.yes.value
        ? CreateLeadHistoryRequest(
          when: newTestDrive?.when,
          remarks: json.encode(
            LeadHistoryResponse(carUsed: newTestDrive?.vehicleUsed),
          ),
          toWhom: newTestDrive?.toWhom,
          responseType: "test_drive",
          status: "1",
        )
        : CreateLeadHistoryRequest(
          notDoneReason:
              newTestDrive?.whyNotGiven ==
                      TestDriveWhyNotGivenState.others.value
                  ? newTestDrive?.whyNotGivenReason
                  : newTestDrive?.whyNotGiven,
          responseType: "test_drive",
          status: "2",
          remarks: "",
        );
  }
}

class FollowupRequestUtils {
  static CreateLeadHistoryRequest createLeadHistoryRequest({
    required FollowupDataGiven followupData,
    required Lead lead,
    required String status,
    String? responseCarUsed,
    String? when,
    String? toWhom,
    int? workflowId,
    String responseType = 'test_drive',
    List<Document>? documents,
  }) {
    return CreateLeadHistoryRequest(
      remarks: json.encode(
        LeadHistoryResponse(
          carUsed: responseCarUsed,
          comment: followupData.remarks,
        ),
      ),
      when: when ?? '',
      workflowId: workflowId ??
          (toWhom == null ? lead.workflow?.actions?.lastOrNull?.id : null),
      leadId: lead.id,
      notDoneReason: followupData.closedReason ?? '',
      expectedMonthOfConversion: followupData.expectedMonthOfConversion ?? '',
      leadStatus:
          (followupData.leadStatus != null &&
                  followupData.leadStatus!.toLowerCase() == 'active')
              ? followupData.leadCategory
              : followupData.leadStatus ?? '',
      responseType: responseType,
      status: status,
      documents: documents,
    );
  }

  static List<FormFieldError> validateBookingFollowup(
    FollowupDataGiven? followupRequest,
  ) {
    final List<FormFieldError> errors = [];
    if (followupRequest?.remarks == null ||
        followupRequest!.remarks!.trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.remarks,
          message: LocaleKeys.errEnterCustomerRemarks.tr(),
        ),
      );
    }

    final when = followupRequest?.when ?? '';
    if (when.isEmpty) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.when,
          message: LocaleKeys.errFollowUpDateTimeRequired.tr(),
        ),
      );
    }
    return errors;
  }

  static LeadFollowupRequest createBookingFollowupRequest({
    required FollowupDataGiven followupRequest,
    int? actorId,
  }) {
    return LeadFollowupRequest(
      followUpPlan: FollowUpPlanType.bookingCall.value,
      followUpDateTime: followupRequest.when,
      actorId: actorId,
      comments: '',
    );
  }
}
