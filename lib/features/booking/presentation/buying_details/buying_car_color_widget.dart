import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_select_car_color_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
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
        .watch(bookingFormErrorsProvider)
        .get(LeadFormFields.selectCarColor);

    return SalesdocketSelectCarColorWidget(
      selectedVariantId: selectedCar?.id,
      organisationId: actor?.organizationId,
      selectedColorId: selectedColor?.id,
      isRequired: true,
      error: error,
      onColorSelected: (selected) {
        // Create a new InterestedColor with proper pivot relationship
        final newColor = InterestedColor(
          id: selected,
          pivot: Pivot(variantId: selectedCar?.id),
          // Include other necessary properties if they exist
        );

        ref.read(selectedCarColorProvider.notifier).update((state) => newColor);

        ref
            .read(bookingFormErrorsProvider.notifier)
            .remove(LeadFormFields.selectCarColor);
      },
    );
  }
}
