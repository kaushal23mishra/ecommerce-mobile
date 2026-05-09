import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_exchange_car_other_details_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../profile/view_model/profile_view_model.dart';

class OtherDetailsWidget extends SalesdocketConsumerWidget {
  const OtherDetailsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exchangeCar = ref.watch(selectedExchangeProductProvider);
    final errors = <LeadFormFields, FormFieldError?>{};
    for (var field in _formFields) {
      errors[field] = ref.watch(deliveryFormErrorsProvider).get(field);
    }
    final user = ref.watch(profileProvider);
    final lead = ref.watch(deliveryLeadRequestProvider);

    return SalesdocketExchangeCarOtherDetailsWidget(
      exchangeCar: exchangeCar,
      onChanged: (field, key, value) => _onValueChanged(field, key, value, ref),
      errors: errors,
      isInEditMode: true,
      isExchangeStatus: (!user!.isEvaluator && !lead!.isEC) || user.isEvaluator,
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
      case LeadFormFields.selectCarColor:
        ref
            .read(selectedExchangeProductProvider.notifier)
            .update((state) => state = state?.copyWith(color: key));
        break;
      case LeadFormFields.mileage:
        ref
            .read(selectedExchangeProductProvider.notifier)
            .update((state) => state = state?.copyWith(millage: key));
        break;
      case LeadFormFields.registrationNumber:
        ref
            .read(selectedExchangeProductProvider.notifier)
            .update(
              (state) => state = state?.copyWith(registrationNumber: key),
            );
        break;
      default:
        break;
    }
  }

  get _formFields => [
    LeadFormFields.selectCarColor,
    LeadFormFields.mileage,
    LeadFormFields.registrationNumber,
  ];
}
