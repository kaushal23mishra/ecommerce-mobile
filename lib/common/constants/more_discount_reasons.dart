import 'package:salesdocket_mobile/common/constants/constant.dart';

class MoreDiscountReasons extends Constant<String> {
  const MoreDiscountReasons(super.value);

  static const knownToManagement = MoreDiscountReasons('Known to Management');
  static const competitionWithCoDealer = MoreDiscountReasons(
    'Competition with Co dealer',
  );
  static const competitionWithOther = MoreDiscountReasons(
    'Competition with other',
  );
  static const directDsaCase = MoreDiscountReasons('Direct DSA Case');
  static const noneOfAbove = MoreDiscountReasons('None of Above');

  static List<MoreDiscountReasons> get values => [
    MoreDiscountReasons.knownToManagement,
    MoreDiscountReasons.competitionWithCoDealer,
    MoreDiscountReasons.competitionWithOther,
    MoreDiscountReasons.directDsaCase,
    MoreDiscountReasons.noneOfAbove,
  ];
}
