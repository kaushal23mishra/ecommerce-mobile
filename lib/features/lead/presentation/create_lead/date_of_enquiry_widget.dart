import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DateOfEnquiryWidget extends SalesdocketConsumerWidget {
  const DateOfEnquiryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDateOfEnquiry = ref.watch(
      leadRequestProvider.select((lead) => lead?.dateOfEnquiry),
    );
    final error = ref
        .watch(createLeadFormErrorsProvider)
        .get(LeadFormFields.dateOfEnquiry);

    return SalesdocketTimePickerSpinnerPopUp(
      label: LocaleKeys.lblDateOfEnquiry.tr(),
      mode: CupertinoDatePickerMode.date,
      maxTime: DateTimeConstants.currentMaxDateTime,
      initTime:
          selectedDateOfEnquiry == null
              ? null
              : DateTime.tryParse(selectedDateOfEnquiry),
      errorText: error?.message,
      onChange: (newDate) {
        ref
            .read(leadRequestProvider.notifier)
            .update(
              (lead) => lead?.copyWith(dateOfEnquiry: newDate.formatDateTime()),
            );
        ref
            .read(createLeadFormErrorsProvider.notifier)
            .remove(LeadFormFields.dateOfEnquiry);
      },
    );
  }
}
