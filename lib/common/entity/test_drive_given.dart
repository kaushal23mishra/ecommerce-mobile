import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:salesdocket_mobile/common/constants/test_drive_given_constants.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';

part 'test_drive_given.freezed.dart';

@freezed
class TestDriveGiven with _$TestDriveGiven {
  const factory TestDriveGiven({
    int? given,
    String? when,
    String? vehicleUsed,
    String? toWhom,
    String? whyNotGiven,
    String? whyNotGivenReason,
  }) = _TestDriveGiven;
}

extension TestDriveGivenExtension on TestDriveGiven {
  bool get isTestDriveGiven {
    return given == TestDriveGivenState.yes.value;
  }

  String get testDrivenGivenLabel {
    return isTestDriveGiven
        ? TestDriveGivenState.yes.label
        : TestDriveGivenState.no.label;
  }

  String? get testDriveDetails {
    return isTestDriveGiven
        ? "By ${vehicleUsed ?? ""} to ${toWhom ?? ""} on ${when?.formatDateTime() ?? ""}"
        : null;
  }
}
