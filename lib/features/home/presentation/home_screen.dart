import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/theme.dart';
import 'package:salesdocket_mobile/common/constants/lead_list_screen_type.dart';
import 'package:salesdocket_mobile/common/constants/search_by.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/common/events/notification_events.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/app_logo.dart';
import 'package:salesdocket_mobile/features/home/presentation/drawer_widget.dart';
import 'package:salesdocket_mobile/features/home/view_model/ho_selection_providers.dart';
import 'package:salesdocket_mobile/features/home/view_model/nav_items_provider.dart';
import 'package:salesdocket_mobile/features/home/view_model/nav_view_model.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/notification/view_model/notification_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_mobile/service/notification_service.dart';
import 'package:salesdocket_mobile/utility/lead_list_utils.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../profile/view_model/profile_view_model.dart';

@RoutePage(name: 'HomeRoute')
class HomeScreen extends SalesdocketConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  SalesdocketConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends SalesdocketConsumerState<HomeScreen>
    with AutoRouteAwareStateMixin<HomeScreen>, NotificationEvents {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notificationRepository = ref.read(notificationRepositoryProvider);
      await NotificationService.initializeNotification(notificationRepository);
      _fetchData();
      _initServices();
      setupStatusBar(theme: StatusBarTheme.dark);
      _setupMenuProviders();
      _setupPopInvoked();
    });
    super.initState();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    dismissKeyboard();
    // Delay provider modification until after widget tree is built
    Future.microtask(() => fetchNotifications());
  }

  @override
  Widget build(BuildContext context) {
    final selectedMenuItem = ref.watch(navViewModelProvider);
    final canPop = ref.watch(canPopProvider);
    final isExitPopupShown = ref.watch(isExitPopupShownProvider);
    final user = ref.watch(profileProvider);
    return PopScope(
      canPop: canPop && isExitPopupShown,
      onPopInvokedWithResult: _onPopInvoked,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: appColors.background,
          drawer: const DrawerWidget(),
          onDrawerChanged: (isOpened) {
            dismissKeyboard();
            if (isOpened) {
              _setupPopInvoked(canPop: false);
            }
          },
          appBar: _appBarWidget,
          body:
              selectedMenuItem.content ??
              Center(child: Text(LocaleKeys.noContentAvailable.tr())),
          floatingActionButton:
              user != null && (user.isEvaluator || user.isHOUser)
                  ? SizedBox.shrink()
                  : Container(
                    margin: EdgeInsets.only(top: 2.h),
                    width: 18.w,
                    child: FittedBox(
                      child: FloatingActionButton(
                        backgroundColor: appColors.secondary,
                        foregroundColor: appColors.primary,
                        onPressed: () {
                          dismissKeyboard();
                          ref
                              .read(leadRequestProvider.notifier)
                              .update(
                                (state) =>
                                    state = LeadUtils.defaultCreateLeadRequest,
                              );
                          context.router.push(CreateLeadRoute());
                        },
                        child: Icon(
                          Icons.add,
                          color: appColors.primary,
                          size: 10.w,
                        ),
                      ),
                    ),
                  ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar:
              user != null && (user.isEvaluator || user.isHOUser)
                  ? SizedBox.shrink()
                  : _bottomNavigationBar(selectedMenuItem),
        ),
      ),
    );
  }

  PreferredSizeWidget get _appBarWidget {
    final notificationData = ref.watch(notificationsDataProvider);
    final user = ref.watch(profileProvider);
    return SalesDocketAppBarWidget(
      title: const AppBarLogo(),
      hasDrawer: true,
      kpiIconWidget:
          user != null && (user.isEvaluator || user.isHOUser)
              ? SizedBox.shrink()
              : SalesDocketImageWidget(
                imagePath: Assets.svg.icCompanyVision.path,
                color: appColors.appBarIconColor,
                width: 6.w,
              ),
      onKPIClicked: () {
        dismissKeyboard();
        context.router.push(const LeadAnalysisRoute());
      },
      notificationCount: notificationData?.total ?? 0,
      onNotificationClicked: () {
        dismissKeyboard();
        context.router.push(const NotificationRoute());
      },
      hasSearch:  user != null && (user.isHOUser)
          ? false
          : true,
      searchPlaceholder: LocaleKeys.search.tr(),
      onSearchSubmitted: _onSearchSubmitted,
    );
  }

  Widget _bottomNavigationBar(MenuItem selectedMenuItem) {
    final navViewModel = ref.read(navViewModelProvider.notifier);
    final menuItems = ref.watch(menuItemsProvider);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: appColors.shadow,
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: BottomAppBar(
        color: appColors.secondary,
        padding: EdgeInsets.zero,
        height: 8.h,
        child: Row(
          children:
              menuItems
                  .asMap()
                  .map((index, menuItem) {
                    final isSelected =
                        index == menuItems.indexOf(selectedMenuItem);

                    return MapEntry(
                      index,
                      SizedBox(
                        width: 20.w,
                        child:
                            menuItem.shouldShowFab
                                ? const SizedBox.shrink()
                                : InkWell(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SalesDocketImageWidget(
                                        imagePath: menuItem.icon ?? "",
                                        color:
                                            isSelected
                                                ? appColors.primary
                                                : appColors.grayDark,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        menuItem.title ?? "",
                                        style: TextStyle(
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                          fontSize: 12,
                                          color:
                                              isSelected
                                                  ? appColors.primary
                                                  : appColors.grayDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    dismissKeyboard();
                                    navViewModel.selectMenuItem(
                                      menuItems[index],
                                      context,
                                    );
                                    _setupPopInvoked(canPop: index == 0);
                                  },
                                ),
                      ),
                    );
                  })
                  .values
                  .toList(),
        ),
      ),
    );
  }

  void _setupMenuProviders() {
    ref.invalidate(menuItemsProvider);
    final menuItems = ref.read(menuItemsProvider);
    final navViewModel = ref.read(navViewModelProvider.notifier);
    navViewModel.selectMenuItem(menuItems.first, context);
  }

  void _setupPopInvoked({bool canPop = true}) {
    ref.read(canPopProvider.notifier).update((toSet) => toSet = canPop);
  }

  void _onPopInvoked(bool didPop, dynamic result) {
    loggy.debug(result);
    final isExitPopupShown = ref.read(isExitPopupShownProvider);
    if (didPop && isExitPopupShown) return;

    final selectedMenuItem = ref.read(navViewModelProvider);
    final menuItems = ref.read(menuItemsProvider);
    final isFirst = menuItems.indexOf(selectedMenuItem) == 0;

    if (_scaffoldKey.currentState?.isDrawerOpen == true) {
      _scaffoldKey.currentState?.closeDrawer();
      _setupPopInvoked(canPop: isFirst);
      return;
    }

    if (!isFirst) {
      final navViewModel = ref.read(navViewModelProvider.notifier);
      navViewModel.selectMenuItem(menuItems.first, context);
      _setupPopInvoked();
      return;
    }

    final user = ref.read(profileProvider);
    if (user?.isHOUser == true) {
      final selectedOutletId = ref.read(selectedOutletIdProvider);
      final selectedDesignationId = ref.read(selectedDesignationIdProvider);
      if (selectedOutletId != null || selectedDesignationId != null) {
        ref.read(selectedOutletIdProvider.notifier).state = null;
        ref.read(selectedOutletNameProvider.notifier).state = null;
        ref.read(selectedDesignationIdProvider.notifier).state = null;
        ref.read(selectedDesignationNameProvider.notifier).state = null;
        ref.read(hoOrganizationContextProvider.notifier).clear();
        return;
      }
    }

    if (!isExitPopupShown) {
      // Schedule after current frame to avoid Navigator lock conflicts
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showExitPopup();
        }
      });
    }
  }

  void _onSearchSubmitted(String searchText) {
    dismissKeyboard();
    final user = ref.read(profileProvider);
    const type = LeadListScreenType.allLeads;
    final request = LeadListUtils.getLeadListDetails(
      type,
    ).defaultRequest.copyWith(
      search: searchText,
      searchBy:
          int.tryParse(searchText) == null
              ? SearchBy.name.value.toLowerCase()
              : SearchBy.mobile.value.toLowerCase(),
      exchangeStatus: user?.isEvaluator == true ? "EC,EPE" : null,
    );
    ref
        .read(getLeadRequestProvider.notifier)
        .update((toUpdate) => toUpdate = request);
    ref
        .read(leadListScreenTypeProvider.notifier)
        .update((toUpdate) => toUpdate = type);
    ref.invalidate(leadsProvider);
    context.router.push(const LeadListRoute());
  }

  void _showExitPopup() {
    showSalesdocketBottomSheet(
      context: context,
      builder:
          (context) => SalesdocketAlertBottomSheet(
            title: LocaleKeys.lblSalesDocket.tr(),
            description: LocaleKeys.exitAppMessage.tr(),
            icon: Icon(
              Icons.remove_circle,
              color: appColors.disabled,
              size: 10.w,
            ),
            buttonText: LocaleKeys.exit.tr(),
            buttonColor: appColors.primary,
            onNegativeActionClicked: () {},
            onActionClicked: () {
              ref
                  .read(isExitPopupShownProvider.notifier)
                  .update((toSet) => toSet = true);
              SystemChannels.platform.invokeMethod("SystemNavigator.pop");
            },
          ),
    );
  }

  void _fetchData() {
    fetchNotifications();
  }

  void _initServices() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      fetchNotifications();
    });
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
