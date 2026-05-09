import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/followup/providers/cc_lead_followups_provider.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import '../../../../common/classes/salesdocket_consumer_state.dart';
import '../../../../common/constants/widget.dart';
import '../../../../common/entity/followup_data_given.dart';
import 'call_status_mode.dart';
import 'followup_date_time_widget.dart';

/// CC Lead specific Next Action Widget
/// Uses CC lead followups API for validation
class CCLeadNextActionWidget extends SalesdocketConsumerStatefulWidget {
  const CCLeadNextActionWidget({
    super.key,
    required this.phoneNumber,
    required this.makePhoneCall,
  });

  final String phoneNumber;
  final Function(String) makePhoneCall;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CCLeadNextActionWidgetState();
}

class _CCLeadNextActionWidgetState
    extends SalesdocketConsumerState<CCLeadNextActionWidget>
    with LeadEvents, NavigationEvents {
  @override
  Widget build(BuildContext context) {
    final nextActionRequest = ref.watch(
      followupRequestProvider.select((followup) => followup?.nextAction ?? ''),
    );
    final error = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.nextAction);
    final lead = ref.watch(followupLeadRequestProvider);

    // Get CC lead followups from the campaign API
    final ccLeadFollowupsAsync = ref.watch(
      cCLeadFollowupsProvider(lead?.id ?? 0),
    );

    // Check if last 3 follow-ups were busy/outOfNetwork/switchedOff
    final hasThreeFailedCalls = ccLeadFollowupsAsync.when(
      data: (followups) => _checkFailedCalls(followups),
      loading: () => false,
      error: (_, __) => false,
    );

    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.lblNewAction.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          verticalSpacing(1.h),
          SalesDocketChipWidget(
            chips: ccActionList,
            selectedChips:
                nextActionRequest.isNotEmpty ? [nextActionRequest] : [],
            errorText: error?.message,
            onSelected: (selected) {
              final newSelectedSource = selected?.firstOrNull ?? '';
              final callStatus = ref.read(callStatusProvider);

              // Get response message based on call status and count
              final response = _getResponseMessage(
                callStatus ?? '',
                hasThreeFailedCalls,
              );
              String? nextFollowup;
              if (newSelectedSource == LocaleKeys.lblCallLetter.tr()) {
                nextFollowup = 'Call';
              } else if (newSelectedSource ==
                  LocaleKeys.lblPlanHomeVisit.tr()) {
                nextFollowup = 'Home Visit';
              }

              // Update followup request
              ref
                  .read(followupRequestProvider.notifier)
                  .update(
                    (followup) => followup?.copyWith(
                      nextAction: newSelectedSource,
                      closedReason: response,
                      nextFollowup: nextFollowup,
                    ),
                  );

              ref
                  .read(createFollowUpFormErrorsProvider.notifier)
                  .remove(CreateFollowUpFormFields.nextAction);

              if (newSelectedSource == LocaleKeys.lblBtnRedial.tr() &&
                  widget.phoneNumber.isNotEmpty) {
                widget.makePhoneCall(widget.phoneNumber);
              }
            },
          ),
          if (nextActionRequest == LocaleKeys.lblCallLetter.tr() ||
              nextActionRequest == LocaleKeys.lblPlanHomeVisit.tr())
            Column(
              children: [
                FollowupDateTimeWidget(
                  hasThreeFailedCalls:
                      (nextActionRequest == LocaleKeys.lblCallLetter.tr() ||
                          nextActionRequest ==
                              LocaleKeys.lblPlanHomeVisit.tr()) &&
                      hasThreeFailedCalls == true,
                ),
                SalesdocketActionWidget(
                  positiveText: LocaleKeys.btnSave.tr(),
                  onPositiveClicked: () {
                    _validateAndSubmitRequest();
                  },
                  negativeText: LocaleKeys.lblCancel.tr(),
                  onNegativeClicked: () {
                    _backToPrevScreen();
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// Check if the last 3 CC lead followups were failed calls
  /// Checks followup_response_remarks field for Busy, Switched Off, or Out of Network
  /// Matches the same logic as regular lead history validation
  bool _checkFailedCalls(List<CCLeadFollowup> followups) {
    if (followups.length < 3) return false;

    final lastThreeCalls = followups.skip(1).take(4).toList();

    return lastThreeCalls.every((followup) {
      final remarks = followup.followupResponseRemarks ?? '';
      // Check if remarks contain the failed call states
      // Same logic as regular leads: Busy, Switched Off, Out of Network
      return remarks.contains(CallState.busy.value) ||
          remarks.contains(CallState.outOfNetwork.value) ||
          remarks.contains(CallState.switchedOff.value);
    });
  }

  void _validateAndSubmitRequest() {
    final followupRequest = ref.read(followupRequestProvider);

    if (_isValidForm(followupRequest)) {
      _createLeadHistory();
    }
  }

  bool _isValidForm(FollowupDataGiven? request) {
    if (request == null) return false;

    final errors = request.followupCallLetterValidationErrors();

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(createFollowUpFormErrorsProvider.notifier).addAll(errors);
      return false;
    }
    return true;
  }

  Future<void> _createLeadHistory() async {
    // Get references to providers before async operations
    final lead = ref.read(followupLeadRequestProvider);
    final followupRequest = ref.read(followupRequestProvider);
    final context = this.context; // Capture context early

    if (lead == null || followupRequest == null) {
      if (context.mounted) {
        showSnackBar("Error: Missing lead or follow-up request.");
      }
      return;
    }

    try {
      await _closeCCLeadFollowup(lead, followupRequest, context);
    } catch (error, stackTrace) {
      if (context.mounted) {
        showSnackBar("Failed to create lead history. Please try again.");
      }
      debugPrint("Error creating lead history: $error\n$stackTrace");
    }
  }

  Future<void> _closeCCLeadFollowup(
    Lead lead,
    FollowupDataGiven followupRequest,
    BuildContext context,
  ) async {
    final followupId = lead.followups?.firstOrNull?.id;

    if (followupId == null) {
      if (context.mounted) {
        showSnackBar("Error: Followup ID not found.");
      }
      return;
    }

    // Get the status value based on the call state
    final statusValue = _getStatusValue(followupRequest.closedReason ?? '');

    // Get the next followup type
    final nextFollowupType = followupRequest.nextFollowup?.toLowerCase() ?? 'call';

    // Get the next followup time from the request, or calculate it (24 hours from now)
    final nextFollowupTime = followupRequest.when ??
        DateTime.now()
            .add(const Duration(hours: 24))
            .formatDateTime();

    final request = CloseFollowupRequest(
      isRejected: "0",
      rejectionReason: "",
      followupResponse: statusValue,
      followupResponseRemarks: followupRequest.closedReason ??
          "",
      planNext: "1",
      nextFollowupTime: nextFollowupTime,
      nextFollowupType: nextFollowupType,
    );

    await closeLeadHistory(followupId: followupId, req: request);
  }

  void _resetFollowupState() {
    // Reset all followup state
    ref.read(followupCallStatusProvider.notifier).state = false;
    ref.read(followupAlreadySpokenStatusProvider.notifier).state = false;
    ref.read(followupDoneStatusProvider.notifier).state = false;
    ref.read(followupNotDoneStatusProvider.notifier).state = false;
    ref.read(callDurationProvider.notifier).state = null;
    ref.read(callStatusProvider.notifier).state = null;
    ref.read(callInProgressProvider.notifier).state = true;
    ref.read(followupStatusProvider.notifier).state = FollowupStatus.initial;
  }

  void _backToPrevScreen({bool isInactive = false}) {
    // Reset all followup state when canceling
    _resetFollowupState();
    ref.read(followupRequestProvider.notifier).state = null;
    ref.read(createFollowUpFormErrorsProvider.notifier).removeAll();

    context.router.popTop(isInactive);
  }

  @override
  void onCloseLeadHistory() {
    final context = this.context;

    // Check mounted status before any UI operations
    if (!context.mounted) return;

    showSnackBar(
      'CC Lead followup closed successfully',
      type: SnackBarType.success,
    );

    // Reset followup state
    _resetFollowupState();

    // Navigate back
    leadActionBackToPrevScreen(context, shouldBackToPrev: true);
  }

  @override
  WidgetRef get eventRef => ref;
}

String _getResponseMessage(String status, bool hasThreeFailedCalls) {
  if (hasThreeFailedCalls) {
    switch (status) {
      case 'Busy':
        return '${LocaleKeys.lblCall.tr()} ${LocaleKeys.lblNotDone.tr()} - ${LocaleKeys.lblBusy.tr()}';
      case 'Switched Off':
        return '${LocaleKeys.lblCall.tr()} ${LocaleKeys.lblNotDone.tr()} - ${LocaleKeys.lblSwitchedOff.tr()}';
      case 'Incorrect Number':
        return '${LocaleKeys.lblCall.tr()} ${LocaleKeys.lblNotDone.tr()} - ${LocaleKeys.lblIncorrectNumber.tr()}';
      case 'Out Of Network':
        return '${LocaleKeys.lblCall.tr()} ${LocaleKeys.lblNotDone.tr()} - ${LocaleKeys.lblOutOfNetwork.tr()}';
    }
  } else {
    switch (status) {
      case 'Busy':
        return '${LocaleKeys.lblBusy.tr()} - ${LocaleKeys.automatic_followup_scheduled.tr()}';
      case 'Switched Off':
        return '${LocaleKeys.lblSwitchedOff.tr()} - ${LocaleKeys.automatic_followup_scheduled.tr()}';
      case 'Incorrect Number':
        return '${LocaleKeys.lblCall.tr()} ${LocaleKeys.lblNotDone.tr()} - ${LocaleKeys.lblIncorrectNumber.tr()}';
      case 'Out Of Network':
        return '${LocaleKeys.lblOutOfNetwork.tr()} - ${LocaleKeys.automatic_followup_scheduled.tr()}';
    }
  }
  return '';
}

String _getStatusValue(String closedReason) {
  if (closedReason.contains(CallState.busy.value)) {
    return '2'; // Busy
  } else if (closedReason.contains(CallState.switchedOff.value)) {
    return '3'; // Switched Off
  } else if (closedReason.contains(CallState.outOfNetwork.value)) {
    return '5'; // Out of Network
  } else if (closedReason.contains(CallState.incorrectNumber.value)) {
    return '4'; // Incorrect Number
  }
  return '1'; // Default status
}
