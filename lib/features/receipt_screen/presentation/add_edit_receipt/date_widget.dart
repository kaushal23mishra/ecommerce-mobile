import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DateWidget extends SalesdocketConsumerWidget {
  const DateWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptDate = ref.watch(
      sendReceiptRequestProvider.select((state) => state?.date),
    );
    final error = ref
        .watch(receiptFormErrorsProvider)
        .get(ReceiptFormFields.receiptDate);

    return SalesdocketTimePickerSpinnerPopUp(
      label: LocaleKeys.receiptDate.tr(),
      isRequired: true,
      mode: CupertinoDatePickerMode.date,
      initTime: receiptDate == null ? null : DateTime.parse(receiptDate),
      maxTime: DateTimeConstants.currentMaxDateTime,
      onChange: (newDate) {
        loggy.debug(newDate);
        ref
            .read(sendReceiptRequestProvider.notifier)
            .update(
              (state) =>
                  state = state?.copyWith(date: newDate.formatDateTime()),
            );
        ref
            .read(receiptFormErrorsProvider.notifier)
            .remove(ReceiptFormFields.receiptDate);
      },
      errorText: error?.message,
    );
  }
}
