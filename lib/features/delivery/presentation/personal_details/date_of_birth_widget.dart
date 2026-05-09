import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DateOfBirthWidget extends SalesdocketConsumerWidget {
  const DateOfBirthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDateOfEnquiry = ref.watch(
      deliveryLeadRequestProvider.select((state) => state?.dob),
    );
    final error = ref
        .watch(deliveryFormErrorsProvider)
        .get(LeadFormFields.dateOfBirth);

    return SalesdocketTimePickerSpinnerPopUp(
      label: LocaleKeys.dateOfBirth.tr(),
      isRequired: true,
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
      errorText: error?.message,
      onChange: (newDate) {
        ref
            .read(deliveryFormErrorsProvider.notifier)
            .remove(LeadFormFields.dateOfBirth);
        ref
            .read(deliveryLeadRequestProvider.notifier)
            .update(
              (state) => state = state?.copyWith(dob: newDate.formatDateTime()),
            );
      },
    );
  }
}
