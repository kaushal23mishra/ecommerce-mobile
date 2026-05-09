import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/reports_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/reports_extensions.dart';
import 'package:salesdocket_mobile/features/dashboard/view_model/dashboard_view_model.dart';
import 'package:salesdocket_mobile/features/reports/view_model/reports_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class EprRegisteredWidget extends SalesdocketConsumerStatefulWidget {
  const EprRegisteredWidget({super.key});

  @override
  ConsumerState<EprRegisteredWidget> createState() => _EprRegisteredState();
}

class _EprRegisteredState extends SalesdocketConsumerState<EprRegisteredWidget>
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
      reportsLoaderProvider.select((state) => state.eprVsRegistered),
    );
    if (isLoading) return _shimmerWidget;

    final eprVsRegistered =
        ref.watch(eprVsRegisteredReportProvider)?.eprVsRegistered?.firstOrNull;

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
            LocaleKeys.eprVsRegisteredLeads.tr(),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: appColors.secondary),
          ),
        ),
        verticalSpacing(1.5.h),
        Row(
          children: [
            Expanded(
              child: Text(
                "${eprVsRegistered?.eprCount ?? "0"} (${eprVsRegistered?.eprPercentage ?? "0"}%) ${LocaleKeys.epr.tr()}",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: appColors.textDisabled),
              ),
            ),
            Text(
              "${eprVsRegistered?.registeredCount ?? "0"} (${eprVsRegistered?.registeredPercentage ?? "0"}%) ${LocaleKeys.registered.tr()}",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: appColors.textDisabled),
            ),
          ],
        ),
        verticalSpacing(1.h),
        Container(
          height: 5.h,
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(color: appColors.primary),
            borderRadius: BorderRadius.circular(1.w),
          ),
          child: LinearProgressIndicator(
            value: (eprVsRegistered?.eprProgress ?? 0) / 100,
            valueColor: AlwaysStoppedAnimation(appColors.primary),
            backgroundColor: appColors.secondary,
            borderRadius: BorderRadius.circular(1.w),
          ),
        ),
      ],
    );
  }

  Widget get _shimmerWidget {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesDocketShimmerWidget.rectangular(height: 2.h, width: 44.w),
        verticalSpacing(1.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SalesDocketShimmerWidget.rectangular(height: 1.5.h, width: 24.w),
            SalesDocketShimmerWidget.rectangular(height: 1.5.h, width: 24.w),
          ],
        ),
        verticalSpacing(1.h),
        SalesDocketShimmerWidget.rectangular(height: 5.h, width: 92.w),
      ],
    );
  }

  void _invalidateProviders() {
    final providers = [eprVsRegisteredReportProvider];

    for (var provider in providers) {
      ref.invalidate(provider);
    }
  }

  void _fetchData() {
    eprVsRegisteredReport();
  }

  @override
  void onEprVsRegisteredReportFetched(EprVsRegisteredReport? report) {
    ref
        .read(eprVsRegisteredReportProvider.notifier)
        .update((state) => state = report);
  }

  @override
  WidgetRef get eventRef => ref;

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }
}
