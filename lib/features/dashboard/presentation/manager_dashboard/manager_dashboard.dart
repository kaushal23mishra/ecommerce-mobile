import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/events/notification_events.dart';
import 'package:salesdocket_mobile/common/events/reports_events.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/manager_dashboard/conversion_ratio_report_widget.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/manager_dashboard/delivered_report_widget.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/manager_dashboard/enquiry_report_widget.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/manager_dashboard/epr_registered_widget.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/manager_dashboard/followups_widget.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/manager_dashboard/lead_aging_widget.dart';
import 'package:salesdocket_mobile/features/dashboard/view_model/dashboard_view_model.dart';
import 'package:salesdocket_mobile/features/notification/view_model/notification_view_model.dart';
import 'package:salesdocket_mobile/features/reports/view_model/reports_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ManagerDashboard extends SalesdocketConsumerStatefulWidget {
  const ManagerDashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManagerDashboardState();
}

class _ManagerDashboardState extends SalesdocketConsumerState<ManagerDashboard>
    with ReportsEvents, NotificationEvents {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateProviders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for HO organization changes and refresh reports
    ref.listen<Map<String, int?>>(hoOrganizationContextProvider, (previous, next) {
      // When HO user selects a different organization/designation, refresh all reports
      // Also refresh when clearing the selection (next is empty)
      if (previous != next) {
        // First invalidate all providers to clear old data
        _invalidateProviders();
        // Then fetch fresh data with new organization context (or default if next is empty)
        _fetchReports();
      }
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: RefreshIndicator(
        onRefresh: () async {
          _fetchReports();
          fetchNotifications();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DeliveredReportWidget(),
              verticalSpacing(2.h),
              const EnquiryReportWidget(),
              verticalSpacing(2.h),
              const ConversionRatioReportWidget(),
              verticalSpacing(2.h),
              const LeadAgingWidget(),
              verticalSpacing(3.h),
              const EprRegisteredWidget(),
              verticalSpacing(3.h),
              const FollowupsWidget(),
              verticalSpacing(6.h),
            ],
          ),
        ),
      ),
    );
  }

  void _invalidateProviders() {
    // Invalidate loading state provider
    ref.invalidate(reportsLoaderProvider);

    // Invalidate all report data providers to clear old organization data
    ref.invalidate(deliveredReportProvider);
    ref.invalidate(deliveredReportBreakupProvider);
    ref.invalidate(enquiryReportProvider);
    ref.invalidate(enquiryReportBreakupProvider);
    ref.invalidate(conversionRatioReportProvider);
    ref.invalidate(conversionRatioReportBreakupProvider);
    ref.invalidate(leadsAgingReportProvider);
    ref.invalidate(eprVsRegisteredReportProvider);
    ref.invalidate(followupsReportProvider);
  }

  void _fetchReports() {
    deliveredReport();
    deliveredReportBreakup();
    enquiryReport();
    enquiryReportBreakup();
    conversionRatioReport();
    conversionRatioReportBreakup();
    leadsAgingReport();
    eprVsRegisteredReport();
    followupsReport();
  }

  @override
  void onDeliveryReportFetched(DeliveredReport? report) {
    ref.read(deliveredReportProvider.notifier).update((state) => state = report);
  }

  @override
  void onDeliveryReportBreakupFetched(DeliveredReport? report) {
    ref
        .read(deliveredReportBreakupProvider.notifier)
        .update((state) => state = report);
  }

  @override
  void onEnquiryReportFetched(EnquiryReport? report) {
    ref.read(enquiryReportProvider.notifier).update((state) => state = report);
  }

  @override
  void onEnquiryReportBreakupFetched(EnquiryReport? report) {
    ref
        .read(enquiryReportBreakupProvider.notifier)
        .update((state) => state = report);
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
  void onLeadAgingReportFetched(LeadAgingReport? report) {
    ref.read(leadsAgingReportProvider.notifier).update((state) => state = report);
  }

  @override
  void onEprVsRegisteredReportFetched(EprVsRegisteredReport? report) {
    ref
        .read(eprVsRegisteredReportProvider.notifier)
        .update((state) => state = report);
  }

  @override
  void onFollowupsReportFetched(FollowupsReport? report) {
    ref.read(followupsReportProvider.notifier).update((state) => state = report);
  }

  @override
  void onNotificationsFetched(
    ApiResponse<List<SalesdocketNotification>?>? data,
  ) {
    ref
        .read(notificationsDataProvider.notifier)
        .update((state) => state = data);
  }

  @override
  WidgetRef get eventRef => ref;
}
