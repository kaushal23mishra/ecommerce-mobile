import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/action.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/events/notification_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_no_data_widget.dart';
import 'package:salesdocket_mobile/configs/app_configs.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/bottom_bar_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/lead_item_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/lead_list_menu_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/leads_shimmer.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/notification/view_model/notification_view_model.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/features/transfer_lead/view_model/transfer_lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_mobile/utility/lead_list_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: 'LeadListRoute')
class LeadListScreen extends SalesdocketConsumerStatefulWidget {
  const LeadListScreen({super.key});

  @override
  SalesdocketConsumerState<LeadListScreen> createState() =>
      _LeadListScreenState();
}

class _LeadListScreenState extends SalesdocketConsumerState<LeadListScreen>
    with
        LeadEvents,
        NotificationEvents,
        AutoRouteAwareStateMixin<LeadListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateProviders();
      setupStatusBar();
      // _fetchLeads();
      fetchNotifications();
    });
    super.initState();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchNotifications();
      _fetchLeads();
      ref.invalidate(deliveryLeadPendingReasonsProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationData = ref.watch(notificationsDataProvider);
    final canPop = ref.watch(canPopLeadListProvider);

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: appColors.grayLight,
          appBar: SalesDocketAppBarWidget(
            title: _appbarTitleWidget,
            centerTitle: true,
            onHomeClicked: () => onHomeClicked(),
            notificationCount: notificationData?.total ?? 0,
            onNotificationClicked: () {
              context.router.push(const NotificationRoute());
            },
            actionWidgets: _moreActionWidgets,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              _fetchLeads();
            },
            child: Column(
              children: [
                verticalSpacing(2.h),
                Expanded(child: _buildList),
                const BottomBarWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _buildList {
    final pageSize = AppConfigs.pageSize;
    ref.listen<String?>(leadsErrorMessageProvider, _leadsErrorListener);

    return ListView.builder(
      itemBuilder: (context, index) {
        final page = index ~/ pageSize + 1;
        final indexInPage = index % pageSize;
        final responseAsync = ref.watch(leadsProvider(page: page));

        return responseAsync.when(
          error: (err, stack) => const LeadShimmer(),
          loading: () => const LeadShimmer(),
          data: (res) {
            return res.when(
              success: (apiRes) {
                final leads = apiRes?.data?.data ?? [];
                if (leads.isEmpty && index == 0) {
                  return SalesdocketNoDataWidget(
                    text: LocaleKeys.noLeadFound.tr(),
                  );
                }
                if (indexInPage >= leads.length) {
                  return null;
                }
                final lead = leads[indexInPage];
                final selectedLeads = ref.watch(selectedLeadsProvider);
                final isSelected = selectedLeads.any(
                  (selectedLead) => selectedLead.id == lead.id,
                );

                return LeadItemWidget(lead: lead, isSelected: isSelected);
              },
              failure: (error) => const LeadShimmer(),
            );
          },
        );
      },
    );
  }

  Widget get _appbarTitleWidget {
    final screenType = ref.watch(leadListScreenTypeProvider);
    final countData = ref.watch(leadListCountProvider);

    return Column(
      children: [
        Text(
          LeadListUtils.getLeadListDetails(screenType).title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: appColors.appBarTextColor),
        ),
        verticalSpacing(0.5.h),
        Text(
          "$countData ${LocaleKeys.leads.tr()}",
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: appColors.appBarTextColor),
        ),
      ],
    );
  }

  List<Widget>? get _moreActionWidgets {
    final listType = ref.watch(leadListScreenTypeProvider);
    final leadRequest = ref.watch(getLeadRequestProvider);
    final selectedLeads = ref.watch(selectedLeadsProvider);

    final menuItems = LeadListUtils.getAppBarMenuItems(
      leadRequest: leadRequest,
      isLeadSelected: selectedLeads.isNotEmpty,
      listType: listType,
    );

    if (menuItems.isEmpty) return null;

    return [
      Padding(
        padding: EdgeInsets.only(right: 2.w),
        child: InkWell(
          onTap: () => _showMenu(menuItems: menuItems),
          child: Icon(Icons.more_vert, color: appColors.appBarIconColor),
        ),
      ),
    ];
  }

  void _showMenu({List<LeadListMenuMoreAction> menuItems = const []}) async {
    final actionItem = await showSalesdocketBottomSheet(
      context: context,
      builder: (_) => LeadListMenuWidget(menuItems: menuItems),
    );

    if (actionItem != null) {
      _onLeadListMoreMenuActionClicked(actionItem);
    }
  }

  void _onLeadListMoreMenuActionClicked(LeadListMenuMoreAction action) {
    switch (action) {
      case LeadListMenuMoreAction.downloadExcel:
        final leadRequest = ref
            .read(getLeadRequestProvider)
            ?.copyWith(sendEmail: "yes");
        downloadLeads(page: 1, request: leadRequest);
        break;
      case LeadListMenuMoreAction.transferLeads:
        _onTransferLeadsClicked();
        break;
      default:
        break;
    }
  }

  void _onTransferLeadsClicked() {
    final selectedLeads = ref.read(selectedLeadsProvider);
    ref
        .read(transferringLeadsProvider.notifier)
        .update((state) => state = selectedLeads);
    ref
        .read(transferLeadFollowupRequestProvider.notifier)
        .update(
          (state) =>
              state = LeadFollowupRequest(
                followUpDateTime: DateTime.now().formatDateTime(),
                followUpPlan: "Call",
              ),
        );
    context.router.push(const TransferLeadRoute());
  }

  void _invalidateProviders() {
    final providers = [
      selectedLeadsProvider,
      canPopLeadListProvider,
      leadListCountProvider,
    ];
    for (var provider in providers) {
      ref.invalidate(provider);
    }
  }

  _fetchLeads({int page = 1}) async {
    ref.invalidate(leadsProvider);
    ref.read(leadsProvider(page: page));
  }

  void _leadsErrorListener(String? oldMessage, String? newMessage) {
    if (newMessage != null && newMessage.isNotEmpty) {
      showSnackBar(newMessage);
    }
  }

  void _onPopInvokedWithResult(bool didPop, result) {
    if (didPop) return;

    final isLeadsSelected = ref.watch(selectedLeadsProvider).isNotEmpty;
    if (isLeadsSelected) {
      ref.invalidate(selectedLeadsProvider);
    }
    ref
        .read(canPopLeadListProvider.notifier)
        .update((state) => state = isLeadsSelected);
  }

  @override
  void onLeadsDownloaded() {
    showSnackBar(LocaleKeys.exportSuccessful.tr(), type: SnackBarType.success);
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

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }
}
