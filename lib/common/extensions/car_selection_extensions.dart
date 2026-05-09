import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';

void applySelectCarFieldChange(
  LeadFormFields field,
  dynamic key,
  dynamic value,
  WidgetRef ref,
  StateProvider<InterestedVariant?> carProvider,
  StateProvider<List<InterestedVariant>> carsProvider,
  Future Function({int? variantId}) fetchProduct,
) {
  switch (field) {
    case LeadFormFields.selectModel:
      ref
          .read(carProvider.notifier)
          .update(
            (state) =>
                state = state?.copyWith(
                  productId: key,
                  product: LeadProduct(id: key, name: value),
                  id: null,
                  engineType: null,
                ),
          );
      break;
    case LeadFormFields.selectEngineType:
      ref
          .read(carProvider.notifier)
          .update(
            (state) => state = state?.copyWith(id: null, engineType: key),
          );
      break;
    case LeadFormFields.selectVariant:
      final variant = ref.read(carProvider)?.copyWith(id: key, variant: value);
      ref
          .read(carProvider.notifier)
          .update(
            (state) => state = state?.copyWith(id: key, variant: value),
          );
      ref
          .read(carsProvider.notifier)
          .update((state) => state = state.updatedVariants(variant));
      fetchProduct(variantId: variant?.id);
      break;
    default:
      break;
  }
}
