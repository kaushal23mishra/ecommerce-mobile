import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/product_events.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/features/accessories/view_model/accessories_view_model.dart';
import 'package:salesdocket_mobile/features/products/view_model/products_view_model.dart';
import 'package:salesdocket_mobile/features/schemes/presentation/brokerage_list_item.dart';
import 'package:salesdocket_mobile/features/schemes/view_model/schemes_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../features/profile/view_model/profile_view_model.dart';

class SalesdocketOfferSummaryViewWidget
    extends SalesdocketConsumerStatefulWidget {
  final Lead? lead;
  final Quotation? quotation;

  const SalesdocketOfferSummaryViewWidget({
    super.key,
    this.lead,
    this.quotation,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalesdocketOfferSummaryViewState();
}

class _SalesdocketOfferSummaryViewState
    extends SalesdocketConsumerState<SalesdocketOfferSummaryViewWidget>
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
    final quotationFields = widget.quotation?.quotationFields ?? [];

    return quotationFields.isEmpty
        ? const SizedBox.shrink()
        : Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Column(children: [_offerHeaders, _offerPrices]),
        );
  }

  Widget get _offerHeaders {
    return Row(
      children: [
        const Expanded(child: TableHeaderItem("")),
        Expanded(
          child: TableHeaderItem(LocaleKeys.cost.tr(), align: TextAlign.end),
        ),
        Expanded(
          child: TableHeaderItem(LocaleKeys.offer.tr(), align: TextAlign.end),
        ),
        Expanded(
          child: TableHeaderItem(
            LocaleKeys.payable.tr(),
            textColor: appColors.primary,
            align: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget get _offerPrices {
    final quotationFields = widget.quotation?.quotationFields ?? [];
    loggy.debug(quotationFields);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final quotation = quotationFields[index];
        final user = ref.watch(profileProvider);
        return Container(
          decoration: BoxDecoration(
            color:
                quotation.priceOrSchemeType == "scheme"
                    ? appColors.grayLight
                    : null,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: TableRowItem(
                  child: Text(
                    quotation.description?.sentenceToCamelCase ?? "N/A",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: appColors.textDisabled,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TableRowItem(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        quotation.freeFlag == 1
                            ? 'Free'
                            : (quotation.amount ?? 0).formatIndianCommas,
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.right,
                      ),
                      if (quotation.schemeType == 1)
                        Padding(
                          padding: EdgeInsets.only(top: 0.25.h),
                          child: Text(
                            "(${LocaleKeys.upfront.tr()})",
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: appColors.textDisabled),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TableRowItem(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        quotation.freeFlag == 1
                            ? 'Free'
                            : (quotation.discount ?? 0).formatIndianCommas,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color:
                              quotation.freeFlag == 1
                                  ? appColors.primary
                                  : appColors.textPrimary,
                        ),
                        textAlign: TextAlign.right,
                      ),

                      if ([
                        "scheme",
                        "default",
                        "accessories",
                      ].contains(quotation.priceOrSchemeType))
                        user?.isSalesManager == true
                            ? Padding(
                              padding: EdgeInsets.only(top: 0.25.h),
                              child: Text(
                                (quotation.dealerDiscount ?? 0)
                                    .formatIndianCommas,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(color: appColors.redDark),
                                textAlign: TextAlign.right,
                              ),
                            )
                            : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TableRowItem(
                  child: Text(
                    ["scheme"].contains(quotation.priceOrSchemeType)
                        ? "-${(quotation.amount ?? 0).formatIndianCommas}"
                        : ((quotation.amount ?? 0) - (quotation.discount ?? 0))
                            .formatIndianCommas,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder:
          (context, index) => Row(
            children: [
              const Spacer(flex: 1),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 0,
                  child: Divider(color: appColors.grayMedium),
                ),
              ),
            ],
          ),
      itemCount: quotationFields.length,
    );
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
    if (!mounted) return;
    getProductPrices(
      productId: widget.lead?.primaryVariantId,
      req: GetProductsRequest(
        engineType: widget.lead?.primaryVariant?.engineType,
        colorId: widget.lead?.interestedColorId,
      ),
    );
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

    // Preserve discount values from current prices
    final mergedPrices =
        finalPrices.map((newPrice) {
          // Find matching price in current prices by name and priceGroup
          try {
            final existingPrice = currentPrices.firstWhere(
              (p) =>
                  p.name == newPrice.name &&
                  p.priceGroup == newPrice.priceGroup,
            );

            // If found and has a discount value, preserve it
            if (existingPrice.discount != null) {
              return newPrice.copyWith(discount: existingPrice.discount);
            }
          } catch (e) {
            // No matching price found, continue with newPrice
          }

          return newPrice;
        }).toList();

    ref
        .read(newOfferPricesProvider.notifier)
        .update((state) => state = mergedPrices);
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

class OfferSummaryHeaderWidget extends SalesdocketStatelessWidget {
  final bool showTitle;
  final bool canEdit;
  final bool editSummary;
  final Function(bool)? onEditChanged;

  const OfferSummaryHeaderWidget({
    super.key,
    this.showTitle = true,
    this.editSummary = false,
    this.onEditChanged,
    this.canEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!editSummary && showTitle)
          Text(
            LocaleKeys.summary.tr(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        const Spacer(),
        if (canEdit)
          SalesdocketSwitchWidget(
            label: LocaleKeys.edit.tr(),
            value: editSummary,
            onChanged: (value) {
              if (onEditChanged != null) {
                onEditChanged!(value);
              }
            },
          ),
      ],
    );
  }
}

class OfferSummaryFooterWidget extends SalesdocketConsumerWidget {
  final Quotation? quotation;
  final bool editSummary;

  const OfferSummaryFooterWidget({
    super.key,
    this.editSummary = false,
    this.quotation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.primary,
        borderRadius: BorderRadius.circular(1.w),
      ),
      child: Column(children: [_offerTableHeaders, _offerPrices(context, ref)]),
    );
  }

  Widget get _offerTableHeaders {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: TableHeaderItem("")),
        Expanded(
          child: TableHeaderItem(
            LocaleKeys.cost.tr(),
            align: TextAlign.end,
            textColor: appColors.secondary,
          ),
        ),
        Expanded(
          child: TableHeaderItem(
            LocaleKeys.offer.tr(),
            align: TextAlign.end,
            textColor: appColors.secondary,
          ),
        ),
        Expanded(
          child: TableHeaderItem(
            LocaleKeys.finalOfferPrice.tr(),
            align: TextAlign.end,
            textColor: appColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _offerPrices(BuildContext context, WidgetRef ref) {
    int totalCost = 0;
    int totalDiscount = 0;
    int totalDealerDiscount = 0;
    if (editSummary) {
      final prices = ref.watch(newOfferPricesProvider);
      totalCost = prices.totalCost;
      totalDiscount = prices.totalDiscount;
    } else {
      totalCost = quotation?.totalCost ?? 0;
      totalDiscount = quotation?.totalDiscount ?? 0;
      totalDealerDiscount = quotation?.totalDealerDiscount ?? 0;
    }
    final user = ref.watch(profileProvider);
    return Row(
      children: [
        Expanded(
          child: TableRowItem(
            child: Text(
              LocaleKeys.total.tr(),
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: appColors.secondary),
            ),
          ),
        ),
        Expanded(
          child: TableRowItem(
            child: Text(
              totalCost.formatIndianCommas,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: appColors.secondary),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Expanded(
          child: TableRowItem(
            child: Column(
              spacing: user?.isSalesManager == true ? 1.h : 0,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  totalDiscount.formatIndianCommas,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: appColors.secondary),
                  textAlign: TextAlign.right,
                ),
                if (!editSummary)
                  user?.isSalesManager == true
                      ? Padding(
                        padding: EdgeInsets.only(top: 0.25.h),
                        child: Text(
                          totalDealerDiscount.formatIndianCommas,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(color: appColors.redLight),
                          textAlign: TextAlign.right,
                        ),
                      )
                      : SizedBox.shrink(),
              ],
            ),
          ),
        ),
        Expanded(
          child: TableRowItem(
            child: Text(
              (totalCost - totalDiscount).formatIndianCommas,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 17.sp,
                color: appColors.secondary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }
}

class TableHeaderItem extends SalesdocketStatelessWidget {
  final String title;
  final Color? textColor;
  final TextAlign? align;

  const TableHeaderItem(this.title, {super.key, this.textColor, this.align});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: textColor ?? appColors.textPrimary,
        ),
        textAlign: align ?? TextAlign.center,
      ),
    );
  }
}

class TableRowItem extends SalesdocketStatelessWidget {
  final Widget child;

  const TableRowItem({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      child: child,
    );
  }
}

class BrokerageSummaryWidget extends SalesdocketConsumerWidget {
  const BrokerageSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brokerage = ref.watch(updatedBrokerProvider);

    return brokerage?.id == null
        ? const SizedBox.shrink()
        : Container(
          decoration: BoxDecoration(
            color: appColors.secondary,
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(color: appColors.border, width: 0.3.w),
          ),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
          margin: EdgeInsets.only(top: 2.h),
          child: const BrokerageNonEditableWidget(),
        );
  }
}
