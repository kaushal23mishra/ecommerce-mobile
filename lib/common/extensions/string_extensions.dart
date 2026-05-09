import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/configs/app_configs.dart';

extension NullableStringExtensions on String? {
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }

  String get onePlaceFixedValue {
    final value = double.tryParse(this ?? "0") ?? 0;
    if (value == 0) return "0";

    return value.toStringAsFixed(1);
  }
}

extension StringExtensions on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;

  String get toCamelCase {
    return replaceAll('_', ' ').toLowerCase().replaceAllMapped(
      RegExp(r'(?:^| )(\w)'),
      (match) => match.group(1)!.toUpperCase(),
    );
  }

  String get sentenceToCamelCase {
    return replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  String get maskedPhoneNumber {
    return trim().replaceAllMapped(RegExp(r'^(.)(.*)(.)$'), (match) {
      String first = match.group(1)!;
      String middle = match.group(2)!;
      String last = match.group(3)!;
      return '$first${'*' * middle.length}$last';
    });
  }

  String? formatDateTime({
    String format = "MMM dd, yyyy",
    String inputFormat = "yyyy-MM-dd hh:mm:ss",
  }) {
    if (this == "0000-00-00 00:00:00" || length != inputFormat.length) {
      return null;
    }

    final parsedDate = DateFormat(inputFormat).parse(this);
    return DateFormat(format).format(parsedDate);
  }

  DateTime? toDateTime({String inputFormat = "yyyy-MM-dd hh:mm:ss"}) {
    if (this == "0000-00-00 00:00:00" || length != inputFormat.length) {
      return null;
    }

    return DateTime.tryParse(this);
  }

  String get initials {
    return isNotEmpty
        ? trim().split(RegExp(r"\s+")).map((l) => l[0]).take(1).join()
        : '';
  }

  String get formatTyreText {
    return replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    }).replaceFirstMapped(RegExp(r'^[a-z]'), (match) {
      return match.group(0)!.toUpperCase();
    });
  }

  String get revertTyreText {
    List<String> words = split(" ");
    if (words.isEmpty) return this;

    return words.first.toLowerCase() +
        words
            .skip(1)
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join();
  }

  String get documentUrlFromPath {
    final loadUrl =
        "${AppConfigs.http}${AppConfigs.domain}/${AppConfigs.fileLoc}=";

    return "$loadUrl$this";
  }
}

String cleanNotificationTitle(String? title) {
  if (title == null) return 'No Title';
  String trimmedTitle = title.trim();
  if (trimmedTitle.startsWith('Time to Call')) {
    return trimmedTitle.replaceFirst('Time to Call', '').trim();
  } else if (trimmedTitle.startsWith('Time to Home visit')) {
    return trimmedTitle.replaceFirst('Time to Home visit', '').trim();
  }
  return trimmedTitle;
}
