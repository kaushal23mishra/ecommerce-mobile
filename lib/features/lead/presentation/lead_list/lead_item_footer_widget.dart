import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/action.dart';
import 'package:salesdocket_mobile/common/constants/lead_list_item_action.dart';
import 'package:salesdocket_mobile/common/constants/lead_list_screen_type.dart';
import 'package:salesdocket_mobile/common/constants/receipt.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/common/events/contact_events.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_mobile/features/cancel_booking/presentation/cancel_booking_popup.dart';
import 'package:salesdocket_mobile/features/cancel_booking/view_model/cancel_booking_view_model.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_mobile/features/followup_history/view_model/followup_history_view_model.dart';
import 'package:salesdocket_mobile/features/inactive_booking/view_model/inactive_booking_view_model.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/booking_followup_popup.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/lead_item_menu_widget.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_list/lead_list_test_drive_given_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/features/profile/view_model/profile_view_model.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_mobile/features/reactivate_lead/view_model/reactivate_lead_view_model.dart';
import 'package:salesdocket_mobile/features/receipt_screen/view_model/receipt_view_model.dart';
import 'package:salesdocket_mobile/features/transfer_lead/view_model/transfer_lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/routing/app_router.dart';
import 'package:salesdocket_mobile/utility/lead_list_utils.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class LeadItemFooterWidget extends SalesdocketConsumerStatefulWidget {
  final Lead lead;

  const LeadItemFooterWidget({super.key, required this.lead});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeadItemFooterState();
}

class _LeadItemFooterState
    extends SalesdocketConsumerState<LeadItemFooterWidget>
    with ContactEvents {
  @override
  Widget build(BuildContext context) {
    final menuActions =
        LeadListUtils.getLeadListDetails(
          ref.watch(leadListScreenTypeProvider),
          lead: widget.lead,
        ).menuActions;

    final widgets = <Widget>[].toList();
    widgets.addAll(
      _actionItems.map((item) {
        return Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              if (item.action != null) {
                item.action!(context);
              }
            },
            child: Container(
              height: 5.2.h,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                color:
                    item.action != null
                        ? appColors.primary
                        : appColors.grayDark,
                border: Border(
                  right: BorderSide(color: appColors.active, width: 0.1.w),
                ),
              ),
              child: Center(
                child: Text(
                  item.title ?? "",
                  textAlign: TextAlign.center,
                  //overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: appColors.secondary,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );

    widgets.add(
      GestureDetector(
        onTap: () => _onMenuClicked(context),
        child: Container(
          height: 5.2.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          color: menuActions.isEmpty ? appColors.grayDark : appColors.primary,
          child: Center(
            child: Icon(Icons.more_vert, color: appColors.secondary, size: 5.w),
          ),
        ),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(2.w),
        bottomRight: Radius.circular(2.w),
      ),
      child: Row(children: widgets),
    );
  }

  List<MenuItem> get _actionItems {
    final details = LeadListUtils.getLeadListDetails(
      ref.read(leadListScreenTypeProvider),
      lead: widget.lead,
    );
    final actions = details.actions;

    return [
      MenuItem(
        title: LocaleKeys.lblFollowup.tr(),
        action:
            actions.contains(LeadListItemAction.followup)
                ? (context) {
                  final currentScreenType = ref.read(leadListScreenTypeProvider);
                  ref
                      .read(followupLeadRequestProvider.notifier)
                      .update((state) => state = widget.lead);
                  if (widget.lead.hasBookingFollowup) {
                    ref
                        .read(leadListScreenTypeProvider.notifier)
                        .update((_) => LeadListScreenType.bookingFollowup);
                  }
                  context.router.push(const FollowupRoute()).then((_) {
                    if (widget.lead.hasBookingFollowup) {
                      ref
                          .read(leadListScreenTypeProvider.notifier)
                          .update((_) => currentScreenType);
                    }
                    _refreshLeads();
                  });
                }
                : null,
        flex: 3,
      ),
      MenuItem(
        title: LocaleKeys.lblProspectSheet.tr(),
        action:
            actions.contains(LeadListItemAction.prospectSheet)
                ? (context) {
                  ref.invalidate(selectedProspectSheetStepProvider);
                  ref.invalidate(prospectLeadRequestProvider);
                  ref
                      .read(prevProspectLeadRequestProvider.notifier)
                      .update((state) => state = widget.lead);
                  final canEdit = LeadUtils.canEditProspectSheet(widget.lead);
                  ref
                      .read(canEditProspectSheetProvider.notifier)
                      .update((state) => state = canEdit);
                  ref
                      .read(isProspectFormInEditMode.notifier)
                      .update((state) => state = canEdit);
                  context.router.push(const ProspectRoute()).then((_) {
                    _refreshLeads();
                  });
                }
                : null,
        flex: 5,
      ),
      MenuItem(
        title: LeadUtils.bookingTitle(widget.lead),
        action:
            actions.contains(LeadListItemAction.booking)
                ? (context) {
                  ref.invalidate(selectedBookingStepProvider);
                  ref.invalidate(bookingLeadRequestProvider);
                  ref
                      .read(canEditBookingProvider.notifier)
                      .update(
                        (state) =>
                            state = LeadUtils.canEditBooking(widget.lead),
                      );
                  ref
                      .read(prevBookingLeadRequestProvider.notifier)
                      .update((state) => state = widget.lead);
                  context.router.push(const BookingRoute()).then((_) {
                    _refreshLeads();
                  });
                }
                : null,
        flex: 3,
      ),
      MenuItem(
        title: LeadUtils.deliveryTitle(widget.lead),
        action:
            actions.contains(LeadListItemAction.delivery)
                ? (context) {
                  ref.invalidate(selectedDeliveryStepProvider);
                  ref.invalidate(deliveryLeadRequestProvider);
                  ref
                      .read(canEditDeliveryProvider.notifier)
                      .update(
                        (state) =>
                            state = LeadUtils.canEditDelivery(widget.lead),
                      );
                  ref
                      .read(prevDeliveryLeadRequestProvider.notifier)
                      .update((state) => state = widget.lead);
                  context.router.push(const DeliveryRoute()).then((_) {
                    _refreshLeads();
                  });
                }
                : null,
        flex: 3,
      ),
    ];
  }

  _onMenuClicked(BuildContext context) async {
    var menuActions =
        LeadListUtils.getLeadListDetails(
          ref.read(leadListScreenTypeProvider),
          lead: widget.lead,
        ).menuActions;

    menuActions = ref.read(receiptViewModelProvider.notifier).filterDeliveryReceiptActions(
      actions: menuActions,
      leadId: widget.lead.id,
    );

    if (menuActions.isEmpty) return;

    final actionItem = await showSalesdocketBottomSheet(
      context: context,
      builder: (_) => LeadItemMenuWidget(actions: menuActions),
    );

    if (actionItem != null) {
      _onLeadMenuActionClicked(actionItem);
    }
  }

  _onLeadMenuActionClicked(LeadListItemMenuAction action) {
    switch (action) {
      case LeadListItemMenuAction.call:
        makePhoneCall(widget.lead.primaryContactNumber, ref);
        break;
      case LeadListItemMenuAction.cancelBooking:
        _onCancelBookingClicked();
        break;
      // case LeadListItemMenuAction.email:
      //   break;
      case LeadListItemMenuAction.followupHistory:
        _onFollowupHistoryClicked();
        break;
      case LeadListItemMenuAction.paymentReceipt:
        _onReceiptClicked();
        break;
      case LeadListItemMenuAction.addDeliveryReceipt:
        _onAddDeliveryReceiptClicked();
        break;
      case LeadListItemMenuAction.viewDeliveryReceipt:
        _onViewDeliveryReceiptClicked();
        break;
      case LeadListItemMenuAction.inactiveBooking:
        _onInactiveBookingClicked();
        break;
      // case LeadListItemMenuAction.message:
      //   break;
      case LeadListItemMenuAction.reactivate:
        _onReactivateLeadClicked();
        break;
      case LeadListItemMenuAction.testDrive:
        _onTestDriveGivenClicked();
        break;
      case LeadListItemMenuAction.transferLead:
        _onTransferLeadClicked();
        break;
      // case LeadListItemMenuAction.whatsapp:
      //   break;
      case LeadListItemMenuAction.validate:
        _onValidateClicked();
        break;
      case LeadListItemMenuAction.bookingFollowup:
        _onBookingFollowupClicked();
        break;
      default:
        break;
    }
  }

  void _onValidateClicked() {
    ref
        .read(followupLeadRequestProvider.notifier)
        .update((state) => state = widget.lead);
    context.router.push(const FollowupRoute());
  }

  void _onCancelBookingClicked() {
    final user = ref.read(profileProvider);
    ref
        .read(cancelBookingLeadProvider.notifier)
        .update((toUpdate) => toUpdate = widget.lead);

    if (user?.isAdmin ?? false) {
      _showCancelBookingPopup();
    } else {
      context.router.push(const CancelBookingRoute()).then((isCancelled) {
        if (isCancelled is bool && isCancelled) {
          _refreshLeads();
        }
      });
    }
  }

  void _onInactiveBookingClicked() {
    ref
        .read(inactiveBookingLeadProvider.notifier)
        .update((toUpdate) => toUpdate = widget.lead);
    context.router.push(const InactiveBookingRoute()).then((isInactive) {
      if (isInactive is bool && isInactive) {
        _refreshLeads();
      }
    });
  }

  void _onReactivateLeadClicked() {
    ref
        .read(reactivateLeadProvider.notifier)
        .update((toUpdate) => toUpdate = widget.lead);
    context.router.push(const ReactivateLeadRoute()).then((isReactivated) {
      if (isReactivated is bool && isReactivated) {
        _refreshLeads();
      }
    });
  }

  void _onTestDriveGivenClicked() async {
    await showSalesdocketBottomSheet(
      context: context,
      builder: (_) => LeadListTestDriveGivenWidget(lead: widget.lead),
    );
  }

  void _onFollowupHistoryClicked() {
    ref
        .read(followupHistoryLead.notifier)
        .update((state) => state = widget.lead);
    context.router.push(const FollowupHistoryRoute());
  }

  void _onTransferLeadClicked() {
    ref
        .read(transferringLeadProvider.notifier)
        .update((state) => state = widget.lead);
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

  void _onReceiptClicked() {
    ref
        .read(receiptLeadProvider.notifier)
        .update((state) => state = widget.lead);
    ref
        .read(receiptSourceProvider.notifier)
        .update((state) => state = ReceiptType.preDelivery);
    ref
        .read(sendReceiptRequestProvider.notifier)
        .update(
          (state) => Receipt(
            leadId: widget.lead.id,
            type: ReceiptType.preDelivery.value,
          ),
        );
    context.router.push(const AddEditReceiptRoute());
  }

  void _onAddDeliveryReceiptClicked() {
    ref
        .read(receiptViewModelProvider.notifier)
        .prepareAddDeliveryReceipt(widget.lead);
    context.router.push(const AddEditReceiptRoute());
  }

  void _onViewDeliveryReceiptClicked() {
    ref
        .read(receiptViewModelProvider.notifier)
        .prepareViewDeliveryReceipt(widget.lead);
    context.router.push(const ReceiptListRoute());
  }

  void _refreshLeads({int page = 1}) async {
    ref.invalidate(leadsProvider);
    ref.read(leadsProvider(page: page));
  }

  void _showCancelBookingPopup() {
    showSalesdocketBottomSheet(
      context: context,
      builder: (_) => const CancelBookingPopup(),
    );
  }

  void _onBookingFollowupClicked() {
    showSalesdocketBottomSheet(
      context: context,
      builder: (context) => BookingFollowupPopup(lead: widget.lead),
    ).then((created) {
      if (created == true) _refreshLeads();
    });
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }
}
