import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/reports_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/features/dashboard/view_model/dashboard_view_model.dart';
import 'package:salesdocket_mobile/features/reports/view_model/reports_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadAgingWidget extends SalesdocketConsumerStatefulWidget {
  const LeadAgingWidget({super.key});

  @override
  ConsumerState<LeadAgingWidget> createState() => _LeadAgingState();
}

class _LeadAgingState extends SalesdocketConsumerState<LeadAgingWidget>
    with ReportsEvents {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateProviders();
      _fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      reportsLoaderProvider.select((state) => state.leadsAging),
    );
    if (isLoading) return _shimmerWidget;

    final leadsAging =
        ref.watch(leadsAgingReportProvider)?.leadAging?.firstOrNull;

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: appColors.active,
            borderRadius: BorderRadius.circular(1.w),
          ),
          padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 3.w),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.activeLeadsAging.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: appColors.secondary,
                  ),
                ),
              ),
              Text(
                "${LocaleKeys.totalLeads.tr()} - ${leadsAging?.totalLeadCount ?? 0}",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: appColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        verticalSpacing(2.h),
        Row(
          spacing: 2.w,
          children: [
            Expanded(
              child: _buildCard(
                context,
                title: LocaleKeys.zeroToThirtyDays.tr(),
                value: leadsAging?.zeroToThirtyDays ?? 0,
              ),
            ),
            Expanded(
              child: _buildCard(
                context,
                title: LocaleKeys.thirtyToSixtyDays.tr(),
                value: leadsAging?.thirtyToSixtyDays ?? 0,
              ),
            ),
            Expanded(
              child: _buildCard(
                context,
                title: LocaleKeys.moreThanSixtyDays.tr(),
                value: leadsAging?.moreThanSixty ?? 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    int value = 0,
  }) {
    return Column(
      children: [
        Container(
          color: appColors.secondary,
          child: Text(
            title,
            textAlign: TextAlign.end,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: appColors.textDisabled),
          ),
        ),
        verticalSpacing(0.5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: appColors.active,
            borderRadius: BorderRadius.circular(1.w),
          ),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              "$value",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: appColors.secondary,
                fontSize: 24.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget get _shimmerWidget {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SalesDocketShimmerWidget.rectangular(height: 2.h, width: 33.w),
            SalesDocketShimmerWidget.rectangular(height: 2.h, width: 33.w),
          ],
        ),
        verticalSpacing(2.h),
        Row(
          spacing: 2.w,
          children: List.generate(
            3,
            (_) => Expanded(
              child: Column(
                children: [
                  SalesDocketShimmerWidget.rectangular(
                    height: 2.h,
                    width: 20.w,
                  ),
                  verticalSpacing(0.5.h),
                  SalesDocketShimmerWidget.rectangular(
                    height: 6.h,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _invalidateProviders() {
    final providers = [leadsAgingReportProvider];

    for (var provider in providers) {
      ref.invalidate(provider);
    }
  }

  void _fetchData() {
    leadsAgingReport();
  }

  @override
  void onLeadAgingReportFetched(LeadAgingReport? report) {
    ref
        .read(leadsAgingReportProvider.notifier)
        .update((state) => state = report);
  }

  @override
  WidgetRef get eventRef => ref;

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }
}
