import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loggy/loggy.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

part 'stepper_item.freezed.dart';

@freezed
class StepperItem with _$StepperItem {
  const factory StepperItem({
    required int step,
    required String title,
    required Widget content,
    required String imagePath,
    @Default(false) bool isDisabled,
  }) = _StepperItem;
}

extension StepItemExtension on List<StepperItem> {
  int prevEnableStep(int currentStep) {
    Loggy("").debug(currentStep);
    for (int index = currentStep - 1; index >= 0; index--) {
      if (!this[index].isDisabled) {
        return index;
      }
    }

    return 0;
  }

  int nextEnableStep(int currentStep) {
    for (int index = currentStep + 1; index < length; index++) {
      if (!this[index].isDisabled) {
        return index;
      }
    }

    return length - 1;
  }
}
