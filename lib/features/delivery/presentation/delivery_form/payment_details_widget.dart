import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/interested_in_exchange_state.dart';
import 'package:salesdocket_mobile/common/constants/receipt.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/receipts_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/old_car_payment_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_credit_given_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_details_card_widget.dart';
import 'package:salesdocket_mobile/features/delivery/presentation/delivery_form/amount_to_be_paid_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class PaymentDetailsWidget extends SalesdocketConsumerStatefulWidget {
  const PaymentDetailsWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState
    extends SalesdocketConsumerState<PaymentDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.paymentDetails.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        verticalSpacing(1.h),
        Container(
          padding: EdgeInsets.only(
            top: 2.h,
            bottom: 2.h,
            left: 3.w,
            right: 3.w,
          ),
          decoration: BoxDecoration(
            color: appColors.primaryLight,
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(color: appColors.primary, width: 0.3.w),
          ),
          child: Column(
            children: [
              _totalDealClosureWidget,
              _amountToBePaidWidget,
              _receiptAmountsWidget,
              _exchangeWidget,
              _financeWidget,
              _creditGivenWidget,
              _oldCarPaymentWidget,
              verticalSpacing(1.h),
              _finalBalanceWidget,
            ],
          ),
        ),
      ],
    );
  }

  Widget get _totalDealClosureWidget {
    final quotation = ref.watch(quotationProvider);
    final totalCost = quotation?.totalCost ?? 0;
    final totalDiscount = quotation?.totalDiscount ?? 0;

    return _detailsWidget(
      title: LocaleKeys.totalDealClosureAmount.tr(),
      subtitle: (totalCost - totalDiscount).formatIndianCommas,
      subtitleStyle: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(color: appColors.primary),
    );
  }

  Widget get _amountToBePaidWidget {
    final quotation = ref.watch(quotationProvider);
    final totalCost = quotation?.totalCost ?? 0;
    final totalDiscount = quotation?.totalDiscount ?? 0;
    final upfrontNotGiven = quotation?.upfrontNotGiven ?? 0;

    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: _detailsWidget(
        title: LocaleKeys.amountToBePaid.tr(),
        subtitle:
            (totalCost - totalDiscount + upfrontNotGiven).formatIndianCommas,
        subtitleStyle: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(color: appColors.primary),
        onInfoIconClicked: () {
          _showAmountToBePaidBottomSheet();
        },
      ),
    );
  }

  Widget get _finalBalanceWidget {
    final quotation = ref.watch(quotationProvider);
    final totalCost = quotation?.totalCost ?? 0;
    final totalDiscount = quotation?.totalDiscount ?? 0;
    final receiptsAmount = ref.watch(deliveryReceiptsProvider).amount;
    final creditGivenAmount =
        ref.watch(creditGivenProvider)?.amountPending ?? 0;
    final financeAmount =
        ref.watch(deliveryLeadRequestProvider)?.booking?.disbursalAmount ?? 0;
    final exchangeHouse = ref.watch(selectedExchangeHouseProvider);
    final exchangeAmount =
        exchangeHouse?.isExchanged ?? false
            ? (exchangeHouse?.exchangeType == ExchangeType.inHouse.value
                    ? exchangeHouse?.purchasePrice
                    : exchangeHouse?.approxValue) ??
                0
            : 0;
    final upfrontNotGiven = quotation?.upfrontNotGiven ?? 0;

    return _detailsWidget(
      title: LocaleKeys.finalBalance.tr(),
      subtitle:
          (totalCost +
                  upfrontNotGiven -
                  totalDiscount -
                  receiptsAmount -
                  creditGivenAmount -
                  financeAmount -
                  exchangeAmount)
              .formatIndianCommas,
      subtitleStyle: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(color: appColors.primary),
    );
  }

  Widget get _receiptAmountsWidget {
    final receipts = ref.watch(deliveryReceiptsProvider);
    final preDeliveryReceipts = receipts.filteredReceipts(
      type: ReceiptType.preDelivery,
    );
    final deliveryReceipts = receipts.filteredReceipts(
      type: ReceiptType.delivery,
    );
    final bookingReceipts = receipts.filteredReceipts(
      type: ReceiptType.booking,
    );

    return Column(
      children: [
        if (preDeliveryReceipts.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: _detailsWidget(
              title:
                  "${LocaleKeys.receiptAmount.tr()} (${ReceiptType.preDelivery.value})",
              subtitle: preDeliveryReceipts.amount.formatIndianCommas,
              onInfoIconClicked: () {
                _moveToReceiptListScreen(type: ReceiptType.preDelivery);
              },
            ),
          ),
        if (bookingReceipts.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: _detailsWidget(
              title:
                  "${LocaleKeys.receiptAmount.tr()} (${ReceiptType.booking.value})",
              subtitle: bookingReceipts.amount.formatIndianCommas,
              onInfoIconClicked: () {
                _moveToReceiptListScreen(type: ReceiptType.booking);
              },
            ),
          ),
        if (deliveryReceipts.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: _detailsWidget(
              title:
                  "${LocaleKeys.receiptAmount.tr()} (${ReceiptType.delivery.value})",
              subtitle: deliveryReceipts.amount.formatIndianCommas,
              onInfoIconClicked: () {
                _moveToReceiptListScreen(type: ReceiptType.delivery);
              },
            ),
          ),
      ],
    );
  }

  Widget get _exchangeWidget {
    final exchangeHouse = ref.watch(selectedExchangeHouseProvider);
    final exchangeAmount =
        exchangeHouse?.isExchanged ?? false
            ? (exchangeHouse?.exchangeType == ExchangeType.inHouse.value
                    ? exchangeHouse?.purchasePrice
                    : exchangeHouse?.approxValue) ??
                0
            : 0;

    if (exchangeAmount == 0) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: _detailsWidget(
        title: LocaleKeys.lblExchange.tr(),
        subtitle: exchangeAmount.formatIndianCommas,
      ),
    );
  }

  Widget get _financeWidget {
    final booking = ref.watch(deliveryLeadRequestProvider)?.booking;
    final financeAmount = booking?.disbursalAmount ?? 0;
    if (financeAmount == 0) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: _detailsWidget(
        title: LocaleKeys.lblFinance.tr(),
        subtitle: financeAmount.formatIndianCommas,
      ),
    );
  }

  Widget get _creditGivenWidget {
    final creditGiven = ref.watch(creditGivenProvider);
    if ((creditGiven?.amountPending ?? 0) == 0) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: _detailsWidget(
        title: LocaleKeys.creditGivenToCustomer.tr(),
        subtitle: (creditGiven?.amountPending ?? 0).formatIndianCommas,
        onInfoIconClicked: () {
          _showCreditGivenBottomSheet();
        },
      ),
    );
  }

  Widget get _oldCarPaymentWidget {
    final oldCarPayment = ref.watch(oldCarPaymentProvider);
    if ((oldCarPayment?.amountPending ?? 0) == 0) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: _detailsWidget(
        title: LocaleKeys.oldCarPaymentPendingFromAgent.tr(),
        subtitle: (oldCarPayment?.amountPending ?? 0).formatIndianCommas,
        onInfoIconClicked: () {
          _showOldCarPaymentBottomSheet();
        },
      ),
    );
  }

  Widget _detailsWidget({
    String title = "",
    String subtitle = "",
    Function? onInfoIconClicked,
    TextStyle? subtitleStyle,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: appColors.textDisabled,
              fontSize: 15.sp,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            subtitle,
            style:
                subtitleStyle ??
                Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: appColors.primary),
            textAlign: TextAlign.end,
          ),
        ),
        onInfoIconClicked == null
            ? SizedBox(width: 8.w)
            : GestureDetector(
              onTap: () {
                onInfoIconClicked();
              },
              child: Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: SizedBox(
                  width: 6.w,
                  child: Icon(Icons.info, color: appColors.primary, size: 6.w),
                ),
              ),
            ),
      ],
    );
  }

  void _moveToReceiptListScreen({required ReceiptType type}) {
    final lead = ref.read(deliveryLeadRequestProvider);
    ref.read(canEditReceiptProvider.notifier).update((state) => state = false);
    ref.read(receiptLeadProvider.notifier).update((state) => state = lead);
    ref.read(receiptSourceProvider.notifier).update((state) => state = type);
    context.router.push(const ReceiptListRoute());
  }

  void _showAmountToBePaidBottomSheet() {
    showSalesdocketBottomSheet(
      context: context,
      builder: (context) {
        final quotation = ref.watch(quotationProvider);
        return SalesdocketBottomSheet(
          title: "",
          padding: EdgeInsets.zero,
          widget: Padding(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h),
            child: AmountToBePaidWidget(quotation: quotation),
          ),
        );
      },
    );
  }

  void _showCreditGivenBottomSheet() {
    showSalesdocketBottomSheet(
      context: context,
      builder: (context) {
        final creditGiven = ref.watch(creditGivenProvider);
        final items = [
          MenuItem(
            title: '${LocaleKeys.amountPending.tr()} : ',
            subtitle: (creditGiven?.amountPending ?? 0).formatIndianCommas,
          ),
          MenuItem(
            title: '${LocaleKeys.permittedBy.tr()} : ',
            subtitle: creditGiven?.permittedBy,
          ),
          MenuItem(
            title: '${LocaleKeys.expectedDateOfPayment.tr()} : ',
            subtitle: creditGiven?.expectedDateOfPayment?.formatDateTime(inputFormat: "yyyy-MM-dd"),
          ),
        ].filteredNonEmptyItems;

        return SalesdocketBottomSheet(
          title: LocaleKeys.creditGivenToCustomer.tr(),
          padding: EdgeInsets.zero,
          widget: Padding(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h),
            child: SalesdocketDetailsCardWidget(items: items),
          ),
        );
      },
    );
  }
  void _showOldCarPaymentBottomSheet() {
    showSalesdocketBottomSheet(
      context: context,
      builder: (context) {
        final oldCarPayment = ref.watch(oldCarPaymentProvider);
        final items = [
          MenuItem(
            title: '${LocaleKeys.amountPending.tr()} : ',
            subtitle: (oldCarPayment?.amountPending ?? 0).formatIndianCommas,
          ),
          MenuItem(
            title: '${LocaleKeys.agentName.tr()} : ',
            subtitle: oldCarPayment?.agentName,
          ),
          MenuItem(
            title: '${LocaleKeys.agentNumber.tr()} : ',
            subtitle: oldCarPayment?.agentNumber,
          ),
          MenuItem(
            title: '${LocaleKeys.expectedDateOfPayment.tr()} : ',
            subtitle: oldCarPayment?.expectedDateOfPayment?.formatDateTime(inputFormat: "yyyy-MM-dd"),
          ),
        ].filteredNonEmptyItems;

        return SalesdocketBottomSheet(
          title: LocaleKeys.oldCarPaymentPendingFromAgent.tr(),
          padding: EdgeInsets.zero,
          widget: Padding(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h),
            child: SalesdocketDetailsCardWidget(items: items),
          ),
        );
      },
    );
  }
}
