import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/car_events.dart';
import 'package:salesdocket_mobile/common/extensions/car_selection_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_select_car_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SelectCarWidget extends SalesdocketConsumerStatefulWidget {
  const SelectCarWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectCarState();
}

class _SelectCarState extends SalesdocketConsumerState<SelectCarWidget>
    with CarEvents {
  final _carFormFields = [
    LeadFormFields.selectModel,
    LeadFormFields.selectEngineType,
    LeadFormFields.selectVariant,
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedCar = ref.watch(selectedCarProvider);
      fetchCarData(selectedCar);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final editCardDetails = ref.watch(editCarDetailsProvider);
    final selectedCar = ref.watch(selectedCarProvider);
    final selectedCars = ref.watch(selectedCarsProvider);
    final errors = <LeadFormFields, FormFieldError?>{};
    for (var field in _carFormFields) {
      errors[field] = ref.watch(bookingFormErrorsProvider).get(field);
    }

    return SalesdocketSelectCarWidget(
      onChanged: (field, key, value) => _onValueChanged(field, key, value, ref),
      onEditCarDetailsChanged: (value) {
        if (selectedCar?.hasEmptyField == true) {
          context.showSnackBar("${LocaleKeys.invalidCarDetails.tr()}!");
          return;
        }

        ref
            .read(editCarDetailsProvider.notifier)
            .update((state) => state = value);
      },
      editCarDetails: editCardDetails,
      selectedCar: selectedCar,
      selectedVariants: selectedCars,
      onVariantRemoved: (variant) => handleVariantRemoved(
        variant,
        selectedCarsProvider,
        selectedCarProvider,
        selectedCarColorProvider,
      ),
      errors: errors,
    );
  }

  void _onValueChanged(
    LeadFormFields field,
    dynamic key,
    dynamic value,
    WidgetRef ref,
  ) {
    ref.read(bookingFormErrorsProvider.notifier).remove(field);
    applySelectCarFieldChange(
      field,
      key,
      value,
      ref,
      selectedCarProvider,
      selectedCarsProvider,
      fetchProduct,
    );
  }

  @override
  WidgetRef get eventRef => ref;
}
