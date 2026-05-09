import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/purchase_mode.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ExchangeFinanceWidget extends SalesdocketConsumerWidget {
  const ExchangeFinanceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExchanged = ref.watch(
      leadRequestProvider.select((lead) => lead?.isExchange),
    );
    final purchaseMode = ref.watch(
      leadRequestProvider.select((lead) => lead?.purchaseMode),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.lblInterestedIn.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        verticalSpacing(0.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SalesdocketSwitchWidget(
              label: LocaleKeys.lblExchange.tr(),
              value: isExchanged == 1,
              onChanged: (value) => _onExchangeChanged(value, ref),
            ),
            SalesdocketSwitchWidget(
              label: LocaleKeys.lblFinance.tr(),
              value: purchaseMode == PurchaseMode.finance.value,
              onChanged: (value) => _onPurchaseModeChanged(value, ref),
            ),
          ],
        ),
      ],
    );
  }

  _onExchangeChanged(bool value, WidgetRef ref) {
    ref
        .read(leadRequestProvider.notifier)
        .update((lead) => lead = lead?.copyWith(isExchange: value ? 1 : 0));
  }

  _onPurchaseModeChanged(bool value, WidgetRef ref) {
    ref
        .read(leadRequestProvider.notifier)
        .update(
          (lead) =>
              lead = lead?.copyWith(
                purchaseMode:
                    value
                        ? PurchaseMode.finance.value
                        : PurchaseMode.cash.value,
              ),
        );
  }
}
