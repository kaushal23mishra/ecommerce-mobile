import 'package:salesdocket_mobile/common/constants/constant.dart';

class LeadListItemAction extends Constant<String> {
  const LeadListItemAction(super.val);

  static const followup = LeadListItemAction('Followup');
  static const prospectSheet = LeadListItemAction('Register');
  static const booking = LeadListItemAction('Booking');
  static const delivery = LeadListItemAction('Delivery');
}
