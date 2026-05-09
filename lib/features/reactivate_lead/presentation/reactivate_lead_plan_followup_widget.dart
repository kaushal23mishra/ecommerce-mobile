import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_plan_follow_up_widget.dart';
import 'package:salesdocket_mobile/features/reactivate_lead/view_model/reactivate_lead_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ReactivateLeadPlanFollowupWidget extends SalesdocketConsumerWidget {
  const ReactivateLeadPlanFollowupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFollowUpPlan = ref.watch(
      reactivateLeadFollowupRequestProvider.select(
        (lead) => lead?.followUpPlan,
      ),
    );
    final selectedFollowUpDateTime = ref.watch(
      reactivateLeadFollowupRequestProvider.select(
        (lead) => lead?.followUpDateTime,
      ),
    );
    final followupPlanError = ref
        .watch(reactivateLeadFormErrorsProvider)
        .get(LeadFormFields.planFollowUp);
    final followupPlanDateTimeError = ref
        .watch(reactivateLeadFormErrorsProvider)
        .get(LeadFormFields.followUpDateTime);

    return SalesdocketPlanFollowUpWidget(
      selectedPlanFollowup: selectedFollowUpPlan,
      selectedFollowUpDateTime: selectedFollowUpDateTime,
      onPlanSelected: (selected) {
        ref
            .read(reactivateLeadFollowupRequestProvider.notifier)
            .update((lead) => lead = lead?.copyWith(followUpPlan: selected));
        ref
            .read(reactivateLeadFormErrorsProvider.notifier)
            .remove(LeadFormFields.planFollowUp);
      },
      onDateTimeSelected: (selected) {
        ref
            .read(reactivateLeadFollowupRequestProvider.notifier)
            .update(
              (lead) => lead = lead?.copyWith(followUpDateTime: selected),
            );
        ref
            .read(reactivateLeadFormErrorsProvider.notifier)
            .remove(LeadFormFields.followUpDateTime);
      },
      followupPlanError: followupPlanError,
      followupDateTimeError: followupPlanDateTimeError,
    );
  }
}
