import 'package:salesdocket_mobile/common/constants/constant.dart';

class CustomerQuoteState extends Constant<int> {
  final String label;

  const CustomerQuoteState(super.value, this.label);

  static const yes = CustomerQuoteState(1, "Yes");
  static const no = CustomerQuoteState(0, "No");
  static const none = CustomerQuoteState(2, "None");
}

String? getCustomerQuoteLabel(int? value) {
  switch (value) {
    case 1:
      return CustomerQuoteState.yes.label;
    case 0:
      return CustomerQuoteState.no.label;
    default:
      return null;
  }
}

int getCustomerQuoteValue(String? value) {
  switch (value) {
    case "Yes":
      return 1;
    case "No":
      return 0;
    default:
      return 2;
  }
}

List<CustomerQuoteState> get customerQuoteStateList =>
    [CustomerQuoteState.yes, CustomerQuoteState.no].toList();
