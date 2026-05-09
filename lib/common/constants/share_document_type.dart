import 'package:salesdocket_mobile/common/constants/constant.dart';

class ShareDocumentType extends Constant<String> {
  const ShareDocumentType(super.value);

  static const sms = ShareDocumentType("SMS");
  static const email = ShareDocumentType("Email");
  static const whatsapp = ShareDocumentType("Whatsapp");

  static List<ShareDocumentType> get values => [
    ShareDocumentType.sms,
    ShareDocumentType.email,
    ShareDocumentType.whatsapp,
  ];
}
