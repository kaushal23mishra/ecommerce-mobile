import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DateOfBirthWidget extends SalesdocketConsumerWidget {
  const DateOfBirthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDateOfEnquiry = ref.watch(
      bookingLeadRequestProvider.select((state) => state?.dob),
    );

    return SalesdocketTimePickerSpinnerPopUp(
      label: LocaleKeys.dateOfBirth.tr(),
      prefix: Icon(
        Icons.cake_outlined,
        color: appColors.textDisabled,
        size: 4.5.w,
      ),
      mode: CupertinoDatePickerMode.date,
      maxTime: DateTimeConstants.currentMaxDateTime,
      initTime:
          selectedDateOfEnquiry == null
              ? null
              : DateTime.parse(selectedDateOfEnquiry),
      onChange: (newDate) {
        ref
            .read(bookingLeadRequestProvider.notifier)
            .update(
              (state) => state = state?.copyWith(dob: newDate.formatDateTime()),
            );
      },
    );
  }
}
