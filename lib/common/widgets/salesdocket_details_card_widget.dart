import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketDetailsCardWidget extends SalesdocketStatelessWidget {
  final List<MenuItem> items;
  final String? label;
  final bool isLightTheme;

  const SalesdocketDetailsCardWidget({
    super.key,
    required this.items,
    this.label,
    this.isLightTheme = true,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: Text(
              label ?? "",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        Container(
          padding: EdgeInsets.only(
            top: 1.h,
            bottom: 1.h,
            left: 3.w,
            right: 3.w,
          ),
          decoration:
              isLightTheme
                  ? BoxDecoration(
                    color: appColors.primaryLight,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(color: appColors.primary, width: 0.3.w),
                  )
                  : BoxDecoration(
                    color: appColors.primary,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0.25.w),
                      child: Text(
                        item.title ?? "",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              isLightTheme
                                  ? appColors.textDisabled
                                  : appColors.primaryLight,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.subtitle ?? "",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color:
                              isLightTheme
                                  ? appColors.primary
                                  : appColors.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
