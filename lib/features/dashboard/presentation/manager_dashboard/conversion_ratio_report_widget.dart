import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/reports.dart';
import 'package:salesdocket_mobile/common/events/reports_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/reports_extensions.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/manager_dashboard/details_list_item_widget.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/manager_dashboard/expandable_table_widget.dart';
import 'package:salesdocket_mobile/features/dashboard/view_model/dashboard_view_model.dart';
import 'package:salesdocket_mobile/features/reports/view_model/reports_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ConversionRatioReportWidget extends SalesdocketConsumerStatefulWidget {
  const ConversionRatioReportWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConversionRatioReportState();
}

class _ConversionRatioReportState
    extends SalesdocketConsumerState<ConversionRatioReportWidget>
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
    return Column(
      children: [
        _conversionRatioReportWidget,
        _moreDetailsWidget,
        verticalSpacing(1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Divider(color: appColors.grayMedium, thickness: 0.2.w),
        ),
      ],
    );
  }

  Widget get _conversionRatioReportWidget {
    final isLoading = ref.watch(
      reportsLoaderProvider.select((state) => state.conversionRatio),
    );
    final reportData = ref.watch(conversionRatioReportProvider)?.reportCardItem;

    return DetailsListItemWidget(
      title: LocaleKeys.conversionRatio.tr(),
      isLoading: isLoading,
      reportCardItem: reportData ?? ReportCardItem(),
    );
  }

  Widget get _moreDetailsWidget {
    final showMore = ref.watch(conversionShowMoreProvider);
    final isLoading = ref.watch(
      reportsLoaderProvider.select((state) => state.conversionRatioBreakups),
    );
    final tableData =
        ref.watch(conversionRatioReportBreakupProvider)?.tableData;

    return ExpandableTableSection(
      tableData: tableData ?? [],
      isExpanded: showMore,
      onExpandChanged: (value) {
        ref
            .read(conversionShowMoreProvider.notifier)
            .update((state) => state = value);
      },
      isLoading: isLoading,
    );
  }

  void _invalidateProviders() {
    final providers = [
      conversionShowMoreProvider,
      conversionRatioReportProvider,
      conversionRatioReportBreakupProvider,
    ];

    for (var provider in providers) {
      ref.invalidate(provider);
    }
  }

  void _fetchData() {
    conversionRatioReport();
    conversionRatioReportBreakup();
  }

  @override
  void onConversionRatioReportFetched(ConversionRatioReport? report) {
    ref
        .read(conversionRatioReportProvider.notifier)
        .update((state) => state = report);
  }

  @override
  void onConversionRatioReportBreakupFetched(ConversionRatioReport? report) {
    ref
        .read(conversionRatioReportBreakupProvider.notifier)
        .update((state) => state = report);
  }

  @override
  WidgetRef get eventRef => ref;

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }
}
