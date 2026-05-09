import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:salesdocket_mobile/common/constants/customer_quote_state.dart';

part 'customer_quote.freezed.dart';

@freezed
class CustomerQuote with _$CustomerQuote {
  const factory CustomerQuote({
    int? tookQuote,
    String? quoteDate,
  }) = _CustomerQuote;
}

extension CustomerQuoteExtension on CustomerQuote {
  String? get tookQuoteLabel {
    return getCustomerQuoteLabel(tookQuote);
  }

  String? get quoteDateLabel {
    if (tookQuote != CustomerQuoteState.yes.value) return null;
    return quoteDate;
  }

  bool get hasQuote {
    return tookQuote == CustomerQuoteState.yes.value;
  }
}
