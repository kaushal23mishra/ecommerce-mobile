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

class DatesWidget extends SalesdocketConsumerWidget {
  const DatesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delivery = ref.watch(selectedDeliveryProvider);
    final deliveryDate = delivery?.deliveryDate;
    final selectedDateTime =
        deliveryDate == null ? null : DateTime.parse(deliveryDate);
    final error = ref
        .watch(deliveryFormErrorsProvider)
        .get(LeadFormFields.dateOfDelivery);

    return SalesdocketTimePickerSpinnerPopUp(
      label: LocaleKeys.lblDateOfDelivery.tr(),
      maxTime: DateTimeConstants.currentMaxDateTime,
      minTime: DateTime.now().subtract(const Duration(days: 15)),
      mode: CupertinoDatePickerMode.date,
      initTime: selectedDateTime,
      enable: true,
      onChange: (newDate) {
        ref
            .read(selectedDeliveryProvider.notifier)
            .update(
              (select) =>
                  select = select?.copyWith(
                    deliveryDate: newDate.formatDateTime(),
                  ),
            );
        ref
            .read(deliveryFormErrorsProvider.notifier)
            .remove(LeadFormFields.dateOfDelivery);
      },
      errorText: error?.message,
    );
  }
}
