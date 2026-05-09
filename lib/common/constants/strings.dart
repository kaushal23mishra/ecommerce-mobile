import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';

const platformAndroid = 'Android';
const platformApple = 'Apple';
const criticalityHigh = 'High';

const playStoreUrl =
    'https://play.google.com/store/apps/details?id=com.agbe.idealmotors';

const appStoreUrl = 'https://apps.apple.com/in/app/ideal-motors/id6759379708';

class CommonString {
  static final List<String> salutations = <String>[
    LocaleKeys.lblMr.tr(),
    LocaleKeys.lblMiss.tr(),
    LocaleKeys.lblMrs.tr(),
    LocaleKeys.lblMs.tr(),
  ];
}
