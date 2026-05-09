import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketSelectedVariantsWidget extends SalesdocketStatelessWidget {
  final List<InterestedVariant> variants;
  final Function(InterestedVariant)? onRemoved;

  const SalesdocketSelectedVariantsWidget({
    super.key,
    this.variants = const [],
    this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    if (variants.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.w, horizontal: 3.w),
      decoration: BoxDecoration(
        color: appColors.active,
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: variants.length,
        itemBuilder: (context, index) {
          final variant = variants[index];

          return Container(
            padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 2.w),
            margin: index != 0 ? EdgeInsets.only(top: 1.5.h) : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: appColors.secondary,
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${variant.product?.name ?? ""} ${variant.variant ?? ""}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: appColors.primary,
                      fontSize: 15.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (onRemoved != null) {
                      onRemoved!(variant);
                    }
                  },
                  child: Icon(
                    Icons.remove_circle_outline_outlined,
                    size: 6.w,
                    color: appColors.redDark,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
