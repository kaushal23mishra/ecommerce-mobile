import 'package:salesdocket_mobile/common/constants/constant.dart';

class CustomerType extends Constant<String> {
  const CustomerType(super.val);

  static const individual = CustomerType('Individual');
  static const corporate = CustomerType('Corporate');

  static List<CustomerType> get values => [
    CustomerType.individual,
    CustomerType.corporate,
  ];
}
