import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/interested_in_exchange_state.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ExchangeAmountWidget extends SalesdocketConsumerWidget {
  const ExchangeAmountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: 3.w,
      children: [
        Container(
          constraints: BoxConstraints(minWidth: 17.w),
          child: Text(
            LocaleKeys.lblExchange.tr(),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: appColors.textDisabled),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
            decoration: BoxDecoration(
              color: appColors.secondary,
              borderRadius: BorderRadius.circular(1.w),
              border: Border.all(color: appColors.disabled, width: 0.1.w),
            ),
            child: _exchangeTypeWidget(context, ref),
          ),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _exchangeTypeWidget(BuildContext context, WidgetRef ref) {
    final exchangeHouse = ref.watch(selectedExchangeHouseProvider);
    if (exchangeHouse?.exchangeType == ExchangeType.inHouse.value) {
      return _inHouseWidget(context, ref);
    }
    if (exchangeHouse?.exchangeType == ExchangeType.outHouse.value) {
      return _outHouseWidget(context, ref);
    }

    return const SizedBox.shrink();
  }

  Widget _inHouseWidget(BuildContext context, WidgetRef ref) {
    final exchangeHouse = ref.watch(selectedExchangeHouseProvider);

    return Row(
      spacing: 4.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            "${exchangeHouse?.exchangeType ?? ""}${exchangeHouse?.adjust ?? false ? " - ${LocaleKeys.adjust.tr()}" : ""}",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Text(
          exchangeHouse?.purchasePrice?.formatIndianCommas ?? "",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _outHouseWidget(BuildContext context, WidgetRef ref) {
    final exchangeHouse = ref.watch(selectedExchangeHouseProvider);
    final reason = exchangeHouse?.reason ?? "";
    final otherReason = exchangeHouse?.otherReason ?? "";

    return Row(
      spacing: 4.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            "$reason${otherReason.isNotEmpty ? " - $otherReason" : ""}",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Text(
          reason == ExchangeOuthouseReason.betterValueOutside.value
              ? exchangeHouse?.approxValue?.formatIndianCommas ?? ""
              : "",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
