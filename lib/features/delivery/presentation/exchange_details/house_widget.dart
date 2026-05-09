import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/interested_in_exchange_state.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_exchange_type_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class HouseWidget extends SalesdocketConsumerWidget {
  const HouseWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exchangeHouse = ref.watch(selectedExchangeHouseProvider);
    final errors = <LeadFormFields, FormFieldError?>{};
    for (var field in _formFields) {
      errors[field] = ref.watch(deliveryFormErrorsProvider).get(field);
    }

    return SalesdocketExchangeTypeWidget(
      exchangeHouse: exchangeHouse,
      onChanged: (field, key, value) => _onValueChanged(field, key, value, ref),
      errors: errors,
    );
  }

  void _onValueChanged(
    LeadFormFields field,
    dynamic key,
    dynamic value,
    WidgetRef ref,
  ) {
    ref.read(deliveryFormErrorsProvider.notifier).remove(field);
    switch (field) {
      case LeadFormFields.exchangeType:
        ref
            .read(selectedExchangeHouseProvider.notifier)
            .update(
              (toUpdate) => toUpdate = ExchangeHouseRequest(exchangeType: key),
            );
        // Reset insurance validity and tyre replacement when switching to In-House
        if (key == ExchangeType.inHouse.value) {
          ref.read(selectedExchangeProductProvider.notifier).update(
                (state) => state?.copyWith(
                  insuranceValidity: null,
                  tyreReplacement: null,
                ),
              );
          ref.read(editTyreReplacementProvider.notifier).state = false;
        }
        break;
      case LeadFormFields.exchangeReason:
        ref
            .read(selectedExchangeHouseProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    reason: key,
                    otherReason: null,
                    approxValue: null,
                  ),
            );
        break;
      case LeadFormFields.exchangeOtherReason:
        ref
            .read(selectedExchangeHouseProvider.notifier)
            .update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(otherReason: key),
            );
        break;
      case LeadFormFields.exchangeApproxValue:
        ref
            .read(selectedExchangeHouseProvider.notifier)
            .update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(approxValue: key),
            );
        break;
      case LeadFormFields.exchangePurchasePrice:
        ref
            .read(selectedExchangeHouseProvider.notifier)
            .update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(purchasePrice: key),
            );
        break;
      case LeadFormFields.exchangePurchasePriceAdjust:
        ref
            .read(selectedExchangeHouseProvider.notifier)
            .update((toUpdate) => toUpdate = toUpdate?.copyWith(adjust: key));
        break;
      default:
        break;
    }
  }

  get _formFields => [
    LeadFormFields.exchangeType,
    LeadFormFields.exchangeReason,
    LeadFormFields.exchangeApproxValue,
    LeadFormFields.exchangeOtherReason,
    LeadFormFields.exchangePurchasePrice,
  ];
}
