import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketNoDataWidget extends SalesdocketStatelessWidget {
  final String text;
  final Function? onTextClicked;
  final Color? textColor;

  const SalesdocketNoDataWidget({
    super.key,
    this.text = "No Data Found",
    this.onTextClicked,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SalesDocketImageWidget(
              imagePath: Assets.svg.icNoData.path,
              color: appColors.disabled,
            ),
            verticalSpacing(2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: InkWell(
                onTap: () {
                  if (onTextClicked != null) {
                    onTextClicked!();
                  }
                },
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: appColors.textDisabled,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
