import 'package:salesdocket_mobile/common/constants/constant.dart';

class AddressType extends Constant<String> {
  const AddressType(super.value);

  static const rural = AddressType('RURAL');
  static const urban = AddressType('URBAN');

  static List<AddressType> get values => [AddressType.rural, AddressType.urban];
}
