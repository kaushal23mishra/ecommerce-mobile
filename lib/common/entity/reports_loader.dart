import 'package:freezed_annotation/freezed_annotation.dart';

part 'reports_loader.freezed.dart';

@freezed
class ReportsLoader with _$ReportsLoader {
  const factory ReportsLoader({
    required bool delivery,
    required bool deliveryBreakups,
    required bool enquiry,
    required bool enquiryBreakups,
    required bool conversionRatio,
    required bool conversionRatioBreakups,
    required bool leadsAging,
    required bool eprVsRegistered,
    required bool followups,
  }) = _ReportsLoader;

  factory ReportsLoader.empty() => const ReportsLoader(
    delivery: false,
    deliveryBreakups: false,
    enquiry: false,
    enquiryBreakups: false,
    conversionRatio: false,
    conversionRatioBreakups: false,
    leadsAging: false,
    eprVsRegistered: false,
    followups: false,
  );
}
