import 'package:salesdocket_mobile/common/constants/constant.dart';

class ReceiptType extends Constant<String> {
  const ReceiptType(super.value);

  static const booking = ReceiptType('Booking');
  static const delivery = ReceiptType('Delivery');
  static const preDelivery = ReceiptType('Pre-Delivery');
  static const postDelivery = ReceiptType('Post Delivery');
  static const all = ReceiptType('All');
}

class ReceiptPaymentType extends Constant<String> {
  const ReceiptPaymentType(super.value);

  static const oldCarPaymentReceived = ReceiptPaymentType(
    'Old Car Payment Received',
  );
  static const customerCreditReceived = ReceiptPaymentType(
    'Customer Credit Received',
  );
}

class ReceiptReasonType extends Constant<String> {
  const ReceiptReasonType(super.value);

  static const creditGivenToCustomer = ReceiptReasonType(
    'Credit given to Customer',
  );
  static const oldCarPaymentPendingFromAgent = ReceiptReasonType(
    'Old Car Payment Pending from Agent',
  );

}

class ReceiptPurchaseMode extends Constant<String> {
  const ReceiptPurchaseMode(super.value);

  static const cash = ReceiptPurchaseMode('Cash');
  static const cheque = ReceiptPurchaseMode('Cheque');
  static const bankTransfer = ReceiptPurchaseMode('Bank Transfer');
  static const creditDebitCard = ReceiptPurchaseMode('Credit/Debit Card');
}

List<ReceiptPurchaseMode> get receiptPurchaseModeList => [
  ReceiptPurchaseMode.cash,
  ReceiptPurchaseMode.cheque,
  ReceiptPurchaseMode.bankTransfer,
  ReceiptPurchaseMode.creditDebitCard,
];
