import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loggy/loggy.dart';
import 'package:salesdocket_mobile/common/constants/interested_in_comp_state.dart';

part 'interested_in_comp.freezed.dart';

@freezed
class InterestedInComp with _$InterestedInComp {
  const factory InterestedInComp({
    String? status,
    int? model,
    String? modelName,
    int? brand,
    String? brandName,
  }) = _InterestedInComp;
}

extension InterestedInCompExtension on InterestedInComp {
  String? get statusLabel {
    return getInterestedInCompLabel(status);
  }

  String? get vehicle {
    Loggy("").debug(this);
    return status == InterestedInCompState.yes.value
        ? "$brandName $modelName"
        : null;
  }
}
