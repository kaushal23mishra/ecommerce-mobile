import 'package:salesdocket_mobile/common/constants/constant.dart';

class InterestedInExchangeState extends Constant<int> {
  final String label;

  const InterestedInExchangeState(super.value, this.label);

  static const yes = InterestedInExchangeState(1, "Yes");
  static const no = InterestedInExchangeState(0, "No");
  static const none = InterestedInExchangeState(2, "None");
}

String? getInterestedInExchangeLabel(int? value) {
  switch (value) {
    case 1:
      return InterestedInExchangeState.yes.label;
    case 0:
      return InterestedInExchangeState.no.label;
    default:
      return null;
  }
}

int getInterestedInExchangeValue(String? value) {
  switch (value) {
    case "Yes":
      return 1;
    case "No":
      return 0;
    default:
      return 2;
  }
}

List<InterestedInExchangeState> get interestedInExchangeStateList =>
    [InterestedInExchangeState.yes, InterestedInExchangeState.no].toList();

class ExchangeType extends Constant<String> {
  const ExchangeType(super.value);

  static const inHouse = ExchangeType("In-House");
  static const outHouse = ExchangeType("Out-House");
}

List<ExchangeType> get exchangeTypeList =>
    [ExchangeType.inHouse, ExchangeType.outHouse].toList();

class ExchangeOuthouseReason extends Constant<String> {
  const ExchangeOuthouseReason(super.value);

  static const betterValueOutside = ExchangeOuthouseReason(
    "Better Value Outside",
  );
  static const managementApproval = ExchangeOuthouseReason(
    "Management Approval",
  );
  static const soldToRelative = ExchangeOuthouseReason("Sold to a relative");
  static const other = ExchangeOuthouseReason("Other");
}

List<ExchangeOuthouseReason> get exchangeOuthouseReasonList =>
    [
      ExchangeOuthouseReason.betterValueOutside,
      ExchangeOuthouseReason.managementApproval,
      ExchangeOuthouseReason.soldToRelative,
      ExchangeOuthouseReason.other,
    ].toList();
