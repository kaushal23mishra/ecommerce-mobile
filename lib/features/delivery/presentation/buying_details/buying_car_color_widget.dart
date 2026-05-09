import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_select_car_color_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class BuyingCarColorWidget extends SalesdocketConsumerWidget {
  const BuyingCarColorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCar = ref.watch(selectedCarProvider);
    final selectedColor = ref.watch(selectedCarColorProvider);
    final actor = ref.watch(profileProvider);
    final error = ref
        .watch(deliveryFormErrorsProvider)
        .get(LeadFormFields.selectCarColor);

    return SalesdocketSelectCarColorWidget(
      selectedVariantId: selectedCar?.id,
      organisationId: actor?.organizationId,
      selectedColorId: selectedColor?.id,
      error: error,
      onColorSelected: (selectedColorId) {
        // Create a new color object with all required properties
        final newColor = InterestedColor(
          id: selectedColorId,
          pivot: Pivot(variantId: selectedCar?.id),
        );

        // Update state with the complete color object
        ref.read(selectedCarColorProvider.notifier).update((_) => newColor);

        // Clear any existing error
        ref
            .read(deliveryFormErrorsProvider.notifier)
            .remove(LeadFormFields.selectCarColor);
      },
    );
  }
}
