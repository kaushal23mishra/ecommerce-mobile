import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:salesdocket_mobile/common/constants/first_time_buyer_state.dart';

part 'first_time_buyer.freezed.dart';

@freezed
class FirstTimeBuyer with _$FirstTimeBuyer {
  const factory FirstTimeBuyer({
    int? isExistingVehicle,
    int? oldVehicleId,
    String? oldVehicleName,
    int? oldVehicleVariantId,
    String? oldVehicleVariantName,
    int? oldVehicleMakeYear,
    String? ownership,
  }) = _FirstTimeBuyer;
}

extension FirstTimeBuyerExtension on FirstTimeBuyer {
  String? get existingLabel {
    return getFirstTimeBuyerLabel(isExistingVehicle);
  }

  String? get vehicleDetails {
    if (isExistingVehicle != FirstTimeBuyerState.no.value) return null;
    final vehicle =
        "${oldVehicleName ?? ""} ${oldVehicleVariantName ?? ""}".trim();
    if (vehicle.isEmpty) return null;
    return oldVehicleMakeYear != null ? "$vehicle ($oldVehicleMakeYear)" : vehicle;
  }
}
