import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/chart_data.dart';
import 'package:salesdocket_mobile/common/events/reports_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/reports_extensions.dart';
import 'package:salesdocket_mobile/features/dashboard/view_model/dashboard_view_model.dart';
import 'package:salesdocket_mobile/features/reports/view_model/reports_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FollowupsWidget extends SalesdocketConsumerStatefulWidget {
  const FollowupsWidget({super.key});

  @override
  ConsumerState<FollowupsWidget> createState() => _FollowupsState();
}

class _FollowupsState extends SalesdocketConsumerState<FollowupsWidget>
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
      reportsLoaderProvider.select((state) => state.followups),
    );
    if (isLoading) return _shimmerWidget;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: appColors.active,
            borderRadius: BorderRadius.circular(1.w),
          ),
          padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 3.w),
          child: Text(
            LocaleKeys.numberOfFollowupsDone.tr(),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: appColors.secondary),
          ),
        ),
        verticalSpacing(2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 4.w,
          children: [_pieChart, Expanded(child: _legendSection)],
        ),
      ],
    );
  }

  Widget get _pieChart {
    final followups =
        ref.watch(followupsReportProvider)?.followups?.firstOrNull;
    final chartData = followups?.chartData ?? [];

    return SizedBox(
      height: 48.w,
      width: 48.w,
      child: SfCircularChart(
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
            dataSource: chartData,
            pointColorMapper: (data, index) => data.color,
            xValueMapper:
                (data, index) => "${data.title} ${data.subtitle ?? ""}",
            yValueMapper: (data, index) => data.value,
            dataLabelMapper: (data, index) {
              final totalFollowupCount =
                  double.tryParse(followups?.totalFollowupCount ?? "0") ?? 0;
              if (totalFollowupCount == 0) return "";

              return "${((data.value / totalFollowupCount) * 100).toStringAsFixed(1)}%";
            },
            radius: "100%",
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.inside,
              overflowMode: OverflowMode.shift,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _legendSection {
    final followups =
        ref.watch(followupsReportProvider)?.followups?.firstOrNull;
    final chartData = followups?.chartData ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: chartData.map((section) => _buildLegend(section)).toList(),
    );
  }

  Widget _buildLegend(ChartData data) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 2.w,
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: BorderRadius.circular(0.5.w),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Row(
              children: [
                Text(
                  data.title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: appColors.textPrimary),
                ),
                Text(
                  " - ${data.subtitle ?? ""}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: appColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _shimmerWidget {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesDocketShimmerWidget.rectangular(height: 2.h, width: 48.w),
        verticalSpacing(1.5.h),
        Row(
          children: [
            SalesDocketShimmerWidget.circular(width: 38.w, height: 38.w),
            horizontalSpacing(6.w),
            Column(
              spacing: 1.5.h,
              children: List.generate(
                4,
                (_) => SalesDocketShimmerWidget.rectangular(
                  height: 2.h,
                  width: 24.w,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _invalidateProviders() {
    final providers = [followupsReportProvider];

    for (var provider in providers) {
      ref.invalidate(provider);
    }
  }

  void _fetchData() {
    followupsReport();
  }

  @override
  void onFollowupsReportFetched(FollowupsReport? report) {
    ref
        .read(followupsReportProvider.notifier)
        .update((state) => state = report);
  }

  @override
  WidgetRef get eventRef => ref;

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }
}
