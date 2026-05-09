import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/filter_date_widget.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import '../../../../common/classes/salesdocket_consumer_state.dart';
import '../../../../common/constants/form_fields.dart';
import '../../view_model/followup_view_model.dart';

class FollowupExpectedMonthOfConversionWidget
    extends SalesdocketConsumerWidget {
  const FollowupExpectedMonthOfConversionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(
      followupRequestProvider.select((req) => req?.expectedMonthOfConversion),
    );

    final error = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.expectedMonthOfConversion);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterDateWidget(
          fromDate: selectedDate,
          fromHeader: LocaleKeys.lblExpectedMonthOfConversion.tr(),
          visibleFormat: 'MMM-yyyy',
          minTime: DateTimeConstants.currentMinDateTime,
          mode: CupertinoDatePickerMode.monthYear,
          format: 'yyyy-MM',
          onFromDateChanged: (date) {
            // Store DateTime directly
            ref
                .read(followupRequestProvider.notifier)
                .update(
                  (state) => state?.copyWith(
                    expectedMonthOfConversion: date,
                  ), // Store DateTime
                );

            ref
                .read(createFollowUpFormErrorsProvider.notifier)
                .remove(CreateFollowUpFormFields.expectedMonthOfConversion);
          },
        ),

        if (error != null)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
            child: Text(
              error.message ?? "",
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: appColors.error),
            ),
          ),
      ],
    );
  }
}
