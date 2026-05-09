import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/receipt.dart';
import 'package:salesdocket_mobile/common/entity/credit_given.dart';
import 'package:salesdocket_mobile/common/entity/old_car_payment.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';

extension ReceiptExtensions on List<Receipt> {
  List<Receipt> filteredReceipts({ReceiptType type = ReceiptType.all}) {
    final filtered =
        type == ReceiptType.all
            ? toList()
            : where((receipt) => receipt.type == type.value).toList();

    filtered.sort((a, b) => (b.id ?? -1).compareTo(a.id ?? -1));
    return filtered;
  }

  int get amount {
    return map(
      (receipt) => receipt.amount ?? 0,
    ).fold(0, (value, amount) => value + amount);
  }

  List<String> get modeOfPayments {
    return map(
      (receipt) => receipt.paymentMode ?? "",
    ).where((mode) => mode.isNotEmpty).toList();
  }
}

extension ReceiptReasonsExtensions on List<ReceiptReason> {
  CreditGiven get creditGivenDetails {
    final creditGivenReason = lastWhereOrNull(
      (receiptReason) =>
          receiptReason.reason == ReceiptReasonType.creditGivenToCustomer.value,
    );

    return CreditGiven(
      isGiven:
          (creditGivenReason?.permittedBy ?? "").isNotEmpty ||
          (creditGivenReason?.expectedDate != null &&
              creditGivenReason?.expectedDate != "0000-00-00 00:00:00"),
      amountPending: creditGivenReason?.pendingAmount,
      permittedBy: creditGivenReason?.permittedBy,
      expectedDateOfPayment: creditGivenReason?.expectedDate,
    );
  }

  OldCarPayment get oldCarPaymentDetails {
    final reason = lastWhereOrNull(
      (receiptReason) =>
          receiptReason.reason ==
          ReceiptReasonType.oldCarPaymentPendingFromAgent.value,
    );

    return OldCarPayment(
      isGiven: reason != null,
      amountPending: reason?.pendingAmount,
      agentName: reason?.agentName,
      agentNumber: reason?.agentNo?.toString(),
      expectedDateOfPayment: reason?.expectedDate,
    );
  }
}
