import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_searchable_dropdown_widget.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketExchangeCarWidget extends SalesdocketConsumerStatefulWidget {
  final FirstTimeBuyer? exchangeCar;
  final Map<LeadFormFields, FormFieldError?> errors;
  final Function(LeadFormFields, dynamic, dynamic)? onChanged;
  final Map<LeadFormFields, String?> titles;
  final bool? isExchangeStatus;

  const SalesdocketExchangeCarWidget({
    super.key,
    this.exchangeCar,
    this.isExchangeStatus = true,
    this.errors = const {},
    this.titles = const {},
    this.onChanged,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalesdocketExchangeCarState();
}

class _SalesdocketExchangeCarState
    extends SalesdocketConsumerState<SalesdocketExchangeCarWidget>
    with ProductEvents {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBrands();
      getBrandModels(
        req: GetProductsRequest(brand: widget.exchangeCar?.oldVehicleId),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4.w,
      children: [
        Expanded(child: _brandsWidget(context)),
        Expanded(child: _modelsWidget(context)),
      ],
    );
  }

  Widget _brandsWidget(BuildContext context) {
    final itemList = ref.watch(brandsProvider);
    final selected = itemList.firstWhereOrNull(
      (item) => item.brandId == widget.exchangeCar?.oldVehicleId,
    );

    return IgnorePointer(
      ignoring: !widget.isExchangeStatus!,
      child: SalesdocketSearchableDropdownWidget<Product>(
        label: widget.titles[LeadFormFields.selectBrand] ??
            LocaleKeys.selectBrand.tr(),
        isRequired: false,
        selectedItem: selected,
        items: itemList,
        itemAsString: (item) => item.brandName ?? '',
        compareFn: (a, b) => a.brandId == b.brandId,
        errorText: widget.errors[LeadFormFields.selectBrand]?.message,
        onChanged: (selected) {
          if (selected?.brandId != null && widget.onChanged != null) {
            widget.onChanged!(
              LeadFormFields.selectBrand,
              selected!.brandId,
              selected.brandName,
            );
            getBrandModels(req: GetProductsRequest(brand: selected.brandId));
          }
        },
      ),
    );
  }

  Widget _modelsWidget(BuildContext context) {
    final itemList = ref.watch(brandModelsProvider).toSet().toList();
    final selected = itemList.firstWhereOrNull(
      (item) => item.productId == widget.exchangeCar?.oldVehicleVariantId,
    );

    return IgnorePointer(
      ignoring: !widget.isExchangeStatus!,
      child: SalesdocketSearchableDropdownWidget<Product>(
        label: widget.titles[LeadFormFields.selectBrandModel] ??
            LocaleKeys.selectModel.tr(),
        isRequired: false,
        selectedItem: selected,
        items: widget.exchangeCar?.oldVehicleId == null ? [] : itemList,
        itemAsString: (item) => item.productName ?? '',
        compareFn: (a, b) => a.productId == b.productId,
        errorText: widget.errors[LeadFormFields.selectBrandModel]?.message,
        onChanged: (selected) {
          if (selected?.productId != null && widget.onChanged != null) {
            widget.onChanged!(
              LeadFormFields.selectBrandModel,
              selected!.productId,
              selected.productName,
            );
          }
        },
      ),
    );
  }

  @override
  void onBrandsFetched(List<Product> list) {
    ref.read(brandsProvider.notifier).update((state) => state = list);
  }

  @override
  void onBrandModelsFetched(List<Product> list) {
    ref.read(brandModelsProvider.notifier).update((state) => state = list);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
