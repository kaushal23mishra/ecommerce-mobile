import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_plan_follow_up_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../common/constants/follow_up_plan_type.dart';

class PlanFollowupWidget extends SalesdocketConsumerWidget {
  const PlanFollowupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFollowUpPlan = ref.watch(
      rescheduleFollowupRequestProvider.select((lead) => lead?.followUpPlan),
    );
    final selectedFollowUpDateTime = ref.watch(
      rescheduleFollowupRequestProvider.select(
        (lead) => lead?.followUpDateTime,
      ),
    );
    final followupPlanError = ref
        .watch(prospectFormErrorsProvider)
        .get(LeadFormFields.planFollowUp);
    final followupPlanDateTimeError = ref
        .watch(prospectFormErrorsProvider)
        .get(LeadFormFields.followUpDateTime);

    return SalesdocketPlanFollowUpWidget(
      selectedPlanFollowup: selectedFollowUpPlan,
      selectedFollowUpDateTime: selectedFollowUpDateTime,
      onPlanSelected: (selected) {
        ref
            .read(rescheduleFollowupRequestProvider.notifier)
            .update((lead) => lead?.copyWith(followUpPlan: selected));
        ref
            .read(prospectFormErrorsProvider.notifier)
            .remove(LeadFormFields.planFollowUp);
      },
      onDateTimeSelected: (selected) {
        ref
            .read(rescheduleFollowupRequestProvider.notifier)
            .update(
              (lead) => lead?.copyWith(followUpDateTime: selected),
            );
        ref
            .read(prospectFormErrorsProvider.notifier)
            .remove(LeadFormFields.followUpDateTime);
      },
      followupPlanError: followupPlanError,
      followupDateTimeError: followupPlanDateTimeError,
    );
  }
}
