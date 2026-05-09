import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ChasisNumberWidget extends SalesdocketConsumerWidget {
  const ChasisNumberWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delivery = ref.watch(selectedDeliveryProvider);
    final chasisNumber = delivery?.chasisNumber;
    final error = ref
        .watch(deliveryFormErrorsProvider)
        .get(LeadFormFields.chasisNumber);

    return SalesDocketInputWidget(
      initialValue: chasisNumber,
      label: LocaleKeys.chassisNumber.tr(),
      hint: LocaleKeys.chassisNumber.tr(),
      textCapitalization: TextCapitalization.characters,
      maxLength: 17,
      onChanged: (value) {
        ref
            .read(selectedDeliveryProvider.notifier)
            .update(
              (state) => state = state?.copyWith(chasisNumber: value.trim()),
            );
        ref
            .read(deliveryFormErrorsProvider.notifier)
            .remove(LeadFormFields.chasisNumber);
      },
      errorMsg: error?.message,
    );
  }
}
