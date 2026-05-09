import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';

void resetPurchaseModeFields(StateController<Booking?> notifier) {
  notifier.update(
    (toUpdate) => toUpdate?.copyWith(
      financeType: null,
      payoutPercentage: null,
      bookingReasons: null,
      dsaMobile: null,
      dsaName: null,
    ),
  );
}

void applyPurchaseModeFieldChange(
  LeadFormFields field,
  dynamic key,
  dynamic value,
  StateController<Booking?> notifier,
) {
  switch (field) {
    case LeadFormFields.financeType:
      notifier.update(
        (toUpdate) => toUpdate?.copyWith(
          financeType: key,
          payoutPercentage: null,
          bookingReasons: null,
          dsaMobile: null,
          dsaName: null,
        ),
      );
      break;
    case LeadFormFields.selectBank:
      notifier.update(
        (toUpdate) => toUpdate?.copyWith(
          bankId: key,
          bankName: value,
          otherBank: null,
        ),
      );
      break;
    case LeadFormFields.otherBank:
      notifier.update(
        (toUpdate) => toUpdate?.copyWith(otherBank: key),
      );
      break;
    case LeadFormFields.disbursalAmount:
      notifier.update(
        (toUpdate) => toUpdate?.copyWith(disbursalAmount: key),
      );
      break;
    case LeadFormFields.bankPayout:
      notifier.update(
        (toUpdate) => toUpdate?.copyWith(payoutPercentage: key),
      );
      break;
    case LeadFormFields.financeReason:
      notifier.update(
        (toUpdate) => toUpdate?.copyWith(
          bookingReasons: (key as List<String>)
              .map((data) => BookingReason(reason: data))
              .toList(),
        ),
      );
      break;
    case LeadFormFields.dsaName:
      notifier.update(
        (toUpdate) => toUpdate?.copyWith(dsaName: key),
      );
      break;
    case LeadFormFields.dsaMobile:
      notifier.update(
        (toUpdate) => toUpdate?.copyWith(dsaMobile: key),
      );
      break;
    case LeadFormFields.financeTypeOther:
      notifier.update(
        (toUpdate) => toUpdate?.copyWith(financeTypeOther: key),
      );
      break;
    default:
      break;
  }
}
