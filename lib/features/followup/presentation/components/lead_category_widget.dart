import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../common/constants/follow_up_plan_type.dart';
import '../../../../common/constants/form_fields.dart';
import '../../../../generated/locale_keys.g.dart';
import 'call_status_mode.dart';
import 'followup_date_time_widget.dart';
import 'home_visit_date_time_widget.dart';

class LeadCategoryWidget extends ConsumerWidget {
  const LeadCategoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = UiComponentManager().appColors;

    /// ✅ Get lead status
    final leadCategoryStatus = ref.watch(
      followupRequestProvider.select(
        (followup) => followup?.leadCategory ?? '',
      ),
    );
    final nextFollowupError = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.nextFollowup);

    /// ✅ Get lead category error
    final error = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.leadCategory);

    /// ✅ Fetch next follow-up value (default: empty, user must select)
    final selectedFollowUpPlan = ref.watch(
      followupRequestProvider.select((lead) => lead?.nextFollowup ?? ''),
    );

    final leadHistory =
        ref
            .watch(followupLeadHistoryProvider)
            .where((history) => history.responseType != "test_drive")
            .toList();
    // final bool isSelectable =
    //     leadHistory.length > 2 &&
    //     leadHistory.isNotEmpty &&
    //     leadHistory.first.status == 1;

    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'What According To You Is the Lead Status',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextSpan(
                  text: ' *',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: appColors.accent),
                ),
              ],
            ),
          ),
          verticalSpacing(1.h),

          /// ✅ Lead Category Selection
          SalesDocketChipWidget(
            chips: leadCategoryList.map((category) => category.value).toList(),
            selectedChips:
                leadCategoryStatus.isNotEmpty ? [leadCategoryStatus] : [],
            errorText: error?.message,
            onSelected: (selected) {
              final newSelectedCategory = selected?.firstOrNull ?? '';

              /// ✅ Update lead status in provider
              ref
                  .read(followupRequestProvider.notifier)
                  .update(
                    (followup) =>
                        followup?.copyWith(leadCategory: newSelectedCategory),
                  );

              /// ✅ Remove error when valid selection is made
              if (newSelectedCategory.isNotEmpty) {
                ref
                    .read(createFollowUpFormErrorsProvider.notifier)
                    .remove(CreateFollowUpFormFields.leadCategory);
              }
            },
          ),

          /// ✅ Next Follow-up Selection (Only If Lead Status is 'Hot', 'Warm', or 'Cold')
          if (leadCategoryStatus == LocaleKeys.lblHot.tr() ||
              leadCategoryStatus == LocaleKeys.lblWarm.tr() ||
              leadCategoryStatus == LocaleKeys.lblCold.tr())
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: SalesDocketChipWidget<String>(
                label: LocaleKeys.lblPlanFollowUp.tr(),
                isRequired: true,
                chips:
                    FollowUpPlanType.values
                        .map((value) => value.value)
                        .toList(),
                selectedChips:
                    selectedFollowUpPlan.isNotEmpty
                        ? [selectedFollowUpPlan]
                        : [],
                onSelected: (selected) {
                  final nextFollowup = selected?.firstOrNull ?? '';

                  /// ✅ Update next follow-up in provider
                  ref
                      .read(followupRequestProvider.notifier)
                      .update(
                        (followup) =>
                            followup?.copyWith(nextFollowup: nextFollowup),
                      );

                  /// ✅ Remove error when valid selection is made
                  if (nextFollowup.isNotEmpty) {
                    ref
                        .read(createFollowUpFormErrorsProvider.notifier)
                        .remove(CreateFollowUpFormFields.nextFollowup);
                  }
                },
                errorText: nextFollowupError?.message,
                // disabledChips: isSelectable
                //     ? []
                //     : FollowUpPlanType.createLeadDisabledValues
                //         .map((value) => value.value)
                //         .toList(),
              ),
            ),

          /// ✅ Show Follow-up Date/Time Widget if applicable
          if ([
            LocaleKeys.lblCall.tr().trim(),
            LocaleKeys.lblHomeVisit.tr().trim(),
            LocaleKeys.lblShowroomVisit.tr().trim(),
          ].contains(selectedFollowUpPlan.trim()))
            const HomeVisitFollowupDateTimeWidget(),
          verticalSpacing(2.h),
        ],
      ),
    );
  }
}
