import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class HoDrawerShimmerWidget extends SalesdocketStatelessWidget {
  const HoDrawerShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 8, // Show 8 shimmer items
      itemBuilder: (context, index) {
        return _buildShimmerItem();
      },
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
      child: Row(
        children: [
          // Icon shimmer
          SalesDocketShimmerWidget.circular(
            width: 5.w,
            height: 5.w,
          ),
          horizontalSpacing(3.w),
          // Text shimmer
          Expanded(
            child: SalesDocketShimmerWidget.rectangular(
              height: 2.h,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
