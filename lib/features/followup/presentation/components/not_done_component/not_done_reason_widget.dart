import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:auto_route/auto_route.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import '../../../../../common/constants/form_fields.dart';
import '../../../../../common/entity/followup_data_given.dart';
import '../../../../../routing/app_router.dart';
import '../../../../../utility/request_utils.dart';
import '../../../view_model/followup_view_model.dart';
import '../call_status_mode.dart';

class NotDoneReasonWidget extends SalesdocketConsumerStatefulWidget {
  const NotDoneReasonWidget({super.key});

  @override
  SalesdocketConsumerState<NotDoneReasonWidget> createState() =>
      _NotDoneReasonWidgetState();
}

class _NotDoneReasonWidgetState
    extends SalesdocketConsumerState<NotDoneReasonWidget>
    with LeadEvents {
  String? _selectedReason;
  final TextEditingController _otherReasonController = TextEditingController();

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  void _validateAndSubmitRequest() {
    final followupRequest = ref.read(followupRequestProvider);
    if (followupRequest == null) {
      showSnackBar("Error: Follow-up request data is missing or incomplete.");
      return;
    }
    _createFollowupLostHistory(followupRequest);
  }

  Future<void> _createFollowupLostHistory(
    FollowupDataGiven followupRequest,
  ) async {
    final lead = ref.read(followupLeadRequestProvider);
    if (lead == null) {
      showSnackBar("Error: Missing lead Id.");
      return;
    }
    await createLeadHistory(
      leadId: lead.id,
      req: FollowupRequestUtils.createLeadHistoryRequest(
        followupData: followupRequest,
        lead: lead,
        status: '2',
      ),
    );
  }

  @override
  Future<void> onLeadHistoryCreated() async {
    final lead = ref.read(followupLeadRequestProvider);
    final followupRequest =
        ref.read(followupRequestProvider)?.createLeadFollowupRequest();

    if (lead == null || followupRequest == null) {
      showSnackBar(LocaleKeys.lblError_lead_or_followup_missing.tr());
      return;
    }

    try {
      await createFollowup(leadId: lead.id, request: followupRequest);

      if (!context.mounted) return;

      ref.read(followupStatusProvider.notifier).state = FollowupStatus.initial;
      ref.read(callStatusProvider.notifier).state = null;
      ref.read(callDurationProvider.notifier).state = null;
      ref.read(callInProgressProvider.notifier).state = false;
      ref.read(followupRequestProvider.notifier).state = null;
      context.router.maybePopTop();
      context.router.push(const FollowupRoute());
    } catch (error, stackTrace) {
      debugPrint("Error creating lead history: $error\n$stackTrace");
      showSnackBar(LocaleKeys.lblError_create_lead_history_failed.tr());
    }
  }

  void _updateClosedReason(String reason) {
    final lead = ref.read(followupLeadRequestProvider);
    final formattedDateTime = DateTime.now().formatDateTime();

    ref.read(followupRequestProvider.notifier).update(
      (followup) => followup?.copyWith(
        closedReason: reason,
        toWhom: lead?.fullName ?? '',
        when: formattedDateTime,
        nextFollowup: 'Call',
      ),
    );

    ref
        .read(createFollowUpFormErrorsProvider.notifier)
        .remove(CreateFollowUpFormFields.newLeadStatus);
  }

  void _showConfirmationDialog() {
    showSalesdocketBottomSheet(
      context: context,
      builder: (context) {
        return SalesdocketAlertBottomSheet(
          title: "Confirm Action",
          description: LocaleKeys.lblWarning_not_done_confirmation.tr(),
          buttonText: LocaleKeys.lblYes.tr(),
          buttonColor: appColors.primary,
          negativeButtonText: LocaleKeys.lblCancel.tr(),
          onNegativeActionClicked: () {
            setState(() {
              _selectedReason = null;
              _otherReasonController.clear();
            });
            ref.read(followupStatusProvider.notifier).state =
                FollowupStatus.initial;
            ref.read(followupRequestProvider.notifier).state = null;
            ref.read(createFollowUpFormErrorsProvider.notifier).removeAll();
          },
          onActionClicked: () {
            ref.read(followupStatusProvider.notifier).state =
                FollowupStatus.notDone;
            _validateAndSubmitRequest();
          },
        );
      },
    );
  }

  void _handleNotDoneReasonSelection(String? selectedReason) {
    if (selectedReason == null) return;

    setState(() {
      _selectedReason = selectedReason;
      if (selectedReason != NotDoneReasonType.other.value) {
        _otherReasonController.clear();
      }
    });

    if (selectedReason != NotDoneReasonType.other.value) {
      _updateClosedReason(selectedReason);
      _showConfirmationDialog();
    }
  }

  void _submitOtherReason() {
    final text = _otherReasonController.text.trim();
    if (text.isEmpty) {
      showSnackBar("Please enter a reason.");
      return;
    }
    _updateClosedReason(text);
    _showConfirmationDialog();
  }

  @override
  Widget build(BuildContext context) {
    final newLeadStatus = ref.watch(
      followupRequestProvider.select(
        (followup) => followup?.newLeadStatus ?? '',
      ),
    );
    final error = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.newLeadStatus);

    final isOtherSelected = _selectedReason == NotDoneReasonType.other.value;

    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.lblReasonForNotDone.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          SalesDocketChipWidget(
            chips: NotDoneReasonType.notDoneReasonList,
            selectedChips: newLeadStatus.isNotEmpty ? [newLeadStatus] : [],
            errorText: error?.message,
            onSelected:
                (selected) =>
                    _handleNotDoneReasonSelection(selected?.firstOrNull),
          ),
          if (isOtherSelected) ...[
            SizedBox(height: 1.h),
            SalesDocketInputWidget(
              controller: _otherReasonController,
              hint: 'Enter other reason',
              maxLines: 3,
            ),
            SizedBox(height: 1.h),
            SalesDocketButtonWidget(
              text: LocaleKeys.lblSave.tr(),
              onPressed: _submitOtherReason,
            ),
          ],
        ],
      ),
    );
  }

  @override
  WidgetRef get eventRef => ref;
}
