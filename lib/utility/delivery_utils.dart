import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/interested_in_exchange_state.dart';
import 'package:salesdocket_mobile/common/constants/receipt.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/receipts_extensions.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

class DeliveryUtils with UiComponentWidget {
  @override
  bool get isMounted => true;

  static int calculatePendingAmount({
    List<Receipt> receipts = const [],
    ExchangeHouseRequest? exchangeHouse,
    Quotation? quotation,
    Booking? booking,
  }) {
    final totalDealClosure =
        (quotation?.totalCost ?? 0) - (quotation?.totalDiscount ?? 0);
    final bookingAmount =
        receipts.filteredReceipts(type: ReceiptType.booking).amount;
    final deliveryAmount =
        receipts.filteredReceipts(type: ReceiptType.delivery).amount;
    final preDeliveryAmount =
        receipts.filteredReceipts(type: ReceiptType.preDelivery).amount;
    final exchangeAmount =
        (exchangeHouse?.exchangeType == ExchangeType.inHouse.value
            ? exchangeHouse?.purchasePrice
            : exchangeHouse?.approxValue) ??
        0;
    final financeAmount = booking?.disbursalAmount ?? 0;
    final upfrontNotGiven = quotation?.upfrontNotGiven ?? 0;

    return totalDealClosure +
        upfrontNotGiven -
        (financeAmount +
            bookingAmount +
            deliveryAmount +
            exchangeAmount +
            preDeliveryAmount);
  }
}
