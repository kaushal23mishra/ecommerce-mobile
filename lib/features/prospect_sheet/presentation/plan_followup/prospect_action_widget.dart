import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/navigation_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ProspectActionWidget extends SalesdocketConsumerStatefulWidget {
  const ProspectActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProspectActionState();
}

class _ProspectActionState
    extends SalesdocketConsumerState<ProspectActionWidget>
    with LeadEvents, NavigationEvents {
  @override
  Widget build(BuildContext context) {
    final canEdit = ref.watch(canEditProspectSheetProvider);

    return SalesdocketActionWidget(
      negativeText: LocaleKeys.exit.tr(),
      positiveText: canEdit ? LocaleKeys.register.tr() : null,
      onNegativeClicked: () {
        leadActionBackToPrevScreen(context, shouldBackToPrev: true);
      },
      onPositiveClicked: canEdit ? () {
        _validateFormAndSubmitRequest();
      } : null,
    );
  }

  void _validateFormAndSubmitRequest() {
    final lead = ref.read(prospectLeadRequestProvider);
    if (lead == null) return;

    if (_isValidForm(lead)) {
      final request = lead.changeLeadStatusRequest();
      changeLeadStatus(leadId: lead.id, request: request);
    }
  }

  bool _isValidForm(Lead? request) {
    final followupPlan = ref.read(updatedFollowupPlanProvider);
    final isReschedulingFollowup = ref.read(rescheduleFollowupProvider);
    final reschedulingFollowup = ref.read(rescheduleFollowupRequestProvider);
    final errors =
        request?.prospectPlanFollowupValidationErrors(
          followupPlanRequest: followupPlan,
          isReschedulingFollowup: isReschedulingFollowup,
          reschedulingFollowup: reschedulingFollowup,
        ) ??
        [];

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(prospectFormErrorsProvider.notifier).removeAll();
      ref.read(prospectFormErrorsProvider.notifier).addAll(errors);
    } else {
      ref.read(prospectFormErrorsProvider.notifier).removeAll();
    }

    return errors.isEmpty;
  }

  void _reschedulePlanFollowup() {
    final isReschedulingFollowup = ref.read(rescheduleFollowupProvider);
    if (!isReschedulingFollowup) {
      _createLeadHistory();
      return;
    }

    final reschedulingFollowup = ref.read(rescheduleFollowupRequestProvider);
    final lead = ref.read(prospectLeadRequestProvider);
    final request = lead?.createReschedulePlanFollowupRequest(
      newFollowupPlan: reschedulingFollowup,
    );
    if (request?.workflowId != null) {
      updateFollowup(
        workflowId: request?.workflowId,
        request: request,
      );
    } else {
      createFollowup(leadId: lead?.id, request: request);
    }
  }

  void _createLeadHistory() {
    final followupPlan = ref.read(updatedFollowupPlanProvider);
    final lead = ref.read(prospectLeadRequestProvider);
    final request = lead?.createPlanFollowupLeadHistoryRequest(
      followupPlan: followupPlan,
    );
    createLeadHistory(leadId: lead?.id, req: request);
  }

  @override
  void onLeadStatusChanged(String? leadStatus) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _reschedulePlanFollowup();
    });
  }

  @override
  void onFollowupCreated() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _createLeadHistory();
    });
  }

  @override
  void onFollowupUpdated() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _createLeadHistory();
    });
  }

  @override
  void onLeadHistoryCreated() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showSnackBar(
        LocaleKeys.msgLeadRegisteredSuccessfully.tr(),
        type: SnackBarType.success,
      );
      leadActionBackToPrevScreen(context);
    });
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
