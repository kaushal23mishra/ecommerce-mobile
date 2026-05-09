import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/create_lead_events.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class CreateLeadActionWidget extends SalesdocketConsumerStatefulWidget {
  const CreateLeadActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateLeadActionState();
}

class _CreateLeadActionState
    extends SalesdocketConsumerState<CreateLeadActionWidget>
    with CreateLeadEvents, LeadEvents {
  @override
  Widget build(BuildContext context) {
    return SalesdocketActionWidget(
      positiveText: LocaleKeys.lblEPR.tr(),
      onPositiveClicked: () {
        _validateFormAndSubmitRequest();
      },
      negativeText: LocaleKeys.lblCancel.tr(),
      onNegativeClicked: () {
        context.router.maybePop();
      },
    );
  }

  void _validateFormAndSubmitRequest() {
    final duplicateLead = ref.read(duplicateLeadInOtherOutletProvider);
    final leadRequest = ref
        .read(leadRequestProvider)
        ?.createRequest(duplicateLead: duplicateLead);
    if (leadRequest == null) return;

    if (_isValidForm()) {
      createGroupedLead(request: leadRequest);
    }
  }

  bool _isValidForm() {
    final createLeadRequest = ref.read(leadRequestProvider);
    final isAddedFullAddress = ref.read(isAddedFullAddressProvider);
    final errors =
        createLeadRequest?.validationErrors(
          isAddedFullAddress: isAddedFullAddress,
        ) ??
        [];
    if (errors.isNotEmpty) {
      ref.read(createLeadFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }

  @override
  void onLeadCreated(Lead? lead) async {
    final router = context.router;
    ref.read(createdLeadProvider.notifier).update((state) => state = lead);

    // Close followup for CC leads after EPR creation
    // Use boolean flag to check if creating from CC lead flow
    final isCreatingFromCCLead = ref.read(isCreatingFromCCLeadProvider);
    final leadRequest = ref.read(leadRequestProvider);
    final followupsId = leadRequest?.followupsId;

    if (isCreatingFromCCLead && followupsId != null) {
      final followupRequest = CloseFollowupRequest(
        rejectionReason: "",
        followupResponse: "1",
        followupResponseRemarks: "Spoke to customer",
        planNext: "0",
        nextFollowupTime: "",
        nextFollowupType: "",
      );

      try {
        await closeLeadHistory(followupId: followupsId, req: followupRequest);
      } catch (error) {
        showSnackBar("Failed to close followup. Please try again.");
      }

      // Reset the flag after use
      ref.read(isCreatingFromCCLeadProvider.notifier).state = false;
    }

    router.replace(const CreateLeadResultRoute());
  }

  @override
  Future<void> onLeadHistoryCreated() async {
    final lead = ref.watch(followupLeadRequestProvider);
    if (lead!.isItHOLead || lead.isItCCLead) {
      final followupsId = ref.watch(
        leadRequestProvider.select((lead) => lead?.followupsId),
      );

      final followupRequest =
          ref.read(followupRequestProvider)?.closeFollowupRequest();

      // Validation checks
      if (followupsId == null) {
        showSnackBar("Error: Missing lead follow-up ID.");
        return;
      }

      if (followupRequest == null) {
        showSnackBar("Error: Missing follow-up request.");
        return;
      }

      final router = context.router;

      await closeLeadHistory(followupId: followupsId, req: followupRequest);

      router.replace(const CreateLeadResultRoute());
    }
  }

  @override
  void showBottomSheet({
    bool isDismissible = false,
    required WidgetBuilder builder,
  }) {
    showSalesdocketBottomSheet(
      context: context,
      isDismissible: isDismissible,
      builder: builder,
    );
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
