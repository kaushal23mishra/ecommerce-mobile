import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/input_formatters.dart';
import 'package:salesdocket_mobile/common/constants/offer_editfield.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/accessories/view_model/accessories_view_model.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/features/schemes/view_model/schemes_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../generated/assets.gen.dart';

class SalesdocketOfferSummaryEditWidget
    extends SalesdocketConsumerStatefulWidget {
  final Lead? lead;
  final Quotation? quotation;

  const SalesdocketOfferSummaryEditWidget({
    super.key,
    this.quotation,
    this.lead,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalesdocketOfferSummaryEditState();
}

class _SalesdocketOfferSummaryEditState
    extends SalesdocketConsumerState<SalesdocketOfferSummaryEditWidget>
    with ProductEvents {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateProviders();
      _fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_editFieldsWidget, _actionWidgets, verticalSpacing(1.5.h)],
    );
  }

  Widget get _editFieldsWidget {
    final prices = ref.watch(newOfferPricesProvider);
    final discountControllers = ref.watch(
      offerDiscountTextFieldControllerProvider,
    );

    if (discountControllers.length != prices.length) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: prices.length,
      itemBuilder: (context, index) {
        final price = prices[index];
        final discountController = discountControllers[index];
        return OfferEditWidget(
          key: ValueKey('${price.name}_${price.priceGroup}'),
          price: price,
          discountController: discountController,
          onChanged:
              (field, value) => _onOfferFieldChanged(field, value, index),
          onRemove: () => _onRemoveItem(index, price),
        );
      },
    );
  }

  void _onRemoveItem(int index, Price price) {
    // Remove from the displayed prices list
    final prices = ref.read(newOfferPricesProvider).toList();
    if (index >= 0 && index < prices.length) {
      prices.removeAt(index);
    }

    // Also remove from the source list to keep state consistent
    if (price.priceGroup == 'scheme') {
      final selectedSchemes = ref.read(selectedSchemesProvider).toList();
      selectedSchemes.removeWhere((s) => s.id == price.scheme?.id);
      ref.read(selectedSchemesProvider.notifier).state = selectedSchemes;
    } else {
      final selectedAccessories =
          ref.read(selectedAccessoriesProvider).toList();
      selectedAccessories.removeWhere((a) => a.name == price.name);
      ref.read(selectedAccessoriesProvider.notifier).state =
          selectedAccessories;
    }

    // Update the prices provider and recreate all controllers
    ref.read(newOfferPricesProvider.notifier).state = prices;
    _addControllers(prices);
  }

  Widget get _actionWidgets {
    return Row(
      spacing: 4.w,
      children: [
        Expanded(
          child: SalesDocketButtonWidget(
            isOutlined: true,
            onPressed: () {
              _onAddAccessoriesClicked();
            },
            text: LocaleKeys.lblAddAccessories.tr(),
          ),
        ),
        Expanded(
          child: SalesDocketButtonWidget(
            isOutlined: true,
            onPressed: () {
              _onAddSchemesClicked();
            },
            text: LocaleKeys.lblAddSchemes.tr(),
          ),
        ),
      ],
    );
  }

  void _onAddAccessoriesClicked() {
    ref
        .read(getAccessoriesLeadProvider.notifier)
        .update((state) => state = widget.lead);
    context.router.push(const AccessoriesRoute()).then((_) {
      _updateNewOfferPrices();
    });
  }

  void _onAddSchemesClicked() {
    final broker = ref.read(updatedBrokerProvider);
    ref.read(schemesBrokerProvider.notifier).update((state) => state = broker);
    ref
        .read(getSchemesLeadProvider.notifier)
        .update((state) => state = widget.lead);
    ref
        .read(getSchemesRequestProvider.notifier)
        .update(
          (state) =>
              state = GetSchemesRequest(
                engineType: widget.lead?.primaryVariant?.engineType,
                colorId: widget.lead?.interestedColorId,
              ),
        );
    context.router.push(const SchemesRoute()).then((_) {
      _updateNewOfferPrices();
    });
  }

  void _updateNewOfferPrices() {
    final prices = ref.read(offerPricesProvider);
    final currentPrices = ref.read(newOfferPricesProvider);
    final quotationConfig = ref.read(quotationConfigProvider);
    final selectedSchemes = ref.read(selectedSchemesProvider);
    final selectedAccessories = ref.read(selectedAccessoriesProvider);

    final finalPrices = LeadUtils.getFinalPrices(
      prices,
      widget.quotation,
      quotationConfig,
      selectedSchemes,
      selectedAccessories,
    );

    // Preserve discount and toggle values from current prices
    final mergedPrices =
        finalPrices.map((newPrice) {
          // Find matching price in current prices by name and priceGroup
          try {
            final existingPrice = currentPrices.firstWhere(
              (p) =>
                  p.name == newPrice.name &&
                  p.priceGroup == newPrice.priceGroup,
            );

            // If found, preserve discount and toggle states
            return newPrice.copyWith(
              discount: existingPrice.discount ?? newPrice.discount,
              free: existingPrice.free ?? newPrice.free,
              foc: existingPrice.foc ?? newPrice.foc,
              ngnc: existingPrice.ngnc ?? newPrice.ngnc,
              upfront: existingPrice.upfront ?? newPrice.upfront,
            );
          } catch (e) {
            // No matching price found, continue with newPrice
          }

          return newPrice;
        }).toList();

    ref
        .read(newOfferPricesProvider.notifier)
        .update((state) => state = mergedPrices);
    _addControllers(mergedPrices);
  }

  void _addControllers(List<Price> finalPrices) {
    ref.read(offerDiscountTextFieldControllerProvider.notifier).removeAll();
    for (int index = 0; index < finalPrices.length; index++) {
      final discount = finalPrices[index].discount;
      // Format discount value with commas
      final formattedDiscount =
          discount != null && discount > 0 ? discount.formatIndianCommas : "";
      ref
          .read(offerDiscountTextFieldControllerProvider.notifier)
          .addController(
            text: formattedDiscount,
            onChanged: (value) => _onDiscountValueChanged(value, index),
          );
    }
  }

  void _onDiscountValueChanged(String newValue, int index) {
    // Defer provider update to avoid modifying during build phase
    Future.microtask(() {
      final prices = ref.read(newOfferPricesProvider).toList();

      // Bounds check to prevent RangeError
      if (index < 0 || index >= prices.length) {
        return;
      }

      final amount = prices[index].amount ?? 0;
      // Parse comma-separated value
      int? newDiscount = newValue.isEmpty ? null : newValue.parseIndianNumber();

      if (newDiscount != null && amount < newDiscount) {
        final controllers = ref.read(offerDiscountTextFieldControllerProvider);
        // Additional bounds check for controllers
        if (index >= controllers.length) {
          return;
        }
        newDiscount = prices[index].discount;
        // Format with commas when resetting
        controllers[index].text =
            newDiscount != null && newDiscount > 0
                ? newDiscount.formatIndianCommas
                : "";
      }

      prices[index] = prices[index].copyWith(discount: newDiscount);
      ref
          .read(newOfferPricesProvider.notifier)
          .update((state) => state = prices);
    });
  }

  void _onOfferFieldChanged(OfferEditfield field, dynamic value, int index) {
    final prices = ref.read(newOfferPricesProvider).toList();

    // Bounds check to prevent RangeError
    if (index < 0 || index >= prices.length) {
      return;
    }

    switch (field) {
      case OfferEditfield.foc:
        prices[index] = prices[index].copyWith(foc: value);
        break;
      case OfferEditfield.ngnc:
        prices[index] = prices[index].copyWith(ngnc: value);
        break;
      case OfferEditfield.upfront:
        prices[index] = prices[index].copyWith(upfront: value);
        break;
      case OfferEditfield.free:
        prices[index] = prices[index].copyWith(free: value);
        break;
      default:
        break;
    }

    ref.read(newOfferPricesProvider.notifier).update((state) => state = prices);
  }

  void _invalidateProviders() {
    final providers = [
      offerPricesProvider,
      newOfferPricesProvider,
      quotationConfigProvider,
    ];
    for (var provider in providers) {
      ref.invalidate(provider);
    }

    final notifiers = [offerDiscountTextFieldControllerProvider];
    for (var notifier in notifiers) {
      ref.invalidate(notifier);
    }
  }

  Future _fetchData() async {
    await getProductPricesConfigurable();
    getProductPrices(
      productId: widget.lead?.primaryVariantId,
      req: GetProductsRequest(
        engineType: widget.lead?.primaryVariant?.engineType,
        colorId: widget.lead?.interestedColorId,
      ),
    );
  }

  @override
  void onProductPriceFetched(List<Price> prices) {
    ref.read(offerPricesProvider.notifier).update((state) => state = prices);
    ref.read(newOfferPricesProvider.notifier).update((state) => state = prices);
    _updateNewOfferPrices();
  }

  @override
  void onProductPricesConfigurableFetched(QuotationConfig? data) {
    ref.read(quotationConfigProvider.notifier).update((state) => state = data);
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}

class OfferEditWidget extends SalesdocketStatelessWidget {
  final Price price;
  final TextEditingController discountController;
  final Function(OfferEditfield, dynamic) onChanged;
  final VoidCallback? onRemove;

  const OfferEditWidget({
    super.key,
    required this.price,
    required this.discountController,
    required this.onChanged,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    loggy.debug(price);
    // Initialize discount value based on Free status with comma formatting
    if (price.free == true && price.amount != null) {
      discountController.text = price.amount!.formatIndianCommas;
    } else if (price.free == false &&
        discountController.text == price.amount?.formatIndianCommas) {
      discountController.text = '0';
    }

    return Container(
      padding: EdgeInsets.only(left: 4.w, top: 4.w, right: 4.w, bottom: 1.w),
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: appColors.secondary,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: appColors.border, width: 0.3.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  price.name?.sentenceToCamelCase ?? "",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (onRemove != null)
                price.config?.cross == 1
                    ? IconButton(
                      icon: Icon(Icons.close, size: 5.w),
                      onPressed: onRemove,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    )
                    : SizedBox(),
            ],
          ),
          verticalSpacing(2.h),
          Row(
            spacing: 2.w,
            children: [
              if (price.priceGroup != 'scheme')
                Expanded(
                  child: SalesDocketInputWidget(
                    initialValue: (price.amount ?? 0).formatIndianCommas,
                    label: LocaleKeys.cost.tr(),
                    hint: LocaleKeys.cost.tr(),
                    enable: price.config?.edit == 1 ? true : false,
                    suffix:
                        price.config?.edit == 1
                            ? SalesDocketImageWidget(
                              imagePath: Assets.images.edit.path,
                              height: 2.0.h,
                              color: appColors.primary,
                            )
                            : null,
                  ),
                ),
              Expanded(
                child: SalesDocketInputWidget(
                  controller: discountController,
                  label: LocaleKeys.discount.tr(),
                  hint: LocaleKeys.discount.tr(),
                  inputType: TextInputType.number,
                  inputFormatters: InputFormatters.indianNumber,
                  textFieldColor: appColors.success,
                  enable:
                      price.priceGroup != 'scheme' && !(price.free ?? false),
                ),
              ),
            ],
          ),
          Row(
            spacing: 2.w,
            children: [
              // Show Free toggle for price (except Ex-showroom) and accessories
              if ((price.priceGroup == 'default' &&
                      price.name?.toLowerCase().replaceAll(RegExp(r'[\s-]'), '') != 'exshowroom') ||
                  price.priceGroup == 'accessories')
                Expanded(
                  child: SalesdocketSwitchWidget(
                    label: LocaleKeys.free.tr(),
                    value: price.free ?? false,
                    onChanged: (value) {
                      if (value && price.amount != null) {
                        discountController.text =
                            price.amount!.formatIndianCommas;
                      } else if (!value) {
                        discountController.text = '0';
                      }
                      onChanged(OfferEditfield.free, value);
                    },
                  ),
                ),
              // Show Upfront toggle only for scheme items
              if (price.priceGroup == 'scheme')
                Expanded(
                  child: SalesdocketSwitchWidget(
                    label: LocaleKeys.upfront.tr(),
                    value: price.upfront ?? false,
                    onChanged: (value) {
                      onChanged(OfferEditfield.upfront, value);
                    },
                  ),
                ),
            ],
          ),
          // Add spacing when no toggles are shown
          if (!((price.priceGroup == 'default' &&
                      price.name?.toLowerCase().replaceAll(RegExp(r'[\s-]'), '') != 'exshowroom') ||
                  price.priceGroup == 'accessories') &&
              price.priceGroup != 'scheme')
            verticalSpacing(2.h),
        ],
      ),
    );
  }
}
