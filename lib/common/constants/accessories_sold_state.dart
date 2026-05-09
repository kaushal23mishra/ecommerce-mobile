import 'package:salesdocket_mobile/common/constants/constant.dart';

class AccessoriesSoldState extends Constant<int> {
  final String label;

  const AccessoriesSoldState(super.value, this.label);

  static const yes = AccessoriesSoldState(1, "Yes");
  static const no = AccessoriesSoldState(0, "No");

  static List<AccessoriesSoldState> get values => [
    AccessoriesSoldState.yes,
    AccessoriesSoldState.no,
  ];

  static String? toLabel(int? value) {
    switch (value) {
      case 1:
        return AccessoriesSoldState.yes.label;
      case 0:
        return AccessoriesSoldState.no.label;
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

class AccessoriesNotSoldReason extends Constant<String> {
  const AccessoriesNotSoldReason(super.value);

  static const boughtTopEndModel = AccessoriesNotSoldReason(
    'Bought Top End Model',
  );
  static const customerDidNotLike = AccessoriesNotSoldReason(
    'Customer Did Not Like',
  );
  static const notAvailable = AccessoriesNotSoldReason('Not Available');
  static const marriageCase = AccessoriesNotSoldReason('Marriage Case');
  static const outsideDSA = AccessoriesNotSoldReason('Outside DSA case');
  static const costly = AccessoriesNotSoldReason('Costly');
  static const noneOfAbove = AccessoriesNotSoldReason('None of Above');

  static List<AccessoriesNotSoldReason> get values => [
    boughtTopEndModel,
    customerDidNotLike,
    notAvailable,
    marriageCase,
    outsideDSA,
    costly,
    noneOfAbove,
  ];
}
