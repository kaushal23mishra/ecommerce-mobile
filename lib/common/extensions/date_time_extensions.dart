import 'package:easy_localization/easy_localization.dart';

extension DateTimeExtensions on DateTime {
  String formatDateTime({String format = "yyyy-MM-dd HH:mm:ss"}) {
    return DateFormat(format).format(this);
  }

  DateTime get nextYearDate {
    return DateTime(year + 1, month, day);
  }
}
