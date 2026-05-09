import 'package:salesdocket_mobile/common/constants/constant.dart';

class SelectBrandReason extends Constant<String> {
  const SelectBrandReason(super.value);

  static const design = SelectBrandReason('Design');
  static const performance = SelectBrandReason('Performance');
  static const mileage = SelectBrandReason('Mileage');
  static const rideComfort = SelectBrandReason('Ride Comfort');
  static const resaleValue = SelectBrandReason('Resale Value');
  static const price = SelectBrandReason('Price');
  static const afterSalesSupport = SelectBrandReason('After Sales Support');
  static const newModel = SelectBrandReason('New Model');
  static const brandAppeal = SelectBrandReason('Brand Appeal');
  static const betterExchangeValueAtTheOutlet = SelectBrandReason(
    'Got Better Exchange Value At the Outlet',
  );
  static const creditFacilityAtTheOutlet = SelectBrandReason(
    'Got Credit Facility At the Outlet',
  );
  static const happyWithPriceDiscount = SelectBrandReason(
    'Happy With Price/discount',
  );
  static const happyFinanceTermsFacility = SelectBrandReason(
    'Happy With Finance Terms/facility',
  );
  static const friendsFamilyRecommend = SelectBrandReason(
    'Friends/Family recommend',
  );
  static const other = SelectBrandReason('Other');
  static const iDidNotAsk = SelectBrandReason('I Did Not Ask');

  static List<SelectBrandReason> get values => [
    design,
    performance,
    mileage,
    rideComfort,
    resaleValue,
    price,
    afterSalesSupport,
    newModel,
    brandAppeal,
    betterExchangeValueAtTheOutlet,
    creditFacilityAtTheOutlet,
    happyWithPriceDiscount,
    happyFinanceTermsFacility,
    friendsFamilyRecommend,
    other,
    iDidNotAsk,
  ];
}
