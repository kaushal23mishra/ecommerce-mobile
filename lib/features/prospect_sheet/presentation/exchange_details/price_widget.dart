import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_exchange_car_price_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../profile/view_model/profile_view_model.dart';

class PriceWidget extends SalesdocketConsumerWidget {
  const PriceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exchangeCar = ref.watch(selectedExchangeProductProvider);
    final errors = <LeadFormFields, FormFieldError?>{};
    final user = ref.watch(profileProvider);
    final lead = ref.watch(prospectLeadRequestProvider);
    for (var field in _formFields) {
      errors[field] = ref.watch(prospectFormErrorsProvider).get(field);
    }

    return SalesdocketExchangeCarPriceWidget(
      exchangeCar: exchangeCar,
      onChanged: (field, key, value) => _onValueChanged(field, key, value, ref),
      errors: errors,
      isInEditMode: true,
    );
  }

  void _onValueChanged(
    LeadFormFields field,
    dynamic key,
    dynamic value,
    WidgetRef ref,
  ) {
    ref.read(prospectFormErrorsProvider.notifier).remove(field);
    switch (field) {
      case LeadFormFields.expectedPrice:
        ref
            .read(selectedExchangeProductProvider.notifier)
            .update((state) => state = state?.copyWith(expectedPrice: key));
        break;
      case LeadFormFields.quotedPrice:
        ref
            .read(selectedExchangeProductProvider.notifier)
            .update((state) => state = state?.copyWith(quotedPrice: key));
        break;
      default:
        break;
    }
  }

  get _formFields => [LeadFormFields.expectedPrice, LeadFormFields.quotedPrice];
}
