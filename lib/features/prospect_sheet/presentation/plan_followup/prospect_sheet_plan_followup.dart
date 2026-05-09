import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_form.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/plan_followup/add_remark_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/plan_followup/details_card_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/plan_followup/latest_followup_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/plan_followup/lead_status_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/plan_followup/prev_comments_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/plan_followup/prospect_action_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ProspectSheetPlanFollowup extends SalesdocketConsumerStatefulWidget {
  const ProspectSheetPlanFollowup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProspectSheetPlanFollowupState();
}

class _ProspectSheetPlanFollowupState
    extends SalesdocketConsumerState<ProspectSheetPlanFollowup>
    with LeadEvents {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateProviders();
      _fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lead = ref.watch(prospectLeadRequestProvider);
    if (lead == null) return const SizedBox.shrink();

    final canEdit = ref.watch(canEditProspectSheetProvider);

    return SalesdocketForm(
      formWidget: [
        verticalSpacing(2.h),
        const DetailsCardWidget(),
        verticalSpacing(2.h),
        _formWidget(canEdit),
      ],
      actionWidget: const ProspectActionWidget(),
    );
  }

  Widget _formWidget(bool canEdit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (canEdit) ...[
          const LatestFollowupWidget(),
          verticalSpacing(2.h),
          const LeadStatusWidget(),
        ],
        const PrevCommentsWidget(),
        if (canEdit) ...[
          verticalSpacing(3.h),
          const AddRemarkWidget(),
        ],
        verticalSpacing(1.h),
      ],
    );
  }

  _invalidateProviders() {
    final providers = [
      prospectLeadRequestProvider,
      prospectLeadHistoryProvider,
      updatedFollowupPlanProvider,
      rescheduleFollowupProvider,
      rescheduleFollowupRequestProvider,
    ];
    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [prospectFormErrorsProvider];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  void _initProviders(Lead? lead) {
    if (!mounted) return;
    Future.microtask(() {
      if (!mounted) return;
      ref
          .read(prospectLeadRequestProvider.notifier)
          .update((state) => lead?.copyWith());
      ref
          .read(updatedFollowupPlanProvider.notifier)
          .update((state) => const CreateLeadHistoryRequest());
    });
  }

  void _fetchData() {
    final lead = ref.read(prevProspectLeadRequestProvider);
    fetchLead(leadId: lead?.id);
  }

  @override
  void onLeadHistoryFetched(List<LeadHistory> history) {
    if (!mounted) return;
    ref
        .read(prospectLeadHistoryProvider.notifier)
        .update((state) => history);
  }

  @override
  void onLeadFetched(Lead? lead) {
    if (!mounted) return;
    ref
        .read(prevProspectLeadRequestProvider.notifier)
        .update((state) => lead ?? state);
    _initProviders(lead);
    fetchLeadHistory(leadId: lead?.id);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
