import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/followup_data_given.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/interested_in_comp.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/common/providers/form_fields_error_notifier.dart';
import 'package:salesdocket_mobile/features/followup/providers/cc_lead_followups_provider.dart';

import '../../../common/entity/personal_details_images.dart';

part 'followup_view_model.g.dart';

@riverpod
class FollowupViewModel extends _$FollowupViewModel {
  @override
  FutureOr<void> build() async {
    // You can perform any async initialization here if required.
  }
}

// Enums
enum FollowupStatus { initial, done, notDone, called, alreadySpoken }

enum LeadType { ccLead, groupedLead }

// Tracks if call is in progress
final callInProgressProvider = StateProvider<bool>((ref) => false);
// This provider stores the call duration in seconds
final callDurationProvider = StateProvider<int?>((ref) => null);
final followupImagesProvider = StateProvider<FollowupImages?>((ref) => null);
// This provider stores the call status (spoken, busy, etc.)
final callStatusProvider = StateProvider<String?>((ref) => null);
// Followup main data providers
final followupRequestProvider = StateProvider<FollowupDataGiven?>(
  (ref) => null,
);
final closeFollowupRequestProvider = StateProvider<Lead?>((ref) => null);
final followupLeadRequestProvider = StateProvider<Lead?>((ref) => null);
final automaticCallCountProvider = StateProvider<int>((ref) => 0);
// Lead type determination
final leadTypeProvider = StateProvider.family<LeadType, int?>((ref, isCCLead) {
  return isCCLead == 1 ? LeadType.ccLead : LeadType.groupedLead;
});

// History, status & follow-up interaction tracking
final followupLeadHistoryProvider = StateProvider<List<LeadHistory>>(
  (ref) => [],
);
final followupCallStatusProvider = StateProvider<bool>((ref) => false);
final followupAlreadySpokenStatusProvider = StateProvider<bool>((ref) => false);
final followupDoneStatusProvider = StateProvider<bool>((ref) => false);
final followupIsDoneStatusProvider = StateProvider<bool>((ref) => false);
final followupNotDoneStatusProvider = StateProvider<bool>((ref) => false);

// Test drive & showroom visit
final followupTestDriveGivenProvider = StateProvider<TestDriveGiven?>(
  (ref) => null,
);
final isShowroomVisitProvider = StateProvider<int?>((ref) => null);

// Call duration

// Product & brand-related
final followupProductsProvider = StateProvider<List<CompetitionProduct>>(
  (ref) => [],
);
final selectBrandAndModelProvider = StateProvider<InterestedInComp?>(
  (ref) => null,
);

// Form error handling
final createFollowUpFormErrorsProvider =
    StateNotifierProvider<FormFieldsErrorNotifier, List<FormFieldError>>(
      (ref) => FormFieldsErrorNotifier(),
    );

// Follow-up current status tracker
final followupStatusProvider = StateProvider<FollowupStatus>(
  (ref) => FollowupStatus.initial,
);
