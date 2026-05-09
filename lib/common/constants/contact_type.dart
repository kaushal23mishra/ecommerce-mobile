import 'package:salesdocket_mobile/common/constants/constant.dart';

class ContactType extends Constant<String> {
  const ContactType(super.value);

  static const mobile = ContactType('Mobile');
  static const home = ContactType('Home');
  static const office = ContactType('Office');
  static const email = ContactType('Email');
}
