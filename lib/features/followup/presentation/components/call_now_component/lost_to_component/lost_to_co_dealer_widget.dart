import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/followup_data_given.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/followup/presentation/components/reject_reason_widget.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/interested_in_comp.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/utility/request_utils.dart';

import '../../../../../../common/events/lead_events.dart';
import '../../../../../../common/events/navigation_events.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../../view_model/followup_view_model.dart';

class LostToCoDealerWidget extends SalesdocketConsumerStatefulWidget {
  final InterestedInComp? interestedInComp;
  final Map<LeadFormFields, FormFieldError?> errors;
  final Function(LeadFormFields, dynamic, dynamic)? onChanged;

  const LostToCoDealerWidget({
    super.key,
    this.interestedInComp,
    this.onChanged,
    this.errors = const {},
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoDealerWidgetState();
}

class _CoDealerWidgetState
    extends SalesdocketConsumerState<LostToCoDealerWidget>
    with ProductEvents, LeadEvents, NavigationEvents {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCompetitionProducts();
      if (widget.interestedInComp?.brand != null) {
        getCompetitionModels(brandId: widget.interestedInComp!.brand!);
      }
    });
  }

  void _validateAndSubmitRequest() {
    final followupRequest = ref.read(followupRequestProvider);

    if (_isValidForm(followupRequest)) {
      _createFollowupLostHistory();
    }
  }

  /// Create lead history and update state upon success
  Future<void> _createFollowupLostHistory() async {
    final lead = ref.read(followupLeadRequestProvider);
    final followupRequest = ref.read(followupRequestProvider);

    if (lead == null || followupRequest == null) {
      if (mounted) showSnackBar("Error: Missing lead or follow-up status.");
      return;
    }

    final changeStatusRequest = followupRequest.followupChangeStatusRequest(lead);

    try {
      // Step 1: Change lead status
      await changeLeadStatus(leadId: lead.id, request: changeStatusRequest);

      // Step 2: Create lead history entry
      final historyRequest = FollowupRequestUtils.createLeadHistoryRequest(
        followupData: followupRequest,
        lead: lead,
        status: '1',
        responseType: 'status_change',
        when: DateTime.now().toString(),
      );

      await createLeadHistory(
        leadId: lead.id,
        req: historyRequest,
        hasCallBack: false,
      );

      if (!mounted) return;

      // Reset followup state after successful lead status change
      _resetFollowupState();

      // Navigate back safely
      if (mounted) context.router.maybePop();

    } catch (error, stackTrace) {
      if (mounted) {
        showSnackBar("Failed to create lead history. Please try again.");
      }
      debugPrint("Error creating lead history: $error\n$stackTrace");
    }
  }

  bool _isValidForm(FollowupDataGiven? request) {
    if (request == null) return false;

    final errors = request.followupLostCoDealerValidationErrors();

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(createFollowUpFormErrorsProvider.notifier).addAll(errors);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final error = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.coDealerName);

    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: SalesDocketInputWidget(
              inputType: TextInputType.text,
              label: 'Co-Dealer Name',
              hint: 'Enter Co-Dealer Name',
              isRequired: true,
              errorMsg: error?.message,

              onChanged: (value) {
                ref
                    .read(followupRequestProvider.notifier)
                    .update(
                      (state) =>
                          state = state?.copyWith(
                            lostToCoDealerName: value.trim(),
                          ),
                    );
                ref
                    .read(createFollowUpFormErrorsProvider.notifier)
                    .remove(CreateFollowUpFormFields.coDealerName);
              },
            ),
          ),
          verticalSpacing(2.h),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: LocaleKeys.lblReasonForRejectingBrand.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: appColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: ' *',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: appColors.accent),
                ),
              ],
            ),
          ),
          SizedBox(height: 64.h, child: RejectReasonWidget()),
          verticalSpacing(3.h),
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
    );
  }

  @override
  void onCompetitionProductsFetched(List<CompetitionProduct> list) {
    ref.read(competitionProductsProvider.notifier).update((_) => list);
  }

  @override
  void onCompetitionModelsFetched(List<CompetitionProduct> list) {
    ref.read(competitionModelsProvider.notifier).update((_) => list);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  void _resetFollowupState() {
    // Reset all followup state
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
    context.router.maybePop(isUpdate);
  }

  @override
  void onLeadStatusChanged(String? leadStatus) async {
    // Read data BEFORE popping the screen
    final lead = ref.read(followupLeadRequestProvider);
    final followupData = ref.read(followupRequestProvider);

    showSnackBar('Lead updated successfully', type: SnackBarType.success);

    // Reset all followup state after successful status change
    ref.read(followupStatusProvider.notifier).state = FollowupStatus.initial;
    ref.read(callStatusProvider.notifier).state = null;
    ref.read(callDurationProvider.notifier).state = null;
    ref.read(callInProgressProvider.notifier).state = false;
    ref.read(followupRequestProvider.notifier).state = null;

    // Navigate back to listing screen
    leadActionBackToPrevScreen(context);

    // Don't create followup for LOST or LPA leads
    // Lost leads are being closed and don't need future followups
    if (leadStatus?.toUpperCase() == 'LOST' ||
        leadStatus?.toUpperCase() == 'LPA') {
      return;
    }

    // Only create followup if we have the required data
    if (lead == null ||
        followupData?.nextFollowup == null ||
        followupData?.when == null) {
      // No followup data - this is expected for lost leads
      return;
    }

    final followupRequest = followupData?.createLeadFollowupRequest();

    try {
      await createFollowup(leadId: lead.id, request: followupRequest);
    } catch (error) {
      showSnackBar("Failed to create followup. Please try again.");
      debugPrint("Error creating follow-up: $error");
    }
  }

  @override
  WidgetRef get eventRef => ref;
}
