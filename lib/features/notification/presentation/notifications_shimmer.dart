import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class NotificationsShimmer extends SalesdocketStatelessWidget {
  const NotificationsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.h, left: 4.w, right: 4.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: appColors.secondary,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: appColors.border, width: 0.3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SalesDocketShimmerWidget.rectangular(height: 2.h, width: 40.w),
              SalesDocketShimmerWidget.rectangular(height: 2.h, width: 20.w),
            ],
          ),
          verticalSpacing(1.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.w,
            children: [
              SalesDocketShimmerWidget.rectangular(height: 24.w, width: 30.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 1.h,
                children: [
                  SalesDocketShimmerWidget.rectangular(
                    height: 2.h,
                    width: 50.w,
                  ),
                  SalesDocketShimmerWidget.rectangular(
                    height: 2.h,
                    width: 30.w,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
