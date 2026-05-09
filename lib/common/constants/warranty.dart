import 'package:salesdocket_mobile/common/constants/constant.dart';

class WarrantyState extends Constant<int> {
  final String label;

  const WarrantyState(super.value, this.label);

  static const yes = WarrantyState(1, "Yes");
  static const no = WarrantyState(0, "No");

  static List<WarrantyState> get values => [
    WarrantyState.yes,
    WarrantyState.no,
  ];

  static String? toLabel(int? value) {
    switch (value) {
      case 1:
        return WarrantyState.yes.label;
      case 0:
        return WarrantyState.no.label;
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

class WarrantyExpiration extends Constant<String> {
  const WarrantyExpiration(super.value);

  static const twoYears = WarrantyExpiration('2 years');
  static const threeYears = WarrantyExpiration('3 years');
  static const fourYears = WarrantyExpiration('4 years');
  static const fiveYears = WarrantyExpiration('5 years');

  static List<WarrantyExpiration> get values => [
    twoYears,
    threeYears,
    fourYears,
    fiveYears,
  ];
}

class NoWarrantyReason extends Constant<String> {
  const NoWarrantyReason(super.value);

  static const planNotSuitable = NoWarrantyReason('Plan Not Suitable');
  static const excessiveRunning = NoWarrantyReason('Excessive Running');
  static const costly = NoWarrantyReason('Costly');
  static const marriageCase = NoWarrantyReason('Marriage Case');
  static const dsaCase = NoWarrantyReason('DSA Case');
  static const notInterested = NoWarrantyReason('Not Interested At All');
  static const noneOfAbove = NoWarrantyReason('None of Above');

  static List<NoWarrantyReason> get values => [
    planNotSuitable,
    excessiveRunning,
    costly,
    marriageCase,
    dsaCase,
    notInterested,
    noneOfAbove,
  ];
}
