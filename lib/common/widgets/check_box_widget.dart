import 'package:flutter_svg/flutter_svg.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class CheckBoxWidget extends SalesdocketStatelessWidget {
  final String label;
  final bool isChecked;
  final Function(bool) onCheckChanged;

  const CheckBoxWidget({
    super.key,
    required this.isChecked,
    required this.label,
    required this.onCheckChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCheckChanged(!isChecked);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.25.h),
        child: Row(
          children: [
            isChecked
                ? SvgPicture.asset(
                  Assets.svg.icCheckboxRounded.path,
                  width: 5.w,
                  height: 5.w,
                )
                : Container(
                  width: 5.w,
                  height: 5.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: appColors.textPrimary,
                      width: 0.2.w,
                    ),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                ),
            horizontalSpacing(2.w),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
