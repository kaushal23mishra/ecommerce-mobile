import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadShimmer extends SalesdocketStatelessWidget {
  const LeadShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.75.h),
      decoration: BoxDecoration(
        color: appColors.secondary,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: appColors.border, width: 0.3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SalesDocketShimmerWidget.rectangular(
            height: 4.5.h,
            width: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3.w,
              children: [
                SalesDocketShimmerWidget.rectangular(height: 30.w, width: 30.w),
                Expanded(
                  child: Column(
                    spacing: 2.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SalesDocketShimmerWidget.rectangular(
                        height: 2.h,
                        width: 50.w,
                      ),
                      SalesDocketShimmerWidget.rectangular(
                        height: 2.h,
                        width: 50.w,
                      ),
                      SalesDocketShimmerWidget.rectangular(
                        height: 2.h,
                        width: 50.w,
                      ),
                      SalesDocketShimmerWidget.rectangular(
                        height: 2.h,
                        width: 50.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SalesDocketShimmerWidget.rectangular(
            height: 4.5.h,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

class ListShimmer extends SalesdocketStatelessWidget {
  const ListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.75.h),
      decoration: BoxDecoration(
        color: appColors.secondary,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: appColors.border, width: 0.3.w),
      ),
      child: Row(
        children: [
          horizontalSpacing(2.w),
          SalesDocketShimmerWidget.rectangular(height: 4.h, width: 20.w),
          Expanded(
            child: SalesDocketShimmerWidget.rectangular(
              height: 4.h,
              width: 30.w,
            ),
          ),
        ],
      ),
    );
  }
}
