import 'package:freezed_annotation/freezed_annotation.dart';

part 'followup_data_given.freezed.dart';

@freezed
class FollowupDataGiven with _$FollowupDataGiven {
  const factory FollowupDataGiven({
    ///variable for api call
    String? nextFollowup,
    String? expectedMonthOfConversion,
    String? closedReason,
    String? status,
    String? leadStatus,
    String? remarks,
    String? responseType,
    String? lostToCoDealerName,
    String? workflowId,
    String? leadId,
    String? toWhom,
    String? when,
    List? lostToCompetitionReason,

    ///dummy variable
    String? callStatus,
    String? nextAction,
    String? engineType,
    String? newLeadStatus,
    String? incorrectNumber,
    String? leadCategory,
    String? lostTo,
    String? reason,
    String? ccLeadStatus,
    int? productId,
    int? followupId,
    String? responseCarUsed,
  }) = _FollowupDataGiven;
}
