import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketUserItem extends SalesdocketStatelessWidget {
  final User user;
  final bool isSelected;
  final Function()? onClicked;

  const SalesdocketUserItem({
    super.key,
    required this.user,
    this.isSelected = false,
    this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onClicked != null) {
          onClicked!();
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                user.fullName,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: appColors.textDisabled),
              ),
            ),
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: SalesDocketImageWidget(
                  imagePath: Assets.svg.icCircleCheck.path,
                  width: 4.w,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
