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

class DeliveredReportWidget extends SalesdocketConsumerStatefulWidget {
  const DeliveredReportWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeliveredReportsState();
}

class _DeliveredReportsState
    extends SalesdocketConsumerState<DeliveredReportWidget>
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
        _deliveredReportWidget,
        _moreDetailsWidget,
        verticalSpacing(1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Divider(color: appColors.grayMedium, thickness: 0.2.w),
        ),
      ],
    );
  }

  Widget get _deliveredReportWidget {
    final isLoading = ref.watch(
      reportsLoaderProvider.select((state) => state.delivery),
    );
    final reportData = ref.watch(deliveredReportProvider)?.reportCardItem;

    return DetailsListItemWidget(
      title: LocaleKeys.delivered.tr(),
      isLoading: isLoading,
      reportCardItem: reportData ?? ReportCardItem(),
    );
  }

  Widget get _moreDetailsWidget {
    final showMore = ref.watch(deliveredShowMoreProvider);
    final isLoading = ref.watch(
      reportsLoaderProvider.select((state) => state.deliveryBreakups),
    );
    final tableData = ref.watch(deliveredReportBreakupProvider)?.tableData;

    return ExpandableTableSection(
      tableData: tableData ?? [],
      isExpanded: showMore,
      onExpandChanged: (value) {
        ref
            .read(deliveredShowMoreProvider.notifier)
            .update((state) => state = value);
      },
      isLoading: isLoading,
    );
  }

  void _invalidateProviders() {
    final providers = [
      deliveredShowMoreProvider,
      deliveredReportProvider,
      deliveredReportBreakupProvider,
    ];

    for (var provider in providers) {
      ref.invalidate(provider);
    }
  }

  void _fetchData() {
    deliveredReport();
    deliveredReportBreakup();
  }

  @override
  void onDeliveryReportFetched(DeliveredReport? report) {
    ref
        .read(deliveredReportProvider.notifier)
        .update((state) => state = report);
  }

  @override
  void onDeliveryReportBreakupFetched(DeliveredReport? report) {
    ref
        .read(deliveredReportBreakupProvider.notifier)
        .update((state) => state = report);
  }

  @override
  WidgetRef get eventRef => ref;

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }
}
