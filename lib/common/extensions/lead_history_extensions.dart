import 'dart:convert';

import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/test_drive_given_constants.dart';
import 'package:salesdocket_mobile/common/constants/workflow_state.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';

extension LeadHistoryExtensions on LeadHistory {
  TestDriveGiven? get testDriveGiveDerails {
    // Check if notDoneReason is "Others" and has a custom comment
    final predefinedReasons = testDriveWhyNotGivenStateList;
    final customComment = leadHistoryResponse?.comment;
    final isOthersWithComment =
        notDoneReason == TestDriveWhyNotGivenState.others.value &&
        customComment != null &&
        customComment.isNotEmpty;

    // Handle legacy data: if notDoneReason is not a predefined reason, treat it as custom text
    final isLegacyCustomReason =
        notDoneReason != null &&
        !predefinedReasons.contains(notDoneReason) &&
        notDoneReason!.isNotEmpty;

    // Check status field: 1 = given (Yes), 2 or other = not given (No)
    final isTestDriveGiven = status == 1;

    return TestDriveGiven(
      given: isTestDriveGiven ? 1 : 0, // 1 for Yes, 0 for No
      when: when,
      toWhom: whom,
      whyNotGiven:
          (isOthersWithComment || isLegacyCustomReason)
              ? TestDriveWhyNotGivenState.others.value
              : notDoneReason,
      whyNotGivenReason:
          isOthersWithComment
              ? customComment
              : (isLegacyCustomReason ? notDoneReason : null),
      vehicleUsed: leadHistoryResponse?.carUsed,
    );
  }

  LeadHistoryResponse? get leadHistoryResponse {
    return response == null || response!.isEmpty
        ? null
        : LeadHistoryResponse.fromJson(
          json.decode(response!) as Map<String, dynamic>,
        );
  }
}

extension LeadHistoryListExtension on List<LeadHistory> {
  bool get canRescheduleFollowup {
    return true;
  }
}

extension TestDriveGivenExtension on TestDriveGiven {
  TestDriveGiven defaultTestDriveGivenValues(Lead? lead) {
    final givenToWhom =
        (toWhom ?? "").isEmpty ? lead?.fullNameWOSalutation : toWhom;
    final testDriveVehicleUsed =
        vehicleUsed ?? lead?.primaryVariant?.product?.name;

    return copyWith(
      given: given ?? lead?.isTestDriveGiven,
      toWhom: givenToWhom,
      vehicleUsed: testDriveVehicleUsed,
    );
  }
}
