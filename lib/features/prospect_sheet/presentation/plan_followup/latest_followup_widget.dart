import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_history_extensions.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/presentation/plan_followup/plan_followup_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../common/constants/form_fields.dart';

class LatestFollowupWidget extends SalesdocketConsumerWidget {
  const LatestFollowupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lead = ref.watch(prospectLeadRequestProvider);
    final rescheduleFollowup = ref.watch(rescheduleFollowupProvider);
    final leadHistory = ref.watch(prospectLeadHistoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 4.w,
          children: [
            Expanded(
              child: Text(
                LocaleKeys.lblLatestFollowup.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (leadHistory.canRescheduleFollowup)
              SalesdocketSwitchWidget(
                label: LocaleKeys.reschedule.tr(),
                value: rescheduleFollowup,
                onChanged: (value) {
                  ref
                      .read(rescheduleFollowupProvider.notifier)
                      .update((state) => value);
                  ref
                      .read(rescheduleFollowupRequestProvider.notifier)
                      .update(
                        (state) => LeadFollowupRequest(
                          followUpDateTime: DateTime.now().formatDateTime(),
                        ),
                      );
                },
              ),
          ],
        ),
        if (rescheduleFollowup) ...[
          verticalSpacing(2.h),
          const PlanFollowupWidget(),
          verticalSpacing(1.h),
          SalesDocketInputWidget(
            label: LocaleKeys.lblReason.tr(),
            hint: LocaleKeys.lblReason.tr(),
            isRequired: true,
            errorMsg:
                ref
                    .watch(prospectFormErrorsProvider)
                    .get(LeadFormFields.rescheduleReason)
                    ?.message,
            onChanged: (value) {
              ref
                  .read(rescheduleFollowupRequestProvider.notifier)
                  .update(
                    (state) => state?.copyWith(editReason: value),
                  );
              ref
                  .read(prospectFormErrorsProvider.notifier)
                  .remove(LeadFormFields.rescheduleReason);
            },
          ),
          verticalSpacing(1.h),
        ],
        verticalSpacing(1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
          decoration: BoxDecoration(
            color: appColors.primaryLight,
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(color: appColors.primary, width: 0.3.w),
          ),
          child: Text(
            lead?.latestFollowup ?? "",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: appColors.textDisabled),
          ),
        ),
      ],
    );
  }
}
