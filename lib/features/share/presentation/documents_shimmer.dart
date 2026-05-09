import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DocumentsShimmer extends SalesdocketStatelessWidget {
  const DocumentsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          color: appColors.background,
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Row(
            children: [
              SalesDocketShimmerWidget.rectangular(height: 4.w, width: 4.w),
              horizontalSpacing(4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SalesDocketShimmerWidget.rectangular(
                      height: 2.h,
                      width: 40.w,
                    ),
                    verticalSpacing(0.5.h),
                    SalesDocketShimmerWidget.rectangular(
                      height: 1.h,
                      width: 30.w,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      itemCount: 8,
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
