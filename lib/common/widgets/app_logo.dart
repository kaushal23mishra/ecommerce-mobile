import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class AppLogo extends SalesdocketStatelessWidget {
  final double? size;
  const AppLogo({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SalesDocketImageWidget(
          imagePath: Assets.images.splashDashboardLogo.path,
          height: size ?? 10.h,
        ),
        verticalSpacing(0.5.h),
        Text(
          "${LocaleKeys.appName.tr()} ${LocaleKeys.appNameSuffix.tr()}",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: appColors.textDisabled),
        ),
      ],
    );
  }
}

class AppBarLogo extends SalesdocketStatelessWidget {
  const AppBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SalesDocketImageWidget(
          imagePath: Assets.images.splashDashboardLogo.path,
          height: 3.h,
          radius: BorderRadius.all(Radius.circular(0.5.h)),
        ),
        horizontalSpacing(2.w),
        Flexible(
          child: Text.rich(
            overflow: TextOverflow.ellipsis,
            TextSpan(
              children: [
                TextSpan(
                  text: '${LocaleKeys.appName.tr()} ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: appColors.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: LocaleKeys.appNameSuffix.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: appColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
