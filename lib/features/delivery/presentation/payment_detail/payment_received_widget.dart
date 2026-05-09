import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/events/receipt_events.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_image_container.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/payment_detail/booking_amount_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/payment_detail/delivery_amount_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/payment_detail/exchange_amount_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/payment_detail/finance_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/payment_detail/pre_delivery_amount_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/delivery_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class PaymentReceivedWidget extends SalesdocketConsumerStatefulWidget {
  const PaymentReceivedWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalesdocketPaymentReceivedState();
}

class _SalesdocketPaymentReceivedState
    extends SalesdocketConsumerState<PaymentReceivedWidget>
    with ReceiptEvents {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lead = ref.read(deliveryLeadRequestProvider);
      fetchReceipts(leadId: lead?.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lead = ref.read(deliveryLeadRequestProvider);
    final receipts = ref.watch(deliveryReceiptsProvider);
    final exchangeHouse = ref.watch(selectedExchangeHouseProvider);
    final quotation = ref.watch(quotationProvider);
    final booking = ref.watch(selectedBookingProvider);
    final delivery = ref.watch(selectedDeliveryProvider);
    final canEdit = ref.watch(canEditDeliveryProvider);

    final pendingAmount = DeliveryUtils.calculatePendingAmount(
      receipts: receipts,
      exchangeHouse:
          (exchangeHouse?.isExchanged ?? false) ? exchangeHouse : null,
      quotation: quotation,
      booking: (lead?.isFinance ?? false) ? booking : null,
    );

    return Column(
      children: [
        Text(
          LocaleKeys.paymentReceived.tr().toUpperCase(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        verticalSpacing(2.h),
        const BookingAmountWidget(),
        verticalSpacing(2.h),
        const PreDeliveryAmountWidget(),
        if (exchangeHouse?.isExchanged ?? false) ...[
          verticalSpacing(2.h),
          const ExchangeAmountWidget(),
        ],
        verticalSpacing(2.h),
        const DeliveryAmountWidget(),
        verticalSpacing(2.h),
        if (lead?.isFinance ?? false) ...[
          const FinanceWidget(),
          verticalSpacing(2.h),

        ],
        Text(
          LocaleKeys.pendingAmount.tr().toUpperCase(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        verticalSpacing(1.h),
        Text(
          pendingAmount.abs().formatIndianCommas,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: pendingAmount > 0 ? appColors.redDark : appColors.success,
          ),
        ),
      ],
    );
  }

  @override
  void onReceiptsFetched(List<Receipt> list) {
    ref.read(deliveryReceiptsProvider.notifier).update((state) => state = list);
  }

  @override
  WidgetRef get eventRef => ref;
}
