import 'dart:ui';

import 'package:salesdocket_mobile/common/constants/constant.dart';

class SalesdocketLocale extends Constant<String> {
  final Locale locale;

  const SalesdocketLocale(super.value, {required this.locale});

  static const english = SalesdocketLocale(
    'English',
    locale: Locale('en', 'IN'),
  );
  static const nepali = SalesdocketLocale('Nepali', locale: Locale('ne', 'IN'));

  static List<SalesdocketLocale> get values => [english, nepali];
}
