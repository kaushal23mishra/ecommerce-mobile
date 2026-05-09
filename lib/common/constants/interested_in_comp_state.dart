import 'package:salesdocket_mobile/common/constants/constant.dart';

class InterestedInCompState extends Constant<String> {
  final String label;

  const InterestedInCompState(super.value, this.label);

  static const yes = InterestedInCompState("1", "Yes");
  static const no = InterestedInCompState("0", "No");
  static const iDidNotAsk = InterestedInCompState("2", "I Did Not Ask");
}

String? getInterestedInCompLabel(String? value) {
  switch (value) {
    case "1":
      return InterestedInCompState.yes.label;
    case '0':
      return InterestedInCompState.no.label;
    case '2':
      return InterestedInCompState.iDidNotAsk.label;
    default:
      return null;
  }
}

String? getInterestedInCompValue(String? value) {
  switch (value) {
    case "Yes":
      return "1";
    case "No":
      return "0";
    case "I Did Not Ask":
      return "2";
    default:
      return null;
  }
}

List<InterestedInCompState> get interestedInCompStateList =>
    [
      InterestedInCompState.yes,
      InterestedInCompState.no,
      InterestedInCompState.iDidNotAsk,
    ].toList();
