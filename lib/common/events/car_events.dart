import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

mixin CarEvents on UiComponentWidget {
  Future fetchLeadModels() async {
    const request = GetProductsRequest(
      returnType: 'product',
      currentOrganizationOnly: 'yes',
    );

    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .getProductsName(request: request);
    if (!isMounted) return;
    result.when(
      success: (data) {
        final products = data?.data ?? [];
        if (products.isNotEmpty) {
          eventRef
              .read(modelsProvider.notifier)
              .update((state) => state = products);
        }
      },
      failure: (error) {
        showSnackBar(
          error.message ?? LocaleKeys.defaultErrorMessage,
          type: SnackBarType.error,
        );
      },
    );
  }

  Future fetchEngineTypes({int? modelId}) async {
    if (modelId == null) return;

    final request = GetProductsRequest(
      currentOrganizationOnly: 'yes',
      product: modelId,
      returnType: 'engine_type',
    );

    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .getProductsName(request: request);
    if (!isMounted) return;
    result.when(
      success: (data) {
        final products = data?.data ?? [];
        if (products.isNotEmpty) {
          eventRef
              .read(engineTypesProvider.notifier)
              .update((state) => state = products);
        }
      },
      failure: (error) {
        showSnackBar(
          error.message ?? LocaleKeys.defaultErrorMessage,
          type: SnackBarType.error,
        );
      },
    );
  }

  Future fetchVariants({int? modelId, String? engineType}) async {
    if (modelId == null || engineType == null) return;

    final request = GetProductsRequest(
      currentOrganizationOnly: 'yes',
      engineType: engineType,
      product: modelId,
      returnType: 'variant',
    );

    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .getProductsName(request: request);
    if (!isMounted) return;
    result.when(
      success: (data) {
        final products = data?.data ?? [];
        if (products.isNotEmpty) {
          eventRef
              .read(variantsProvider.notifier)
              .update((state) => state = products);
        }
      },
      failure: (error) {
        showSnackBar(
          error.message ?? LocaleKeys.defaultErrorMessage,
          type: SnackBarType.error,
        );
      },
    );
  }

  Future fetchProduct({int? variantId}) async {
    if (variantId == null) return;

    final result = await eventRef
        .read(productsViewModelProvider.notifier)
        .getProduct(variantId);
    if (!isMounted) return;
    result.when(
      success: (data) {
        eventRef
            .read(productProvider.notifier)
            .update((state) => state = data?.data);
      },
      failure: (error) {
        showSnackBar(
          error.message ?? LocaleKeys.defaultErrorMessage,
          type: SnackBarType.error,
        );
      },
    );
  }

  void fetchCarData(InterestedVariant? selectedCar) {
    fetchEngineTypes(modelId: selectedCar?.product?.id);
    fetchVariants(
      modelId: selectedCar?.product?.id,
      engineType: selectedCar?.engineType,
    );
    fetchProduct(variantId: selectedCar?.id);
  }

  void handleVariantRemoved(
    dynamic variant,
    StateProvider<List<InterestedVariant>> carsProvider,
    StateProvider<InterestedVariant?> carProvider,
    StateProvider<InterestedColor?> colorProvider,
  ) {
    final prevVariants = eventRef.read(carsProvider);
    final updatedVariants = prevVariants.onVariantRemoved(variant);
    final updatedPrimaryVariant = updatedVariants.firstOrNull;

    eventRef
        .read(carsProvider.notifier)
        .update((state) => state = updatedVariants);

    if (updatedPrimaryVariant?.id != variant.id) {
      eventRef
          .read(carProvider.notifier)
          .update(
            (state) =>
                state = updatedPrimaryVariant ?? const InterestedVariant(),
          );
      fetchCarData(updatedPrimaryVariant);

      final selectedColor = eventRef.read(colorProvider);
      if (updatedPrimaryVariant == null ||
          (selectedColor != null &&
              selectedColor.pivot?.variantId != updatedPrimaryVariant.id)) {
        eventRef.read(colorProvider.notifier).update((state) => null);
        eventRef.invalidate(productProvider);
      }
    }

    final selectedColor = eventRef.read(colorProvider);
    if (variant.id == selectedColor?.pivot?.variantId) {
      eventRef.read(colorProvider.notifier).update((state) => null);
      eventRef.invalidate(productProvider);
    }
  }

  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {}

  WidgetRef get eventRef;
}
