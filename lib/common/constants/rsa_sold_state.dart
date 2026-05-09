import 'package:salesdocket_mobile/common/constants/constant.dart';

class RsaSoldState extends Constant<int> {
  final String label;

  const RsaSoldState(super.value, this.label);

  static const yes = RsaSoldState(1, "Yes");
  static const no = RsaSoldState(0, "No");

  static List<RsaSoldState> get values => [RsaSoldState.yes, RsaSoldState.no];

  static String? toLabel(int? value) {
    switch (value) {
      case 1:
        return RsaSoldState.yes.label;
      case 0:
        return RsaSoldState.no.label;
      default:
        return null;
    }
  }

  static int? toValue(String? value) {
    switch (value) {
      case "No":
        return 0;
      case "Yes":
        return 1;
      default:
        return null;
    }
  }
}

class RsaNotSoldReason extends Constant<String> {
  const RsaNotSoldReason(super.value);

  static const customerRefused = RsaNotSoldReason('Customer Refused');
  static const marriageCase = RsaNotSoldReason('Marriage Case');
  static const outsideDSA = RsaNotSoldReason('Outside DSA case');
  static const notApplicable = RsaNotSoldReason('Not Applicable');
  static const other = RsaNotSoldReason('Other');

  static List<RsaNotSoldReason> get values => [
    customerRefused,
    marriageCase,
    outsideDSA,
    notApplicable,
    other,
  ];
}
