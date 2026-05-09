import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/customer_quote.dart';

void applyCustomerQuoteFieldChange(
  LeadFormFields field,
  dynamic key,
  StateController<CustomerQuote?> notifier,
) {
  switch (field) {
    case LeadFormFields.customerTookQuote:
      notifier.update(
        (toUpdate) => toUpdate = CustomerQuote(tookQuote: key, quoteDate: null),
      );
      break;
    case LeadFormFields.quoteDate:
      notifier.update(
        (toUpdate) => toUpdate = toUpdate?.copyWith(quoteDate: key),
      );
      break;
    default:
      break;
  }
}
