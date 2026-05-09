import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/widgets/filter_date_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';

class ExpectedMonthOfConversionWidget extends SalesdocketConsumerWidget {
  const ExpectedMonthOfConversionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(
      leadFilterRequestProvider.select((req) => req?.expectedMonthOfConversion),
    );

    return FilterDateWidget(
      fromDate: selectedDate,
      fromHeader: LocaleKeys.lblExpectedMonthOfConversion.tr(),
      visibleFormat: 'MMM-yyyy',
      mode: CupertinoDatePickerMode.monthYear,
      format: 'yyyy-MM',
      onFromDateChanged: (date) {
        ref
            .read(leadFilterRequestProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    expectedMonthOfConversion: date,
                  ),
            );
      },
    );
  }
}
