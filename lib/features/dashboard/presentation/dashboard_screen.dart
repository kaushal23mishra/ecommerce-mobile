import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/dashboard.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/lead_dashboard/lead_dashboard.dart';
import 'package:salesdocket_mobile/features/dashboard/presentation/manager_dashboard/manager_dashboard.dart';
import 'package:salesdocket_mobile/features/dashboard/view_model/dashboard_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class DashboardScreen extends SalesdocketConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  SalesdocketConsumerState<DashboardScreen> createState() =>
      DashboardScreenState();
}

class DashboardScreenState extends SalesdocketConsumerState<DashboardScreen> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 1.0);
    super.initState();
    // Dismiss keyboard when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dismissKeyboard();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final dashboards = profile?.userDashboards ?? [];

    if (dashboards.isEmpty) return const SizedBox.shrink();
    if (dashboards.length == 1) return _getDashboard(dashboards.first);

    return Column(
      children: [
        verticalSpacing(2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            dashboards.length,
            (index) => buildIndicator(index),
          ),
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              dismissKeyboard();
              ref
                  .read(dashboardCurrentPageProvider.notifier)
                  .update((state) => state = page);
            },
            children: dashboards.map((type) => _getDashboard(type)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _getDashboard(DashboardType type) {
    switch (type) {
      case DashboardType.manager:
        return Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: const ManagerDashboard(),
        );
      case DashboardType.lead:
        return Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: const LeadDashboard(),
        );
    }

    return const SizedBox.shrink();
  }

  Widget buildIndicator(int index) {
    final currentPage = ref.watch(dashboardCurrentPageProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      height: 0.4.h,
      width: 4.w,
      decoration: BoxDecoration(
        color: currentPage == index ? appColors.primary : appColors.primaryDark,
        borderRadius: BorderRadius.circular(1.w),
      ),
    );
  }
}
