import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/notification_events.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/lead_dashboard/dashboard_lead_state_widget.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/lead_dashboard/dashboard_lead_status_widget.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/lead_dashboard/dashboard_notification_card.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/lead_dashboard/dashboard_user_card.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/lead_dashboard/version_widget.dart';
import 'package:salesdocket_mobile/features/dashboard/view_model/dashboard_view_model.dart';
import 'package:salesdocket_mobile/features/notification/view_model/notification_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadDashboard extends SalesdocketConsumerStatefulWidget {
  const LeadDashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeadDashboardState();
}

class _LeadDashboardState extends SalesdocketConsumerState<LeadDashboard>
    with NotificationEvents, AutoRouteAwareStateMixin<LeadDashboard> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWorkflowCounters();
      _getVersion();
    });
    super.initState();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _fetchWorkflowCounters();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: RefreshIndicator(
        onRefresh: () async {
          _fetchWorkflowCounters();
          fetchNotifications();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const DashboardUserCard(),
                    verticalSpacing(2.h),
                    const DashboardNotificationCard(),
                    verticalSpacing(2.h),
                    const DashboardLeadStateWidget(),
                    SizedBox(height: 2.h),
                    user!.isEvaluator
                        ? const SizedBox.shrink()
                        : const DashboardLeadStatusWidget(),
                    SizedBox(height: 2.h),
                    // Push version to bottom with flexible spacing
                    SizedBox(height: constraints.maxHeight * 0.06),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: const VersionWidget(),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _fetchWorkflowCounters() {
    ref.invalidate(workflowCounterProvider);
    ref.read(dashboardViewModelProvider.notifier).getWorkflowCounters().then((
      result,
    ) {
      if (!mounted) return;
      result.when(
        success: (data) {
          ref.read(workflowCounterProvider.notifier).state = data?.data;
        },
        failure: (err) {
          context.showSnackBar(
            err.message ?? LocaleKeys.defaultErrorMessage,
            type: SnackBarType.error,
          );
        },
      );
    });
  }

  _getVersion() async {
    await ref.read(profileViewModelProvider.notifier).getVersion();
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
