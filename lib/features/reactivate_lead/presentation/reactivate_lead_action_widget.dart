import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/constants/workflow_state.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/validation_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/features/reactivate_lead/view_model/reactivate_lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ReactivateLeadActionWidget extends SalesdocketConsumerStatefulWidget {
  const ReactivateLeadActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReactivateLeadActionState();
}

class _ReactivateLeadActionState
    extends SalesdocketConsumerState<ReactivateLeadActionWidget>
    with LeadEvents {
  @override
  Widget build(BuildContext context) {
    return SalesdocketActionWidget(
      positiveText: LocaleKeys.reactivate.tr(),
      onPositiveClicked: _onReactivateClicked,
      negativeText: LocaleKeys.lblCancel.tr(),
      onNegativeClicked: () {
        _backToPrevScreen();
      },
    );
  }

  void _onReactivateClicked() {
    if (_isValidForm()) {
      final lead = ref.read(reactivateLeadProvider);
      final followupRequest =
          ref
              .read(reactivateLeadFollowupRequestProvider)
              ?.reactivateFollowupRequest();

      createFollowup(leadId: lead?.id, request: followupRequest);
    }
  }

  bool _isValidForm() {
    final followupRequest = ref.read(reactivateLeadFollowupRequestProvider);
    final createLeadHistoryRequest = ref.read(createLeadHistoryRequestProvider);
    final followupErrors = followupRequest?.validationErrors ?? [];
    final historyErrors = createLeadHistoryRequest?.validationErrors ?? [];
    final errors = followupErrors + historyErrors;

    if (errors.isNotEmpty) {
      showSnackBar(errors.firstErrorMessage);
      ref.read(reactivateLeadFormErrorsProvider.notifier).addAll(errors);
    }

    return errors.isEmpty;
  }

  void _createLeadHistory() {
    final createLeadHistoryRequest = ref.read(createLeadHistoryRequestProvider);
    final lead = ref.read(reactivateLeadProvider);
    createLeadHistory(leadId: lead?.id, req: createLeadHistoryRequest);
  }

  void _assignUser() {
    final userId = ref.read(profileProvider)?.id;
    final leadId = ref.read(reactivateLeadProvider)?.id;
    final request = Lead(assignedTo: userId);

    updateLead(leadId: leadId, lead: request);
  }

  void _changeLeadStatus(List<LeadHistory> history) {
    final lead = ref.read(reactivateLeadProvider);
    final hasLeadRegistered = history.any(
      (history) => history.leadProgress == WorkflowState.registered.value,
    );
    final status =
        hasLeadRegistered
            ? WorkflowState.registered.value
            : WorkflowState.epr.value;

    changeLeadStatus(
      leadId: lead?.id,
      request: ChangeLeadStatusRequest(leadStatus: status),
    );
  }

  void _backToPrevScreen({bool isReactivate = false}) {
    context.router.pop(isReactivate);
  }

  @override
  void onLeadHistoryFetched(List<LeadHistory> history) {
    _changeLeadStatus(history);
  }

  @override
  void onLeadUpdated(Lead? lead) {
    showSnackBar(LocaleKeys.leadReactivated, type: SnackBarType.success);
    _backToPrevScreen(isReactivate: true);
  }

  @override
  void onLeadStatusChanged(String? leadStatus) async {
    _assignUser();
  }

  @override
  void onLeadHistoryCreated() {
    final lead = ref.read(reactivateLeadProvider);
    fetchLeadHistory(leadId: lead?.id);
  }

  @override
  void onFollowupCreated() {
    _createLeadHistory();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
