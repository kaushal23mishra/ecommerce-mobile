import 'package:salesdocket_mobile/common/constants/constant.dart';

class TyreReplacement extends Constant<String> {
  const TyreReplacement(super.value);

  static const frontLHS = TyreReplacement("frontLHS");
  static const frontRHS = TyreReplacement("frontRHS");
  static const rearLHS = TyreReplacement("rearLHS");
  static const rearRHS = TyreReplacement("rearRHS");
}

List<TyreReplacement> get tyreReplacementList =>
    [
      TyreReplacement.frontLHS,
      TyreReplacement.frontRHS,
      TyreReplacement.rearLHS,
      TyreReplacement.rearRHS,
    ].toList();
