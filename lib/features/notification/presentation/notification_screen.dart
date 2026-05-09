import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/notification_alert_type.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/events/notification_events.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/notification_extensions.dart';
import 'package:salesdocket_mobile/common/providers/loading_state_provider.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_loading_overlay.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_no_data_widget.dart';
import 'package:salesdocket_mobile/configs/app_configs.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/lead_item_widget.dart';
import 'package:salesdocket_mobile/features/notification/presentation/notification_item_widget.dart';
import 'package:salesdocket_mobile/features/notification/presentation/notifications_shimmer.dart';
import 'package:salesdocket_mobile/features/notification/view_model/notification_view_model.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

@RoutePage(name: 'NotificationRoute')
class NotificationScreen extends SalesdocketConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState
    extends SalesdocketConsumerState<NotificationScreen>
    with NotificationEvents {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupStatusBar();
      _fetchNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(loadingStateProvider);

    return SafeArea(
      child: Scaffold(
        appBar: SalesDocketAppBarWidget(
          title: _appbarTitleWidget,
          centerTitle: true,
          onHomeClicked: () => onHomeClicked(),
          actionWidgets: [_markAsReadActionWidget],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _fetchNotifications();
          },
          child: Stack(
            children: [
              _buildList,
              SalesdocketLoadingOverlay(isLoading: loading),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildList {
    final pageSize = AppConfigs.pageSize;

    return ListView.builder(
      itemBuilder: (context, index) {
        final page = index ~/ pageSize + 1;
        final indexInPage = index % pageSize;
        final responseAsync = ref.watch(notificationsProvider(page: page));

        return responseAsync.when(
          error: (err, stack) {
            return Center(child: Text('Error: $err'));
          },
          loading: () => const NotificationsShimmer(),
          data: (res) {
            return res.when(
              success: (apiRes) {
                final notifications = apiRes?.data?.data ?? [];
                if (notifications.isEmpty && index == 0) {
                  return SalesdocketNoDataWidget(
                    text: LocaleKeys.noNotificationsFound.tr(),
                  );
                }
                if (indexInPage >= notifications.length) {
                  return null;
                }
                final notification = notifications[indexInPage];

                switch (fromValue(notification.alertType)) {
                  case NotificationAlertType.followup:
                    return Container(
                      margin: EdgeInsets.only(top: index == 0 ? 1.h : 0),
                      child: _notificationWidget(notification),
                    );
                  default:
                    final lead = notification.lead;
                    return Container(
                      margin: EdgeInsets.only(top: index == 0 ? 1.h : 0),
                      child:
                          lead == null
                              ? _notificationWidget(notification)
                              : LeadItemWidget(
                                lead: lead,
                                hasActions: false,
                                notification: notification,
                                onLeadClicked: () {
                                  _onNotificationItemClicked(notification);
                                },
                              ),
                    );
                }
              },
              failure: (error) {
                return Center(child: Text('Error: $error'));
              },
            );
          },
        );
      },
    );
  }

  Widget _notificationWidget(SalesdocketNotification notification) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.75.h),
      child: NotificationItemWidget(
        notification: notification,
        onItemClicked: () {
          _onNotificationItemClicked(notification);
        },
      ),
    );
  }

  Widget get _markAsReadActionWidget {
    return GestureDetector(
      onTap: () {
        _showMarkAllAsReadBottomSheet();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Icon(Icons.mark_chat_read_rounded, color: appColors.primary),
      ),
    );
  }

  Widget get _appbarTitleWidget {
    final countData = ref.watch(notificationListCountProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.notifications.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: appColors.appBarTextColor),
        ),
        verticalSpacing(0.5.h),
        Text(
          "Showing $countData",
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: appColors.appBarTextColor),
        ),
      ],
    );
  }

  void _showMarkAllAsReadBottomSheet() {
    showSalesdocketBottomSheet(
      context: context,
      builder: (context) {
        return SalesdocketAlertBottomSheet(
          title: "Mark all as read",
          description: "You’re all caught up! No unread notifications left.",
          icon: Icon(
            Icons.mark_chat_read_rounded,
            color: appColors.success,
            size: 8.w,
          ),
          buttonText: LocaleKeys.ok.tr(),
          buttonColor: appColors.primary,
          onActionClicked: () {
            readAllNotifications();
          },
        );
      },
    );
  }

  _fetchNotifications({int page = 1}) async {
    ref.invalidate(notificationsProvider);
    ref.read(notificationsProvider(page: page));
  }

  void _onNotificationItemClicked(SalesdocketNotification notification) {
    _readNotification(notification);
    switch (fromValue(notification.alertType)) {
      case NotificationAlertType.bookingCancelRequest:
      case NotificationAlertType.bookingCancelResponse:
        _handleBookingCancelResponse(notification);
        break;
      case NotificationAlertType.deliveryApprovalNormal:
      case NotificationAlertType.deliveryApprovalResponse:
      case NotificationAlertType.deliveryApprovalDiscountApproval:
        _handleDeliveryApprovalResponse(notification);
        break;
      case NotificationAlertType.discountApproval:
      case NotificationAlertType.discountApprovalResponse:
        _handleBookingDiscountApproval(notification);
        break;
      case NotificationAlertType.followup:
        _handleFollowup(notification);
        break;
      case NotificationAlertType.leadLostApproval:
        _handleLeadLostApproval(notification);
        break;
      case NotificationAlertType.leadLostApprovalResponse:
        _handleLeadLostApprovalResponse(notification);
        break;
      case NotificationAlertType.leadTransfer:
        _handleLeadTransfer(notification);
      case NotificationAlertType.leadReassigned:
        _handleLeadReassigned(notification);
      case NotificationAlertType.exchangeEvaluationPending:
      case NotificationAlertType.exchangeEvaluationCompleted:
        _handleExchangeEvaluation(notification);
      case NotificationAlertType.campaignCCLeadAssigned:
      case NotificationAlertType.campaignHOLeadAssigned:
        _handleCampaignLead(notification);
      default:
        _moveToHomeScreen();
        break;
    }
  }

  void _readNotification(SalesdocketNotification notification) {
    final readNotificationRequest = ReadNotificationsRequest(
      ids: notification.id?.toString(),
    );
    readNotifications(request: readNotificationRequest);
  }

  void _handleBookingCancelResponse(SalesdocketNotification notification) {
    final lead = notification.leadWithId;
    ref.invalidate(selectedBookingStepProvider);
    ref.invalidate(bookingLeadRequestProvider);
    ref.read(selectedBookingStepProvider.notifier).update((state) => state = 4);
    ref
        .read(prevBookingLeadRequestProvider.notifier)
        .update((state) => state = lead);
    context.router.push(const BookingRoute());
  }

  void _handleDeliveryApprovalResponse(SalesdocketNotification notification) {
    final notificationDiscount = notification.info?.when(
      discount: (discount) => discount,
      lead: (_) => null,
    );
    final lead = notificationDiscount?.delivery?.lead;
    ref
        .read(selectedDeliveryStepProvider.notifier)
        .update((state) => state = 5);
    ref.invalidate(deliveryLeadRequestProvider);
    ref
        .read(prevDeliveryLeadRequestProvider.notifier)
        .update(
          (state) =>
              state = lead?.copyWith(delivery: notificationDiscount?.delivery),
        );
    context.router.push(const DeliveryRoute());
  }

  void _handleBookingDiscountApproval(SalesdocketNotification notification) {
    final notificationDiscount = notification.info?.when(
      discount: (discount) => discount,
      lead: (_) => null,
    );
    final lead = notificationDiscount?.lead ?? notification.leadWithId;
    ref.invalidate(bookingLeadRequestProvider);
    ref.read(selectedBookingStepProvider.notifier).update((state) => state = 4);
    ref
        .read(prevBookingLeadRequestProvider.notifier)
        .update((state) => state = lead);
    context.router.push(const BookingRoute());
  }

  void _handleExchangeEvaluation(SalesdocketNotification notification) {
    final lead = notification.lead;
    ref.invalidate(prospectLeadRequestProvider);
    ref
        .read(selectedProspectSheetStepProvider.notifier)
        .update((state) => state = 2);
    ref
        .read(prevProspectLeadRequestProvider.notifier)
        .update((state) => state = lead);
    context.router.push(const ProspectRoute());
  }

  void _handleFollowup(SalesdocketNotification notification) {
    final lead = notification.workflowLead;
    _moveToFollowupScreen(lead);
  }

  void _handleLeadTransfer(SalesdocketNotification notification) {
    final lead = notification.lead;
    ref.invalidate(prospectLeadRequestProvider);
    ref
        .read(prevProspectLeadRequestProvider.notifier)
        .update((state) => state = lead);
    context.router.push(const ProspectRoute());
  }

  void _handleLeadLostApprovalResponse(SalesdocketNotification notification) {
    final lead = notification.lead;
    _moveToFollowupScreen(lead);
  }

  void _handleLeadLostApproval(SalesdocketNotification notification) {
    final lead = notification.lead;
    _moveToFollowupScreen(lead);
  }

  void _handleLeadReassigned(SalesdocketNotification notification) {
    final lead = notification.lead;
    ref.invalidate(prospectLeadRequestProvider);
    ref
        .read(prevProspectLeadRequestProvider.notifier)
        .update((state) => state = lead);
    context.router.push(const ProspectRoute());
  }

  void _handleCampaignLead(SalesdocketNotification notification) {
    final lead = notification.lead;
    ref
        .read(followupLeadRequestProvider.notifier)
        .update((state) => state = lead);
    context.router.push(const FollowupRoute()).then((_) {
      hideLoader();
    });
  }

  void _moveToFollowupScreen(Lead? lead) {
    ref
        .read(followupLeadRequestProvider.notifier)
        .update((state) => state = lead);
    context.router.push(const FollowupRoute()).then((_) {
      hideLoader();
    });
  }

  void _moveToHomeScreen() {
    onHomeClicked();
  }

  @override
  void onNotificationRead() {
    _fetchNotifications();
  }

  @override
  void onAllNotificationRead() {
    _fetchNotifications();
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    return context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
