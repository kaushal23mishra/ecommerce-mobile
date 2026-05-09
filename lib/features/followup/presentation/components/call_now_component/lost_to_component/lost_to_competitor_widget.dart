import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/followup_data_given.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/followup/presentation/components/reject_reason_widget.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/interested_in_comp.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/utility/request_utils.dart';

class LostToCompetitorWidget extends SalesdocketConsumerWidget {
  const LostToCompetitorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interestedInComp = ref.watch(selectBrandAndModelProvider);
    return SalesDocketSelectBrandWidget(
      interestedInComp: interestedInComp,
      onChanged: (field, key, value) => _onValueChanged(field, key, ref),
    );
  }

  void _onValueChanged(
    CreateFollowUpFormFields field,
    dynamic key,
    WidgetRef ref,
  ) {
    ref.read(createFollowUpFormErrorsProvider.notifier).remove(field);
    ref
        .read(selectBrandAndModelProvider.notifier)
        .update(
          (toUpdate) => toUpdate?.copyWith(
            brand:
                field == CreateFollowUpFormFields.selectBrand
                    ? key
                    : toUpdate.brand,
            model:
                field == CreateFollowUpFormFields.selectModel
                    ? key
                    : toUpdate.model,
          ),
        );
  }
}

class SalesDocketSelectBrandWidget extends SalesdocketConsumerStatefulWidget {
  final InterestedInComp? interestedInComp;
  final Function(CreateFollowUpFormFields, dynamic, dynamic)? onChanged;

  const SalesDocketSelectBrandWidget({
    super.key,
    this.interestedInComp,
    this.onChanged,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalesDocketSelectBrandWidgetState();
}

class _SalesDocketSelectBrandWidgetState
    extends SalesdocketConsumerState<SalesDocketSelectBrandWidget>
    with ProductEvents, LeadEvents, NavigationEvents {
  @override
  Future<void> onLeadHistoryCreated() async {
    final lead = ref.read(followupLeadRequestProvider);
    final followupRequest =
        ref.read(followupRequestProvider)?.createLeadFollowupRequest();

    if (lead == null || followupRequest?.followUpDateTime == null) {
      return;
    }

    try {
      await createFollowup(leadId: lead.id, request: followupRequest);
    } catch (error) {
      showSnackBar("Failed to create follow-up. Please try again.");
      print("Error creating follow-up: $error");
    }
  }

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
      showSnackBar("Error: Missing lead or follow-up status.");
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
      if (mounted) leadActionBackToPrevScreen(context);
    } catch (error, stackTrace) {
      if (mounted) {
        showSnackBar("Failed to create lead history. Please try again.");
      }
      debugPrint("Error creating lead history: $error\n$stackTrace");
    }
  }

  bool _isValidForm(FollowupDataGiven? request) {
    if (request == null) return false;

    final errors = request.followupLostCompetitorValidationErrors();

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(createFollowUpFormErrorsProvider.notifier).addAll(errors);
      return false;
    }
    return true;
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 2.w,
            children: [
              Expanded(child: _brandsWidget(context)),
              Expanded(child: _modelsWidget(context)),
            ],
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

  Widget _brandsWidget(BuildContext context) {
    final brands = ref.watch(competitionProductsProvider);
    final Set<int> seenBrandIds = {};

    final itemList =
        brands.map((brand) => brand.brand).where((brand) {
          final brandId = brand?.id;
          if (brandId == null || seenBrandIds.contains(brandId)) {
            return false;
          }
          seenBrandIds.add(brandId);
          return true;
        }).toList();

    final selectedBrand = itemList.firstWhereOrNull(
      (item) => item?.id == widget.interestedInComp?.brand,
    );

    return SalesDocketDropDownWidget(
      text: "Select Brand",
      isRequired: true,
      itemList: itemList.map((item) => item?.name ?? "").toList(),
      itemValue: selectedBrand?.name,
      imagePath: Assets.svg.arrowDown.path,
      onChanged: (selected) {
        final selectedId =
            itemList.firstWhereOrNull((item) => item?.name == selected)?.id;

        if (selectedId != null) {
          widget.onChanged?.call(
            CreateFollowUpFormFields.selectBrand,
            selectedId,
            null,
          );
          getCompetitionModels(brandId: selectedId);
        }
      },
      errorText:
          ref
              .watch(createFollowUpFormErrorsProvider)
              .get(CreateFollowUpFormFields.selectBrand)
              ?.message ??
          "",
    );
  }

  Widget _modelsWidget(BuildContext context) {
    final itemList = ref.watch(competitionModelsProvider);
    final selectedModel = itemList.firstWhereOrNull(
      (item) => item.id == widget.interestedInComp?.model,
    );

    return SalesDocketDropDownWidget(
      text: "Select Model",
      isRequired: true,
      itemList:
          (widget.interestedInComp?.brand != null)
              ? itemList.map((item) => item.name ?? "").toList()
              : [],
      itemValue: selectedModel?.name,
      imagePath: Assets.svg.arrowDown.path,
      onChanged: (selected) {
        final selectedId =
            itemList.firstWhereOrNull((item) => item.name == selected)?.id;

        if (selectedId != null) {
          ref
              .read(followupRequestProvider.notifier)
              .update((followup) => followup?.copyWith(productId: selectedId));
          widget.onChanged?.call(
            CreateFollowUpFormFields.selectModel,
            selectedId,
            null,
          );
        }
      },
      errorText:
          ref
              .watch(createFollowUpFormErrorsProvider)
              .get(CreateFollowUpFormFields.selectModel)
              ?.message ??
          "",
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

