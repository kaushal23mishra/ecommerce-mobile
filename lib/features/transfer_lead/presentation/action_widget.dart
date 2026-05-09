import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_action_widget.dart';
import 'package:salesdocket_mobile/features/transfer_lead/view_model/transfer_lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ActionWidget extends SalesdocketConsumerStatefulWidget {
  const ActionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ActionState();
}

class _ActionState extends SalesdocketConsumerState<ActionWidget>
    with LeadEvents {
  @override
  Widget build(BuildContext context) {
    return SalesdocketActionWidget(
      positiveText: LocaleKeys.lblTransferLead.tr(),
      onPositiveClicked: () {
        _validateAndSubmitRequest();
      },
    );
  }

  void _validateAndSubmitRequest() {
    final lead = ref.read(transferringLeadProvider);
    if ((lead?.workflow?.isEPR ?? false) ||
        (lead?.workflow?.isRegistered ?? false)) {
      _createLeadHistory();
    } else {
      _transferLead();
    }
  }

  void _createLeadHistory() {
    final lead = ref.read(transferringLeadProvider);
    final transferRequest = ref.read(transferLeadFollowupRequestProvider);

    final leadHistoryRequest = transferRequest?.transferLeadHistoryRequest(
      lead: lead,
    );
    createLeadHistory(leadId: lead?.id, req: leadHistoryRequest);
  }

  void _createFollowup() {
    final lead = ref.read(transferringLeadProvider);
    final transferRequest = ref.read(transferLeadFollowupRequestProvider);

    final leadFollowupRequest = transferRequest?.transferLeadFollowupRequest();
    createFollowup(leadId: lead?.id, request: leadFollowupRequest);
  }

  void _transferLead() {
    final lead = ref.read(transferringLeadProvider);
    final transferRequest = ref.read(transferLeadFollowupRequestProvider);

    final transferLeadRequest = transferRequest?.transferLeadRequest();
    updateLead(leadId: lead?.id, lead: transferLeadRequest);
  }

  @override
  void onLeadHistoryCreated() {
    _createFollowup();
  }

  @override
  void onFollowupCreated() {
    _transferLead();
  }

  @override
  void onLeadUpdated(Lead? lead) {
    showSnackBar(LocaleKeys.leadTransferred.tr(), type: SnackBarType.success);
    context.router.back();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
