import 'package:salesdocket_mobile/common/constants/constant.dart';

class ApprovalType extends Constant<String> {
  const ApprovalType(super.value);

  static const booking = ApprovalType('Booking');
  static const delivery = ApprovalType('Delivery');
}
