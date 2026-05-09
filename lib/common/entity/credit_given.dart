import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_given.freezed.dart';

@freezed
class CreditGiven with _$CreditGiven {
  const factory CreditGiven({
    bool? isGiven,
    int? amountPending,
    String? permittedBy,
    String? expectedDateOfPayment,
  }) = _CreditGiven;
}
