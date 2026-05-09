import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_plan_follow_up_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../common/constants/follow_up_plan_type.dart';

class CreateLeadPlanFollowUpWidget extends SalesdocketConsumerWidget {
  const CreateLeadPlanFollowUpWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFollowUpPlan = ref.watch(
      leadRequestProvider.select((lead) => lead?.followUpPlan),
    );
    final selectedFollowUpDateTime = ref.watch(
      leadRequestProvider.select((lead) => lead?.followUpDateTime),
    );
    final createLeadErrors = ref.watch(createLeadFormErrorsProvider);

    return SalesdocketPlanFollowUpWidget(
      selectedPlanFollowup: selectedFollowUpPlan,
      selectedFollowUpDateTime: selectedFollowUpDateTime,
      followupPlanError: createLeadErrors.get(LeadFormFields.planFollowUp),
      followupDateTimeError: createLeadErrors.get(
        LeadFormFields.followUpDateTime,
      ),
      onDateTimeSelected: (selected) {
        ref
            .read(leadRequestProvider.notifier)
            .update(
              (lead) => lead = lead?.copyWith(followUpDateTime: selected),
            );
        ref
            .read(createLeadFormErrorsProvider.notifier)
            .remove(LeadFormFields.followUpDateTime);
      },
      onPlanSelected: (selected) {
        ref
            .read(leadRequestProvider.notifier)
            .update((lead) => lead = lead?.copyWith(followUpPlan: selected));
        ref
            .read(createLeadFormErrorsProvider.notifier)
            .remove(LeadFormFields.planFollowUp);
      },
    );
  }
}
