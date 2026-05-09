import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/lead_list_screen_type.dart';
import 'package:salesdocket_mobile/common/entity/home_card_item.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/features/dashboard/view_model/dashboard_view_model.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_mobile/utility/lead_list_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../common/constants/widget.dart';
import '../../../profile/view_model/profile_view_model.dart';

class DashboardLeadStateWidget extends SalesdocketConsumerWidget {
  const DashboardLeadStateWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counters = ref.watch(workflowCounterProvider);
    final List<HomeCardItem> items = _getCounterItems(counters, ref);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 4.w,
        mainAxisExtent: 14.h,
        mainAxisSpacing: 2.h,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return DashboardCardItem(item: items[index]);
      },
    );
  }

  List<HomeCardItem> _getCounterItems(
      WorkflowCounter? counters,
      WidgetRef ref,
      ) {
    final callCount = counters?.calls ?? 0;
    final homeVisitCount = counters?.homeVisit ?? 0;
    final showroomCount = counters?.dealerVisit ?? 0;
    final coldCallingCount = counters?.coldCalling ?? 0;
    final hoLeadsCount = counters?.hoLeads ?? 0;
    final eprCount = counters?.epr ?? 0;
    final epeCount = counters?.epeCount ?? 0;
    final ecCount = counters?.ecCount ?? 0;
    final noTestDrivenActiveLeadsCount =
        counters?.noTestTestDrivenActiveLeads ?? 0;

    final user = ref.watch(profileProvider);
    if (user == null) return [];

    // agar evaluator hai, to empty list return karo
    if (user.isEvaluator) {
      return [
        HomeCardItem(
          title: 'EC',
          icon: Icons.check,
          primaryText: ecCount,
          progressValue: 1,
          backgroundColor: appColors.primaryLight,
          borderColor: appColors.primaryLight,
          onClick: (context) {
            _moveToLeadListScreen(context, ref, LeadListScreenType.ec);
          },
        ),
        HomeCardItem(
          title: 'EPE',
          imagePath: Assets.svg.carExchange.path,
          primaryText: epeCount,
          progressValue: 1,
          backgroundColor: appColors.primaryLight,
          borderColor: appColors.primaryLight,
          onClick: (context) {
            _moveToLeadListScreen(context, ref, LeadListScreenType.epe);
          },
        ),
      ];
    }

    return [
      HomeCardItem(
        title: LocaleKeys.calls.tr(),
        imagePath: Assets.svg.call.path,
        primaryText: callCount,
        progressValue: 1,
        backgroundColor: appColors.primaryLight,
        borderColor: appColors.primaryLight,
        onClick: (context) {
          _moveToLeadListScreen(context, ref, LeadListScreenType.call);
        },
      ),
      HomeCardItem(
        title: LocaleKeys.homeVisit.tr(),
        imagePath: Assets.svg.home.path,
        primaryText: homeVisitCount,
        progressValue: 1,
        backgroundColor: appColors.primaryLight,
        borderColor: appColors.primaryLight,
        onClick: (context) {
          _moveToLeadListScreen(context, ref, LeadListScreenType.homeVisit);
        },
      ),
      HomeCardItem(
        title: LocaleKeys.lblShowroomVisit.tr(),
        imagePath: Assets.svg.location.path,
        primaryText: counters?.dealerVisit ?? 0,
        progressValue: 1,
        backgroundColor: appColors.primaryLight,
        borderColor: appColors.primaryLight,
        onClick: (context) {
          _moveToLeadListScreen(context, ref, LeadListScreenType.showroom);
        },
      ),
      HomeCardItem(
        title: LocaleKeys.lblBookingFollowup.tr(),
        icon: Icons.book_online,
        primaryText: counters?.bookingFollowup ?? 0,
        progressValue: 1,
        backgroundColor: appColors.primaryLight,
        borderColor: appColors.primaryLight,
        onClick: (context) {
          _moveToLeadListScreen(
            context,
            ref,
            LeadListScreenType.bookingFollowup,
          );
        },
      ),
      HomeCardItem(
        title: LocaleKeys.coldCalling.tr(),
        imagePath: Assets.svg.coldCalling.path,
        primaryText: coldCallingCount,
        progressValue: 1,
        progressBgColor: appColors.primaryLight,
        onClick: (context) {
          // _moveToLeadListScreen(context, ref, LeadListScreenType.coldCalling);
          context.showSnackBar("Feature Coming Soon!", type: SnackBarType.warning);
        },
      ),
      HomeCardItem(
        title: LocaleKeys.hoLeads.tr(),
        imagePath: Assets.svg.funnel.path,
        primaryText: hoLeadsCount,
        progressValue: 1,
        progressBgColor: appColors.primaryLight,
        onClick: (context) {
          // _moveToLeadListScreen(context, ref, LeadListScreenType.hoLeads);
          context.showSnackBar("Feature Coming Soon!", type: SnackBarType.warning);
        },
      ),
      HomeCardItem(
        title: "No Test Drive",
        imagePath: Assets.images.testDrive.path,
        primaryText: noTestDrivenActiveLeadsCount,
        progressValue: 1,
        progressBgColor: appColors.primaryLight,
        onClick: (context) {
          _moveToLeadListScreen(
            context,
            ref,
            LeadListScreenType.activeNoTestDrive,
          );
        },
      ),
      HomeCardItem(
        title: LocaleKeys.epr.tr(),
        imagePath: Assets.svg.happyStatus.path,
        primaryText: eprCount,
        progressValue: 1,
        progressBgColor: appColors.primaryLight,
        onClick: (context) {
          _moveToLeadListScreen(context, ref, LeadListScreenType.epr);
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

class DashboardCardItem extends SalesdocketStatelessWidget {
  final HomeCardItem item;

  const DashboardCardItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (item.onClick != null) {
          item.onClick!(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: item.backgroundColor ?? appColors.secondary,
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(
            color: item.borderColor ?? appColors.border,
            width: 0.3.w,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          textAlign: TextAlign.center,
          item.title,
          style: Theme.of(context).textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        if (item.icon != null)
          Icon(
            item.icon,
            size: 6.w,
            color: appColors.primary,
          )
        else if (item.imagePath != null)
          SalesDocketImageWidget(
            imagePath: item.imagePath!,
            width: 6.w,
            height: 6.w,
            color: appColors.primary,
          ),
        _buildProgressIndicator(context),
        _buildRichText(context),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: SizedBox(
        height: 0.4.h,
        width: double.maxFinite,
        child: LiquidLinearProgressIndicator(
          value: item.progressValue,
          valueColor: AlwaysStoppedAnimation(appColors.primary),
          backgroundColor: item.progressBgColor ?? Colors.white,
          borderColor: Colors.transparent,
          borderWidth: 0.w,
          borderRadius: 2.w,
          direction: Axis.horizontal,
        ),
      ),
    );
  }

  Widget _buildRichText(BuildContext context) {
    return Flexible(
      child: RichText(
        text: TextSpan(
          text: item.primaryText.formatNumber,
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(color: appColors.primary),
          children: [
            TextSpan(
              text: item.secondaryText,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: appColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
