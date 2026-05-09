import 'package:salesdocket_mobile/common/constants/constant.dart';

class CarSoldType extends Constant<String> {
  const CarSoldType(super.value);

  static const withinTerritory = CarSoldType('Within Territory');
  static const outsideTerritory = CarSoldType('Outside Territory');

  static List<CarSoldType> get values => [
    CarSoldType.withinTerritory,
    CarSoldType.outsideTerritory,
  ];
}
