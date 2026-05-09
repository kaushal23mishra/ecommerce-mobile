import 'package:salesdocket_mobile/common/constants/constant.dart';

class InsuranceState extends Constant<String> {
  const InsuranceState(super.value);

  static const inHouse = InsuranceState('In-House');
  static const outhouse = InsuranceState('Outhouse');
  static const na = InsuranceState('NA');

  static List<InsuranceState> get values => [
    InsuranceState.inHouse,
    InsuranceState.outhouse,
    InsuranceState.na,
  ];
}

class InsuranceMode extends Constant<String> {
  const InsuranceMode(super.value);

  static const online = InsuranceMode('Online');
  static const offline = InsuranceMode('Offline');

  static List<InsuranceMode> get values => [
    InsuranceMode.online,
    InsuranceMode.offline,
  ];
}

class InsuranceOuthouseReason extends Constant<String> {
  const InsuranceOuthouseReason(super.value);

  static const betterPricingOutside = InsuranceOuthouseReason(
    'Better Pricing Outside',
  );
  static const ownLongTermAgent = InsuranceOuthouseReason(
    'Own Long Term Agent',
  );
  static const dsaCase = InsuranceOuthouseReason('DSA Case');
  static const marriageCase = InsuranceOuthouseReason('Marriage Case');
  static const noneOfAbove = InsuranceOuthouseReason('None of Above');

  static List<InsuranceOuthouseReason> get values => [
    InsuranceOuthouseReason.betterPricingOutside,
    InsuranceOuthouseReason.ownLongTermAgent,
    InsuranceOuthouseReason.dsaCase,
    InsuranceOuthouseReason.marriageCase,
    InsuranceOuthouseReason.noneOfAbove,
  ];
}
