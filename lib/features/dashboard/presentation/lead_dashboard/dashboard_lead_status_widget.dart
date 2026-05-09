import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/lead_list_screen_type.dart';
import 'package:salesdocket_mobile/common/entity/home_card_item.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/lead_dashboard/dashboard_lead_state_widget.dart';
import 'package:salesdocket_mobile/features/dashboard/view_model/dashboard_view_model.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_mobile/utility/lead_list_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DashboardLeadStatusWidget extends SalesdocketConsumerWidget {
  const DashboardLeadStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = _getActivityItems(ref);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 4.w,
        mainAxisExtent: 8.h,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildActivityItem(context, items[index]);
      },
    );
  }

  Widget _buildActivityItem(BuildContext context, MenuItem item) {
    return GestureDetector(
      onTap: () {
        if (item.onFabClicked != null) {
          item.onFabClicked!(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.w),
          border: Border.all(
            color: item.color ?? appColors.primary,
            width: 0.32.w,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.title ?? "",
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: item.color,
                fontWeight: FontWeight.w900,
                fontSize: 22.sp,
              ),
            ),
            verticalSpacing(0.5.h),
            Text(
              item.subtitle ?? "",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: item.color,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<MenuItem> _getActivityItems(WidgetRef ref) {
    return [
      MenuItem(
        title: "H",
        subtitle: LocaleKeys.lblHotLeads.tr(),
        color: appColors.redMedium,
        onFabClicked: (context) {
          _moveToLeadListScreen(context, ref, LeadListScreenType.hotLeads);
        },
      ),
      MenuItem(
        title: "W",
        subtitle: LocaleKeys.lblWarmLeads.tr(),
        color: appColors.orangeMedium,
        onFabClicked: (context) {
          _moveToLeadListScreen(context, ref, LeadListScreenType.warmLeads);
        },
      ),
      MenuItem(
        title: "C",
        subtitle: LocaleKeys.lblColdLeads.tr(),
        color: appColors.blueMedium,
        onFabClicked: (context) {
          _moveToLeadListScreen(context, ref, LeadListScreenType.coldLeads);
        },
      ),
      MenuItem(
        title: "AB",
        subtitle: LocaleKeys.lblActiveBookings.tr(),
        color: appColors.success,
        onFabClicked: (context) {
          _moveToLeadListScreen(
            context,
            ref,
            LeadListScreenType.activeBookings,
          );
        },
      ),
    ];
  }

  void _moveToLeadListScreen(
    BuildContext context,
    WidgetRef ref,
    LeadListScreenType type,
  ) {
    ref
        .read(getLeadRequestProvider.notifier)
        .update(
          (toUpdate) =>
              toUpdate = LeadListUtils.getLeadListDetails(type).defaultRequest,
        );
    ref
        .read(leadListScreenTypeProvider.notifier)
        .update((toUpdate) => toUpdate = type);
    ref.invalidate(leadsProvider);
    context.router.push(const LeadListRoute());
  }
}
