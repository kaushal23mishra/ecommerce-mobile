import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/followup_data_given.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../common/classes/salesdocket_consumer_state.dart';
import '../../../../common/constants/widget.dart';
import '../../../../utility/request_utils.dart';
import '../../view_model/followup_view_model.dart';
import 'call_status_mode.dart';

class FollowupReasonWidget extends SalesdocketConsumerStatefulWidget {
  const FollowupReasonWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FollowupReasonWidgetState();
}

class _FollowupReasonWidgetState
    extends SalesdocketConsumerState<FollowupReasonWidget>
    with LeadEvents, NavigationEvents {
  final TextEditingController _otherReasonController = TextEditingController();
  bool _isOtherSelected = false;

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  void _validateAndSubmitRequest() {
    dismissKeyboard();
    final followupRequest = ref.read(followupRequestProvider);
    if (!_isValidForm(followupRequest)) return;
    _submitRequestBasedOnLeadType();
  }

  bool _isValidForm(FollowupDataGiven? request) {
    if (request == null) {
      showSnackBar("Error: Missing follow-up request data.");
      return false;
    }

    final errors = request.followupClosedValidationErrors();

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(createFollowUpFormErrorsProvider.notifier).addAll(errors);
      return false;
    }

    ref.read(createFollowUpFormErrorsProvider.notifier).removeAll();
    return true;
  }

  Future<void> _submitRequestBasedOnLeadType() async {
    final lead = ref.read(followupLeadRequestProvider);

    if (lead == null) {
      showSnackBar("Error: Missing lead data.");
      return;
    }

    try {
      if (lead.isItCCLead) {
        await _submitForCCLead(lead);
      } else {
        await _submitForRegularLead(lead);
      }

      if (!mounted) return;

      _resetFollowupState();
      showSnackBar('Follow-up completed successfully', type: SnackBarType.success);

      _backToPrevScreen(isUpdate: true);
    } catch (e, stackTrace) {
      debugPrint("Error in follow-up submission: $e\n$stackTrace");
      if (mounted) {
        showSnackBar("Failed to create lead history. Please try again.");
      }
    }
  }

  Future<void> _submitForCCLead(Lead lead) async {
    final followupsId = lead.followups?.firstOrNull?.id;
    final followupRequest = ref.read(followupRequestProvider)?.closeFollowupRequest();

    if (followupsId == null || followupRequest == null) {
      throw Exception("Missing follow-up data for HO/CC lead.");
    }

    await closeLeadHistory(followupId: followupsId, req: followupRequest);
  }

  Future<void> _submitForRegularLead(Lead lead) async {
    final followupRequest = ref.read(followupRequestProvider);
    final changeStatusRequest = followupRequest?.followupChangeStatusRequest(lead);

    if (followupRequest == null || changeStatusRequest == null) {
      throw Exception("Missing request for regular lead.");
    }

    // Step 1: Change lead status
    await changeLeadStatus(leadId: lead.id, request: changeStatusRequest);

    // Step 2: Create lead history entry
    final historyRequest = FollowupRequestUtils.createLeadHistoryRequest(
      followupData: followupRequest,
      lead: lead,
      status: '4',
      responseType: 'status_change',
      when: DateTime.now().toString(),
    );

    await createLeadHistory(
      leadId: lead.id,
      req: historyRequest,
      hasCallBack: false,
    );
  }

  void _resetFollowupState() {
    ref.read(followupCallStatusProvider.notifier).state = false;
    ref.read(followupAlreadySpokenStatusProvider.notifier).state = false;
    ref.read(followupDoneStatusProvider.notifier).state = false;
    ref.read(followupNotDoneStatusProvider.notifier).state = false;
    ref.read(callDurationProvider.notifier).state = null;
    ref.read(callStatusProvider.notifier).state = null;
    ref.read(callInProgressProvider.notifier).state = false;
    ref.read(followupStatusProvider.notifier).state = FollowupStatus.initial;
    ref.read(followupRequestProvider.notifier).state = null;
  }

  void _backToPrevScreen({bool isUpdate = false}) {
    _resetFollowupState();
    dismissKeyboard();
    context.router.maybePop(isUpdate);
  }

  @override
  Widget build(BuildContext context) {
    final followupReason = ref.watch(followupRequestProvider);
    final errorText = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.closedReason)
        ?.message;
    final otherErrorText = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.otherClosedReason)
        ?.message;


    return Padding(
      padding: EdgeInsets.only(top: 1.0.h),
      child: Column(
        children: [
          SalesDocketDropDownWidget(
            text: "Reason",
            itemList: followupReasonStateList,
            itemValue: _isOtherSelected
                ? FollowupReasonState.other.value
                : followupReason?.closedReason,
            imagePath: Assets.svg.arrowDown.path,
            hintText: "Please select a reason",
            onChanged: (selected) {
              ref
                  .read(createFollowUpFormErrorsProvider.notifier)
                  .remove(CreateFollowUpFormFields.closedReason);

              setState(() {
                _isOtherSelected = selected == FollowupReasonState.other.value;
              });
              if (selected != FollowupReasonState.other.value) {
                _otherReasonController.clear();
              }

              ref
                  .read(followupRequestProvider.notifier)
                  .update((current) => current?.copyWith(closedReason: selected));
            },
            errorText: errorText,
          ),
          if (_isOtherSelected) ...[
            verticalSpacing(2.h),
            SalesDocketInputWidget(
              maxLength: 100,
              inputType: TextInputType.text,
              label: LocaleKeys.pleaseSpecify.tr(),
              controller: _otherReasonController,
              hint: LocaleKeys.enterReason.tr(),
              errorMsg: otherErrorText,
              onChanged: (value) {
                ref
                    .read(createFollowUpFormErrorsProvider.notifier)
                    .remove(CreateFollowUpFormFields.otherClosedReason);
                ref
                    .read(followupRequestProvider.notifier)
                    .update(
                      (current) => current?.copyWith(
                        closedReason: value.trim().isNotEmpty
                            ? value.trim()
                            : FollowupReasonState.other.value,
                      ),
                    );
              },
            ),
          ],
          verticalSpacing(2.h),
          SalesdocketActionWidget(
            positiveText: LocaleKeys.btnSave.tr(),
            onPositiveClicked: _validateAndSubmitRequest,
            negativeText: LocaleKeys.lblCancel.tr(),
            onNegativeClicked: _backToPrevScreen,
          ),
        ],
      ),
    );
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    if (mounted) {
      context.showSnackBar(message, type: type);
    }
  }

  @override
  WidgetRef get eventRef => ref;

  @override
  void onLeadStatusChanged(String? leadStatus) async {
    final lead = ref.read(followupLeadRequestProvider);
    final followupData = ref.read(followupRequestProvider);

    if (!mounted) return;

    _resetFollowupState();
    leadActionBackToPrevScreen(context);

    if (leadStatus?.toUpperCase() == 'CLOSED' ||
        leadStatus?.toUpperCase() == 'LPA') {
      return;
    }

    if (lead == null ||
        followupData?.nextFollowup == null ||
        followupData?.when == null) {
      return;
    }

    final followupRequest = followupData?.createLeadFollowupRequest();

    try {
      await createFollowup(leadId: lead.id, request: followupRequest);
    } catch (error) {
      debugPrint("Error creating follow-up: $error");
    }
  }

}