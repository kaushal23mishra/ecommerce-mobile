import 'package:salesdocket_core/salesdocket_core.dart';

extension DiscountExtensions on DiscountApproval {
  bool get discountGivenInExcess {
    return (discountGiven ?? 0) > (discountCap ?? 0);
  }
}
