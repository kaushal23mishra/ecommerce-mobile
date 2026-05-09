import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_first_time_buyer_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class FirstTimeBuyerWidget extends SalesdocketConsumerWidget {
  const FirstTimeBuyerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstTimeBuyer = ref.watch(selectedFirstTimeBuyerProvider);
    final editExistingVehicle = ref.watch(editExistingVehicleProvider);
    final errors = <LeadFormFields, FormFieldError?>{};
    for (var field in _formFields) {
      errors[field] = ref.watch(deliveryFormErrorsProvider).get(field);
    }

    return SalesdocketFirstTimeBuyerWidget(
      errors: errors,
      firstTimeBuyer: firstTimeBuyer,
      onChanged: (field, key, value) => _onValueChanged(field, key, value, ref),
      canEditExistingVehicle: editExistingVehicle,
      onEditChanged: (value) {
        ref
            .read(editExistingVehicleProvider.notifier)
            .update((state) => state = value);
      },
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
      case LeadFormFields.firstTimeBuyerStatus:
        ref
            .read(selectedFirstTimeBuyerProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    isExistingVehicle: key,
                    oldVehicleId: null,
                    oldVehicleVariantId: null,
                    oldVehicleMakeYear: null,
                  ),
            );
        break;
      case LeadFormFields.selectBrand:
        ref
            .read(selectedFirstTimeBuyerProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    oldVehicleId: key,
                    oldVehicleName: value?.toString(),
                    oldVehicleVariantId: null,
                    oldVehicleVariantName: null,
                    oldVehicleMakeYear: null,
                  ),
            );
        break;
      case LeadFormFields.selectBrandModel:
        ref
            .read(selectedFirstTimeBuyerProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    oldVehicleVariantId: key,
                    oldVehicleVariantName: value?.toString(),
                    oldVehicleMakeYear: null,
                  ),
            );
        break;
      case LeadFormFields.selectModelYear:
        ref
            .read(selectedFirstTimeBuyerProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(oldVehicleMakeYear: key),
            );
        break;
      default:
        break;
    }
  }

  get _formFields => [
    LeadFormFields.firstTimeBuyerStatus,
    LeadFormFields.selectBrand,
    LeadFormFields.selectBrandModel,
    LeadFormFields.selectModelYear,
  ];
}
