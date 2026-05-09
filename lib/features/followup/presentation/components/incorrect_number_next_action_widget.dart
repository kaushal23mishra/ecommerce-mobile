import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../common/classes/salesdocket_consumer_state.dart';
import '../../../../common/constants/form_fields.dart';
import '../../../../common/entity/followup_data_given.dart';
import '../../../../common/events/lead_events.dart';
import '../../../../common/extensions/lead_extensions.dart';
import '../../../../common/widgets/salesdocket_action_widget.dart'
    show SalesdocketActionWidget;
import '../../../../generated/assets.gen.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../utility/request_utils.dart';
import '../../view_model/followup_view_model.dart';
import 'call_status_mode.dart';
import 'followup_date_time_widget.dart';
import 'followup_reason_widget.dart';

class IncorrectNumberNextActionWidget
    extends SalesdocketConsumerStatefulWidget {
  const IncorrectNumberNextActionWidget({super.key});

  @override
  SalesdocketConsumerState<IncorrectNumberNextActionWidget> createState() =>
      _IncorrectNumberNextActionWidgetState();
}

class _IncorrectNumberNextActionWidgetState
    extends SalesdocketConsumerState<IncorrectNumberNextActionWidget>
    with LeadEvents, NavigationEvents {
  String? reasonErrorText;

  @override
  Widget build(BuildContext context) {
    final lead = ref.watch(followupLeadRequestProvider);
    final incorrectNumberStatus = ref.watch(
      followupRequestProvider.select(
        (followup) => followup?.incorrectNumber ?? '',
      ),
    );

    final ccLeadStatus = ref.watch(
      followupRequestProvider.select(
        (followup) => followup?.ccLeadStatus ?? '',
      ),
    );

    final closedReason = ref.watch(
      followupRequestProvider.select(
        (followup) => followup?.closedReason,
      ),
    );

    final error = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.incorrectNumber);

    reasonErrorText = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.closedReason)
        ?.message;

    // For CC leads, show only Reject option (Active is only for Spoke to Customer)
    if (lead?.isItCCLead ?? false) {
      return Padding(
        padding: EdgeInsets.only(top: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.lblNewLeadStatus.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            verticalSpacing(1.h),
            SalesDocketChipWidget(
              chips: [LocaleKeys.lblReject.tr()],
              selectedChips: ccLeadStatus.isNotEmpty ? [ccLeadStatus] : [],
              onSelected: (selected) {
                final selectedStatus = selected?.firstOrNull ?? '';
                if (selectedStatus == LocaleKeys.lblReject.tr()) {
                  ref
                      .read(followupRequestProvider.notifier)
                      .update(
                        (followup) => followup?.copyWith(
                          newLeadStatus: LocaleKeys.lblClosed.tr(),
                          leadStatus: selectedStatus,
                          ccLeadStatus: selectedStatus,
                          followupId: lead?.followups?.firstOrNull?.id,
                        ),
                      );
                }
                ref
                    .read(createFollowUpFormErrorsProvider.notifier)
                    .remove(CreateFollowUpFormFields.ccLeadLeadStatus);
              },
            ),
            verticalSpacing(1.h),
            if (ccLeadStatus == LocaleKeys.lblReject.tr()) ...[
              SalesDocketDropDownWidget(
                text: "Reason",
                itemList: followupReasonStateList,
                itemValue: closedReason,
                imagePath: Assets.svg.arrowDown.path,
                hintText: "Please Select a Reason!",
                onChanged: (selected) {
                  ref
                      .read(createFollowUpFormErrorsProvider.notifier)
                      .remove(CreateFollowUpFormFields.closedReason);

                  ref
                      .read(followupRequestProvider.notifier)
                      .update(
                        (current) => current?.copyWith(closedReason: selected),
                      );

                  setState(() => reasonErrorText = null);
                },
                errorText: reasonErrorText,
              ),
              verticalSpacing(2.h),
              SalesdocketActionWidget(
                positiveText: LocaleKeys.btnSave.tr(),
                onPositiveClicked: _validateAndSubmitCCLeadReject,
                negativeText: LocaleKeys.lblCancel.tr(),
                onNegativeClicked: _backToPrevScreen,
              ),
            ],
          ],
        ),
      );
    }

    // For regular leads, show the standard Closed/Plan Home Visit options
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
            chips: incorrectNumberList.map((source) => source.value).toList(),
            selectedChips:
                incorrectNumberStatus.isNotEmpty ? [incorrectNumberStatus] : [],
            errorText: error?.message,
            onSelected: (selected) {
              final newSelectedSource = selected?.firstOrNull ?? '';
              String? nextFollowup;
              String? closedReason;

              if (newSelectedSource == LocaleKeys.lblPlanHomeVisit.tr()) {
                nextFollowup = 'Home Visit';
                closedReason = 'Call Not Done- Incorrect Number';
              } else if (newSelectedSource == LocaleKeys.lblClosed.tr()) {
                // Don't pre-fill closedReason - user must select from dropdown
                closedReason = null;
              }

              ref
                  .read(followupRequestProvider.notifier)
                  .update(
                    (followup) => followup?.copyWith(
                      nextAction: newSelectedSource,
                      closedReason: closedReason,
                      leadStatus:
                          selected != null && selected.contains('Closed')
                              ? 'CLOSED'
                              : followup.leadStatus,
                      nextFollowup: nextFollowup,
                      incorrectNumber: newSelectedSource,
                    ),
                  );

              ref
                  .read(createFollowUpFormErrorsProvider.notifier)
                  .remove(CreateFollowUpFormFields.incorrectNumber);
            },
          ),
          if (incorrectNumberStatus == LocaleKeys.lblPlanHomeVisit.tr())
            Column(
              children: [
                FollowupDateTimeWidget(),
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
          if (incorrectNumberStatus == LocaleKeys.lblClosed.tr())
            const FollowupReasonWidget(),
        ],
      ),
    );
  }

  /// Validate form and create lead history if valid
  void _validateAndSubmitRequest() {
    final followupRequest = ref.read(followupRequestProvider);
    if (_isValidForm(followupRequest)) {
      _createLeadHistory();
    }
  }

  /// Validate and submit CC lead reject request
  void _validateAndSubmitCCLeadReject() {
    final followupRequest = ref.read(followupRequestProvider);
    if (_isValidCCLeadRejectForm(followupRequest)) {
      _closeLeadHistory();
    }
  }

  /// Validate the follow-up request form
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

  /// Validate the CC lead reject form
  bool _isValidCCLeadRejectForm(FollowupDataGiven? request) {
    if (request == null) return false;

    final errors = request.followupClosedValidationErrors();
    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(createFollowUpFormErrorsProvider.notifier).addAll(errors);
      return false;
    }
    return true;
  }

  /// Create lead history and update state upon success
  Future<void> _createLeadHistory() async {
    final lead = ref.read(followupLeadRequestProvider);
    final followupRequest = ref.read(followupRequestProvider);

    if (lead == null || followupRequest == null) {
      showSnackBar("Error: Missing lead or follow-up request.");
      return;
    }

    try {
      await createLeadHistory(
        leadId: lead.id,
        req: FollowupRequestUtils.createLeadHistoryRequest(
          followupData: followupRequest,
          lead: lead,
          status: '4',
        ),
      );

      // Ensure the widget is still mounted before accessing ref
      if (!context.mounted) return;

      // Reset followup state after successful lead history creation
      _resetFollowupState();

      // Navigate back
      leadActionBackToPrevScreen(context);
    } catch (error, stackTrace) {
      if (context.mounted) {
        showSnackBar("Failed to create lead history. Please try again.");
      }
      debugPrint("Error creating lead history: $error\n$stackTrace");
    }
  }

  /// Close lead history for CC leads with reject status
  Future<void> _closeLeadHistory() async {
    final lead = ref.read(followupLeadRequestProvider);
    final followupRequest = ref.read(followupRequestProvider);

    if (lead == null || followupRequest == null) {
      showSnackBar("Error: Missing lead or follow-up request.");
      return;
    }

    final followupsId = lead.followups?.firstOrNull?.id;
    if (followupsId == null) {
      showSnackBar("Error: Missing follow-up ID.");
      return;
    }

    try {
      await closeLeadHistory(
        followupId: followupsId,
        req: followupRequest.closeFollowupRequest(),
      );

      // Ensure the widget is still mounted before accessing ref
      if (!context.mounted) return;

      // Reset followup state after successful lead history closure
      _resetFollowupState();

      // Navigate back
      leadActionBackToPrevScreen(context);
    } catch (error, stackTrace) {
      if (context.mounted) {
        showSnackBar("Failed to close lead history. Please try again.");
      }
      debugPrint("Error closing lead history: $error\n$stackTrace");
    }
  }

  @override
  Future<void> onLeadHistoryCreated() async {
    final lead = ref.read(followupLeadRequestProvider);
    final followupRequest =
        ref.read(followupRequestProvider)?.createLeadFollowupRequest();

    if (lead == null || followupRequest == null) {
      showSnackBar("Error: Missing lead or follow-up request.");
      return;
    }

    try {
      await createFollowup(leadId: lead.id, request: followupRequest);
    } catch (error) {
      showSnackBar("Failed to create lead history. Please try again.");
      debugPrint("Error creating lead history: $error");
    }
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

  void _backToPrevScreen({bool isUpdate = false}) {
    // Reset all followup state when canceling
    if (!isUpdate) {
      _resetFollowupState();
      ref.read(followupRequestProvider.notifier).state = null;
      ref.read(createFollowUpFormErrorsProvider.notifier).removeAll();
    }

    context.router.maybePop(isUpdate);
  }

  @override
  void onLeadStatusChanged(String? leadStatus) {
    showSnackBar('Lead updated successfully', type: SnackBarType.success);
    _backToPrevScreen(isUpdate: true);
  }

  @override
  WidgetRef get eventRef => ref;
}
