import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/entity/stepper_item.dart';
import 'package:salesdocket_mobile/common/widgets/dotted_line.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketStepper extends SalesdocketStatelessWidget {
  final List<StepperItem> steps;
  final int selectedStep;
  final Function(int) onStepChanged;
  final bool canClick;

  const SalesdocketStepper({
    super.key,
    required this.steps,
    this.selectedStep = 0,
    required this.onStepChanged,
    this.canClick = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 2.h,
      children: [
        _buildStepper(context),
        Expanded(child: steps[selectedStep].content),
      ],
    );
  }

  Widget _buildStepper(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          steps.length,
          (index) => SizedBox(
            width: _stepWidth,
            child: Stack(
              children: [
                Positioned(
                  left: index == 0 ? _stepWidth / 3 : 0.5.w,
                  top: _stepWidth / 4,
                  right: index == steps.length - 1 ? _stepWidth / 2 : 0,
                  height: 0.4.h,
                  child: DottedLine(
                    color:
                        steps[index].isDisabled ? appColors.grayMedium : null,
                  ),
                ),
                _buildStepIndicator(context, index),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context, int index) {
    final isCurrentStep = selectedStep == index;
    final isDisabled = steps[index].isDisabled;

    return GestureDetector(
      onTap: () {
        if (isDisabled || !canClick) return;

        onStepChanged(index);
      }, // Add custom logic if needed
      child: SizedBox(
        width: _stepWidth,
        child: Column(
          children: [
            _buildStepCircle(isCurrentStep, index),
            SizedBox(height: 1.h),
            _buildStepTitle(context, isCurrentStep, index),
            SizedBox(height: 1.h),
            _buildStepDivider(isCurrentStep),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCircle(bool isCurrentStep, int index) {
    final isDisabled = steps[index].isDisabled;

    return Container(
      width: _stepWidth / 2,
      height: _stepWidth / 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDisabled ? appColors.grayMedium : appColors.primary,
          width: 0.4.w,
        ),
        color: isCurrentStep ? appColors.primary : appColors.secondary,
      ),
      child: Center(
        child: SalesDocketImageWidget(
          imagePath: steps[index].imagePath,
          color:
              isCurrentStep
                  ? appColors.secondary
                  : isDisabled
                  ? appColors.grayMedium
                  : appColors.primary,
          width: _stepWidth / 5,
        ),
      ),
    );
  }

  Widget _buildStepTitle(BuildContext context, bool isCurrentStep, int index) {
    final isDisabled = steps[index].isDisabled;

    return Text(
      steps[index].title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: isCurrentStep ? FontWeight.w500 : FontWeight.w400,
        color: isDisabled ? appColors.textDisabled : appColors.textPrimary,
      ),
    );
  }

  Widget _buildStepDivider(bool isCurrentStep) {
    return Container(
      width: _stepWidth - 4.w,
      height: 0.3.h,
      color: isCurrentStep ? appColors.primary : Colors.transparent,
    );
  }

  double get _stepWidth => 100.w / steps.length;
}
