import 'package:freezed_annotation/freezed_annotation.dart';

part 'lead_source.freezed.dart';

@freezed
class LeadSource with _$LeadSource {
  const factory LeadSource({
    String? source,
    String? sourceErr,
    String? information,
    String? informationErr,
    String? otherReason,
    String? otherReasonErr,
    String? referralName,
    String? referralNumber,
  }) = _LeadSource;
}
