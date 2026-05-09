import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/features/followup/presentation/components/validate_later/validate_later_widget.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/utility/booking_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../common/classes/salesdocket_consumer_state.dart';
import '../../../../common/constants/contact_type.dart';
import '../../../../common/constants/follow_up_plan_type.dart';
import '../../../../common/constants/form_fields.dart';
import '../../../../common/constants/purchase_mode.dart';
import '../../../../common/constants/strings.dart';
import '../../../../common/constants/widget.dart';
import '../../../../common/entity/followup_data_given.dart';
import '../../../../common/events/lead_events.dart';
import '../../../../common/widgets/salesdocket_action_widget.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../routing/app_router.dart';
import '../../../../utility/request_utils.dart';
import 'call_now_component/lost_to_component/lost_to_widget.dart';
import 'call_status_mode.dart';
import 'followup_customer_comment_widget.dart';
import 'followup_expected_mont_of_conversion_widget.dart';
import 'followup_reason_widget.dart';
import 'lead_category_widget.dart';
import 'not_done_component/followup_done_test_drive_given_widget.dart';

class NewLeadStatusWidget extends SalesdocketConsumerStatefulWidget {
  const NewLeadStatusWidget({super.key});

  @override
  SalesdocketConsumerState<NewLeadStatusWidget> createState() =>
      _NewLeadStatusWidgetState();
}

class _NewLeadStatusWidgetState
    extends SalesdocketConsumerState<NewLeadStatusWidget>
    with LeadEvents, NavigationEvents {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lead = ref.watch(followupLeadRequestProvider);
    final followupAction = lead?.workflow?.actions?.lastOrNull;
    final action = followupAction?.action?.toLowerCase() ?? "";
    final isVisitAction = {
      "dealer visit",
      "home visit",
      "showroom visit",
    }.contains(action);

    final newLeadStatus = ref.watch(
      followupRequestProvider.select(
        (followup) => followup?.newLeadStatus ?? '',
      ),
    );
    final error = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.newLeadStatus);
    final ccLeadLeadStatus = ref.watch(
      followupRequestProvider.select(
        (followup) => followup?.ccLeadStatus ?? '',
      ),
    );

    if (lead == null) {
      return const Center(child: CircularProgressIndicator());
    }

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

          // Lead Status Selection Widget
          if (lead.workflow?.isLPA ?? false)
            _buildChipWidget(
              chips: ValidateNewLeadStatusType.values,
              selectedChips: newLeadStatus.isNotEmpty ? [newLeadStatus] : [],
              errorText: error?.message,
              fieldType: CreateFollowUpFormFields.newLeadStatus,
              updateFollowup: (selectedStatus) {
                ref
                    .read(followupRequestProvider.notifier)
                    .update(
                      (followup) => followup?.copyWith(
                        newLeadStatus: selectedStatus,
                        leadStatus: selectedStatus,
                        nextFollowup:
                            selectedStatus == 'Validate Later'
                                ? 'lpa_call'
                                : followup.nextFollowup,
                      ),
                    );
              },
            )
          else if (lead.isItCCLead)
            _buildChipWidget(
              chips: coldCallingStatusList.map((e) => e.localized()).toList(),
              selectedChips:
                  ccLeadLeadStatus.isNotEmpty ? [ccLeadLeadStatus] : [],
              fieldType: CreateFollowUpFormFields.ccLeadLeadStatus,
              updateFollowup: (selectedStatus) {
                _handleCCLeadStatusChange(selectedStatus, lead);
              },
            )
          else if (lead.isItHOLead)
            _buildChipWidget(
              chips: hoLeadStatusList.map((e) => e.localized()).toList(),
              selectedChips:
                  ccLeadLeadStatus.isNotEmpty ? [ccLeadLeadStatus] : [],
              fieldType: CreateFollowUpFormFields.ccLeadLeadStatus,
              updateFollowup: (selectedStatus) {
                _handleHoLeadStatusChange(selectedStatus, lead);
              },
            )
          else
            _buildChipWidget(
              chips: newLeadStatusList,
              selectedChips: newLeadStatus.isNotEmpty ? [newLeadStatus] : [],
              errorText: error?.message,
              fieldType: CreateFollowUpFormFields.newLeadStatus,
              updateFollowup: (selectedStatus) {
                ref
                    .read(followupRequestProvider.notifier)
                    .update(
                      (followup) => followup?.copyWith(
                        newLeadStatus: selectedStatus,
                        leadStatus: selectedStatus,
                      ),
                    );
              },
            ),

          verticalSpacing(1.h),

          if (newLeadStatus == LocaleKeys.lblActive.tr()) ...[
            const FollowupCustomerCommentWidget(),
            const FollowupExpectedMonthOfConversionWidget(),
            if (isVisitAction) ...[
              verticalSpacing(2.h),
              const FollowupDoneTestDriveGivenWidget(),
            ],
            verticalSpacing(1.h),
            const LeadCategoryWidget(),
            SalesdocketActionWidget(
              positiveText: LocaleKeys.btnSave.tr(),
              onPositiveClicked: () {
                final followupRequest = ref.read(followupRequestProvider);
                if (_isValidForm(followupRequest)) {
                  _createLeadHistory(
                    status: '1',
                    onSuccess: () {
                      leadActionBackToPrevScreen(context);
                    },
                  );
                }
              },
              negativeText: LocaleKeys.lblCancel.tr(),
              onNegativeClicked: _backToPrevScreen,
            ),
          ],

          if (newLeadStatus == LocaleKeys.lblLost.tr()) const LostToWidget(),
          if (newLeadStatus == 'Validate Later') const ValidateLaterWidget(),
          if (newLeadStatus == LocaleKeys.lblClosed.tr())
            const FollowupReasonWidget(),
        ],
      ),
    );
  }

  void _handleCCLeadStatusChange(String selectedStatus, Lead lead) {
    if (selectedStatus == LocaleKeys.lblActive.tr()) {
      Future.microtask(() {
        if (!mounted) return;
        final contactNumber = lead.contactNumber;
        final firstName = lead.leadFirstName;
        final lastName = lead.leadLastName;
        final sourceOfInformation = lead.campaign?.sourceOfInformation;
        final leadSource = lead.campaign?.leadSource;
        final myCreateLeadRequestData = CreateLeadRequest(
          salutation: lead.salutation ?? CommonString.salutations.first,
          contactDetails: [
            ContactDetails(
              type: ContactType.mobile.value,
              value: contactNumber,
              fixed: true,
            ),
          ],
          firstName: firstName,
          lastName: lastName,
          isEdit: firstName != null ? false : true,
          followupsId: lead.followups?.firstOrNull?.id,
          sourceOfInformation: sourceOfInformation,
          leadSource: leadSource,
          isExchange: 0,
          purchaseMode: PurchaseMode.cash.value,
          followUpPlan: FollowUpPlanType.call.value,
          dateOfEnquiry: DateTime.now().formatDateTime(),
          isUpdateLead: true,
          isCampaignLead: "1",
          campaignId: lead.campaignId?.toString(),
          campaignLeadId: lead.id?.toString(),
        );
        ref
            .read(leadRequestProvider.notifier)
            .update((state) => myCreateLeadRequestData);
        // Set flag to indicate we're creating EPR from CC lead
        ref.read(isCreatingFromCCLeadProvider.notifier).state = true;
        context.router.push(const CreateLeadRoute());
      });
    } else if (selectedStatus == LocaleKeys.lblReject.tr()) {
      ref
          .read(followupRequestProvider.notifier)
          .update(
            (followup) => followup?.copyWith(
              newLeadStatus: LocaleKeys.lblClosed.tr(),
              leadStatus: selectedStatus,
              followupId: lead.followups?.firstOrNull?.id,
              nextFollowup:
                  selectedStatus == 'Validate Later'
                      ? 'lpa_call'
                      : followup.nextFollowup,
            ),
          );
    }
  }

  void _handleHoLeadStatusChange(String selectedStatus, Lead lead) {
    if (selectedStatus == LocaleKeys.lblActive.tr()) {
      Future.microtask(() {
        if (!mounted) return;
        final contactNumber = lead.contactNumber;
        final firstName = lead.firstName;
        final lastName = lead.lastName;
        final sourceOfInformation =
            lead.campaign?.sourceOfInformation ?? lead.sourceOfInformation;
        final leadSource = lead.campaign?.leadSource ?? lead.leadSource;
        final engineType = lead.interestedVariant?.firstOrNull?.engineType;
        final modelId = lead.interestedVariant?.firstOrNull?.productId;
        final variantId = lead.interestedVariant?.firstOrNull?.pivot?.variantId;

        final myCreateLeadRequestData = CreateLeadRequest(
          contactDetails: [
            ContactDetails(
              type: ContactType.mobile.value,
              value: contactNumber,
            ),
          ],
          salutation: lead.salutation ?? CommonString.salutations.firstOrNull,
          firstName: firstName,
          lastName: lastName,
          isEdit: firstName != null ? false : true,
          model: modelId,
          variant: variantId != null ? [variantId] : [],
          primaryVariantId: variantId,
          engineType: engineType,
          sourceOfInformation: sourceOfInformation,
          leadSource: leadSource,
          followupsId: lead.followups?.firstOrNull?.id,
          isExchange: 0,
          purchaseMode: PurchaseMode.cash.value,
          followUpPlan: FollowUpPlanType.call.value,
          dateOfEnquiry: DateTime.now().formatDateTime(),
          isUpdateLead: true,
          isCampaignLead: lead.isCampaignLead?.toString(),
          campaignId: lead.campaignId?.toString(),
          campaignLeadId: lead.id?.toString(),
        );
        ref
            .read(leadRequestProvider.notifier)
            .update((state) => myCreateLeadRequestData);
        context.router.push(const CreateLeadRoute());
      });
    } else if (selectedStatus == LocaleKeys.lblReject.tr()) {
      ref
          .read(followupRequestProvider.notifier)
          .update(
            (followup) => followup?.copyWith(
              newLeadStatus: LocaleKeys.lblClosed.tr(),
              leadStatus: selectedStatus,
              followupId: lead.followups?.firstOrNull?.id,
              nextFollowup:
                  selectedStatus == 'Validate Later'
                      ? 'lpa_call'
                      : followup.nextFollowup,
            ),
          );
    } else {
      ref
          .read(followupRequestProvider.notifier)
          .update(
            (followup) => followup?.copyWith(
              followupId: lead.followups?.firstOrNull?.id,
              newLeadStatus: selectedStatus,
              leadStatus: selectedStatus,
            ),
          );
    }
  }

  Widget _buildChipWidget({
    required List<String> chips,
    required List<String> selectedChips,
    String? errorText,
    required CreateFollowUpFormFields fieldType,
    required Function(String) updateFollowup,
  }) {
    return SalesDocketChipWidget(
      chips: chips,
      selectedChips: selectedChips,
      errorText: errorText,
      onSelected: (selected) {
        final selectedStatus = selected?.firstOrNull ?? '';
        updateFollowup(selectedStatus);
        ref.read(createFollowUpFormErrorsProvider.notifier).remove(fieldType);
      },
    );
  }

  Future<void> _createLeadHistory({
    required String status,
    required VoidCallback onSuccess,
  }) async {
    final lead = ref.read(followupLeadRequestProvider);
    final followupRequest = ref.read(followupRequestProvider);
    final testDriveGiven = ref.read(followupTestDriveGivenProvider);

    if (lead == null || followupRequest == null) {
      showSnackBar("Error: Missing lead or follow-up request.");
      return;
    }

    final followupAction = lead.workflow?.actions?.lastOrNull;
    final action = followupAction?.action?.toLowerCase() ?? "";
    final isVisitAction = {
      "dealer visit",
      "home visit",
      "showroom visit",
    }.contains(action);
    final followupImages = ref.read(followupImagesProvider);
    final images = BookingUtils.getFollowupImages(followupImages);
    final request = FollowupRequestUtils.createLeadHistoryRequest(
      followupData: followupRequest,
      lead: lead,
      status: status,
      responseCarUsed:
          testDriveGiven?.vehicleUsed ??
          followupRequest.responseCarUsed ??
          lead.interestedVariant?.firstOrNull?.product?.name ??
          '',
      when: testDriveGiven?.when ?? '',
      responseType: 'comment',
      documents: images,
    );

    try {
      await createLeadHistory(leadId: lead.id, req: request);

      if (isVisitAction) {
        final newTestDrive = ref.read(followupTestDriveGivenProvider);
        await createLeadHistory(
          hasCallBack: false,
          leadId: lead.id,
          req: RequestUtils.createLeadHistoryRequest(
            newTestDrive: newTestDrive,
          ),
        );
      }

      if (!mounted) return;

      // Reset all followup state after successful save
      ref.read(followupStatusProvider.notifier).state = FollowupStatus.initial;
      ref.read(followupCallStatusProvider.notifier).state = false;
      ref.read(followupAlreadySpokenStatusProvider.notifier).state = false;
      ref.read(followupDoneStatusProvider.notifier).state = false;
      ref.read(followupNotDoneStatusProvider.notifier).state = false;
      ref.read(callStatusProvider.notifier).state = null;
      ref.read(callDurationProvider.notifier).state = null;
      ref.read(callInProgressProvider.notifier).state = false;
      ref.read(followupRequestProvider.notifier).state = null;

      onSuccess();
    } catch (e) {
      showSnackBar("Error creating lead history: ${e.toString()}");
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
    } catch (e) {
      showSnackBar("Error creating followup: ${e.toString()}");
    }
  }

  bool _isValidForm(FollowupDataGiven? request) {
    if (request == null) return false;
    final errors = request.followupNewLeadStatusValidationErrors();
    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(createFollowUpFormErrorsProvider.notifier).addAll(errors);
      return false;
    }
    return true;
  }

  void _backToPrevScreen({bool isUpdate = false}) {
    // Reset all followup state
    ref.read(followupStatusProvider.notifier).state = FollowupStatus.initial;
    ref.read(callStatusProvider.notifier).state = null;
    ref.read(callDurationProvider.notifier).state = null;
    ref.read(callInProgressProvider.notifier).state = false;
    ref.read(followupRequestProvider.notifier).state = null;
    ref.read(createFollowUpFormErrorsProvider.notifier).removeAll();

    context.router.maybePop(isUpdate);
  }

  @override
  void onLeadFetched(Lead? lead) async {
    ref
        .read(followupLeadRequestProvider.notifier)
        .update((state) => lead ?? state);
    if (lead?.id != null) {
      await fetchLeadHistory(leadId: lead?.id);
    }
  }

  @override
  void onLeadStatusChanged(String? leadStatus) {
    showSnackBar('Lead updated successfully', type: SnackBarType.success);
    _backToPrevScreen(isUpdate: true);
  }

  @override
  WidgetRef get eventRef => ref;
}
