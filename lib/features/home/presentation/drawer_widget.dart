import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/lead_list_screen_type.dart';
import 'package:salesdocket_mobile/common/events/auth_events.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_profile_image_widget.dart';
import 'package:salesdocket_mobile/features/home/presentation/widgets/ho_drawer_content_widget.dart';
import 'package:salesdocket_mobile/features/home/view_model/ho_drawer_view_model.dart';
import 'package:salesdocket_mobile/features/home/view_model/nav_view_model.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_mobile/utility/lead_list_utils.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import '../../../generated/assets.gen.dart';

class DrawerWidget extends SalesdocketConsumerStatefulWidget {
  const DrawerWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DrawerState();
}

class _DrawerState extends SalesdocketConsumerState<DrawerWidget>
    with AuthEvents {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getVersion();
      _fetchProfile();

  
    });
    super.initState();
  }

  void _fetchProfile() async {
    await ref.read(profileViewModelProvider.notifier).fetchProfileFromRemote();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileProvider);
    return Drawer(
      width: 72.w,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(5.w),
          bottomRight: Radius.circular(5.w),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpacing(3.h),
          _profileWidget,
          verticalSpacing(2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: Divider(thickness: 0.2.h),
          ),
          user != null && user.isHOUser
              ? Expanded(
            child: Column(
              children: [
                Expanded(child: HoDrawerContentWidget()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.w),
                  child: Divider(thickness: 0.2.h),
                ),
                _logoutWidget,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.w),
                  child: Divider(thickness: 0.2.h),
                ),
                _versionWidget,
                verticalSpacing(2.h),
              ],
            ),
          )
              : Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  color: appColors.primary,
                  context,
                  icon: Icons.list,
                  text: LocaleKeys.lblAllLeads,
                  onTap: () {
                    _moveToLeadListScreen(LeadListScreenType.allLeads);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.edit,
                  text: LocaleKeys.lblCreateLead,
                  onTap: () {
                    ref
                        .read(leadRequestProvider.notifier)
                        .update(
                          (state) =>
                      state = LeadUtils.defaultCreateLeadRequest,
                    );
                    context.router.push(CreateLeadRoute());
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard,
                  text: LocaleKeys.lblDashboard,
                  onTap: () {
                    context.router.maybePop();
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.app_registration,
                  text: LocaleKeys.registered,
                  onTap: () {
                    _moveToLeadListScreen(LeadListScreenType.registered);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.whatshot,
                  text: LocaleKeys.lblHotLeads,
                  onTap: () {
                    _moveToLeadListScreen(LeadListScreenType.hotLeads);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.thermostat_auto,
                  text: LocaleKeys.lblWarmLeads,
                  onTap: () {
                    _moveToLeadListScreen(LeadListScreenType.warmLeads);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.ac_unit,
                  text: LocaleKeys.lblColdLeads,
                  onTap: () {
                    _moveToLeadListScreen(LeadListScreenType.coldLeads);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.bookmark_border,
                  text: LocaleKeys.lblActiveBookings,
                  onTap: () {
                    _moveToLeadListScreen(
                      LeadListScreenType.activeBookings,
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.local_shipping_outlined,
                  text: LocaleKeys.lblDeliveries,
                  onTap: () {
                    _moveToLeadListScreen(LeadListScreenType.deliveries);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.remove_circle_outline,
                  text: LocaleKeys.lblLostLeads,
                  onTap: () {
                    _moveToLeadListScreen(LeadListScreenType.lostLeads);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.bar_chart,
                  text: LocaleKeys.lblEPR,
                  onTap: () {
                    _moveToLeadListScreen(LeadListScreenType.epr);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.check_circle_outline,
                  text: LocaleKeys.lblClosed,
                  onTap: () {
                    _moveToLeadListScreen(LeadListScreenType.closed);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.business_center_outlined,
                  text: LocaleKeys.lblBpr,
                  onTap: () {
                    _moveToLeadListScreen(LeadListScreenType.bpr);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.group_outlined,
                  text: LocaleKeys.lblCpa,
                  onTap: () {
                    _moveToLeadListScreen(LeadListScreenType.cpa);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.cancel_outlined,
                  text: LocaleKeys.lblInactiveBooking,
                  onTap: () {
                    _moveToLeadListScreen(
                      LeadListScreenType.inactiveBooking,
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.cancel_outlined,
                  text: LocaleKeys.lblCancelledBooking,
                  onTap: () {
                    _moveToLeadListScreen(
                      LeadListScreenType.cancelledBooking,
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.trending_down,
                  text: LocaleKeys.lblDpr,
                  onTap: () {
                    _moveToLeadListScreen(LeadListScreenType.dpr);
                  },
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.w),
                  child: Divider(thickness: 0.2.h),
                ),
                _logoutWidget,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.w),
                  child: Divider(thickness: 0.2.h),
                ),
                _versionWidget,
                verticalSpacing(2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        IconData? icon,
        String? imagePath,
        required String text,
        final Color? color,
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 6.w, right: 4.w, bottom: 2.5.h),
        child: Row(
          children: [
            if (imagePath != null)
              SvgPicture.asset(
                imagePath,
                width: 6.w,
                height: 6.w,
                colorFilter: ColorFilter.mode(
                  color ?? appColors.grayDark,
                  BlendMode.srcIn,
                ),
              )
            else if (icon != null)
              Icon(icon, color: color ?? appColors.grayDark, size: 6.w),
            horizontalSpacing(4.w),
            Text(
              text.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color ?? appColors.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _profileWidget {
    final profile = ref.watch(profileProvider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SalesdocketProfileImageWidget(
            name: profile?.fullNameWOSalutation,
            imageUrl: profile?.logo,
            size: 15.w,
          ),
          horizontalSpacing(4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?.fullNameWOSalutation ?? "",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: appColors.textPrimary,
                    fontSize: 18.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpacing(0.5.h),
                Text(
                  profile?.organizationName ?? "",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: appColors.textDisabled,
                    fontSize: 15.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _logoutWidget {
    return GestureDetector(
      onTap: () async {
        // Set exit popup flag to true to prevent exit confirmation dialog
        ref.read(isExitPopupShownProvider.notifier).update((state) => true);
        await logout();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        child: Row(
          children: [
            Icon(Icons.logout, color: appColors.redDark, size: 6.w),
            horizontalSpacing(4.w),
            Text(
              LocaleKeys.logout.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: appColors.redDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _versionWidget {
    final version = ref.watch(versionProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(),
          Text(
            version ?? "",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: appColors.grayDark),
          ),
        ],
      ),
    );
  }

  void _moveToLeadListScreen(LeadListScreenType type) {
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

  void _getVersion() async {
    await ref.read(profileViewModelProvider.notifier).getVersion();
  }

  @override
  void moveToAuthScreen() {
    if (mounted) {
      final navigator = Navigator.of(context, rootNavigator: true);

      // Check if there are modal routes that need to be closed
      if (navigator.canPop() && ModalRoute.of(context) != null) {
        // There's a modal open, close it first
        navigator.pop();

        // Wait for modal to close completely before proceeding
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            context.router.pushAndPopUntil(
              const AuthRoute(),
              predicate: (_) => false,
            );
          }
        });
      } else {
        // No modal open, proceed directly
        context.router.pushAndPopUntil(
          const AuthRoute(),
          predicate: (_) => false,
        );
      }
    }
  }

  @override
  WidgetRef get eventRef => ref;
}
