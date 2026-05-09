import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/action.dart';
import 'package:salesdocket_mobile/common/constants/lead_list_item_action.dart';
import 'package:salesdocket_mobile/common/constants/lead_list_screen_type.dart';
import 'package:salesdocket_mobile/common/entity/lead_list_item.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/lead_action_utils.dart';
import 'package:salesdocket_mobile/utility/lead_filter_items_utils.dart';
import 'package:salesdocket_mobile/utility/lead_list_request_utils.dart';

class LeadListUtils {
  static LeadListItem getLeadListDetails(
    LeadListScreenType type, {
    Lead? lead,
  }) {
    switch (type) {
      case LeadListScreenType.hotLeads:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.hotLeads,
          title: LocaleKeys.lblHotLeads.tr(),
          actions: LeadActionUtils.hotLeads,
          menuActions: LeadMenuActionUtils.hotLeads,
          filterItems: LeadFilterItemListUtils.hotLeads,
        );
      case LeadListScreenType.warmLeads:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.warmLeads,
          title: LocaleKeys.lblWarmLeads.tr(),
          actions: LeadActionUtils.warmLeads,
          menuActions: LeadMenuActionUtils.warmLeads,
          filterItems: LeadFilterItemListUtils.warmLeads,
        );
      case LeadListScreenType.coldLeads:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.coldLeads,
          title: LocaleKeys.lblColdLeads.tr(),
          actions: LeadActionUtils.coldLeads,
          menuActions: LeadMenuActionUtils.coldLeads,
          filterItems: LeadFilterItemListUtils.coldLeads,
        );
      case LeadListScreenType.registered:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.registered,
          title: LocaleKeys.registered.tr(),
          actions: LeadActionUtils.epr,
          menuActions: LeadMenuActionUtils.epr,
          filterItems: LeadFilterItemListUtils.registered,
        );
      case LeadListScreenType.activeBookings:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.activeBookings,
          title: LocaleKeys.lblActiveBookings.tr(),
          actions: _withBookingFollowup(lead, LeadActionUtils.activeBookings),
          menuActions: LeadMenuActionUtils.activeBookings,
          filterItems: LeadFilterItemListUtils.activeBookings,
        );
      case LeadListScreenType.deliveries:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.deliveries,
          title: LocaleKeys.lblDeliveries.tr(),
          actions: LeadActionUtils.deliveries,
          menuActions: LeadMenuActionUtils.deliveries,
          filterItems: LeadFilterItemListUtils.deliveries,
        );
      case LeadListScreenType.lostLeads:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.lostLeads,
          title: LocaleKeys.lblLostLeads.tr(),
          actions: LeadActionUtils.lostLeads,
          menuActions: LeadMenuActionUtils.lostLeads,
          filterItems: LeadFilterItemListUtils.lostLeads,
        );
      case LeadListScreenType.lpa:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.lpa,
          title: LocaleKeys.lblLpa.tr(),
          actions: LeadActionUtils.lpa,
          menuActions: LeadMenuActionUtils.lpa,
          filterItems: LeadFilterItemListUtils.lpa,
        );
      case LeadListScreenType.epr:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.epr,
          title: LocaleKeys.lblEPR.tr(),
          actions: LeadActionUtils.epr,
          menuActions: LeadMenuActionUtils.epr,
          filterItems: LeadFilterItemListUtils.epr,
        );
      case LeadListScreenType.closed:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.closed,
          title: LocaleKeys.lblClosed.tr(),
          actions: LeadActionUtils.closed,
          menuActions: LeadMenuActionUtils.closed,
          filterItems: LeadFilterItemListUtils.closed,
        );
      case LeadListScreenType.bpr:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.bpr,
          title: LocaleKeys.lblBpr.tr(),
          actions: _withBookingFollowup(lead, LeadActionUtils.bpr),
          menuActions: LeadMenuActionUtils.bpr,
          filterItems: LeadFilterItemListUtils.bpr,
        );
      case LeadListScreenType.cpa:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.cpa,
          title: LocaleKeys.lblCpa.tr(),
          actions: _withBookingFollowup(lead, LeadActionUtils.cpa),
          menuActions: LeadMenuActionUtils.cpa,
          filterItems: LeadFilterItemListUtils.cpa,
        );
      case LeadListScreenType.inactiveBooking:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.inactiveBooking,
          title: LocaleKeys.lblInactiveBooking.tr(),
          actions: _withBookingFollowup(lead, LeadActionUtils.inactiveBooking),
          menuActions: LeadMenuActionUtils.inactiveBooking,
          filterItems: LeadFilterItemListUtils.inactiveBooking,
        );
      case LeadListScreenType.cancelledBooking:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.cancelledBooking,
          title: LocaleKeys.lblCancelledBooking.tr(),
          actions: _withBookingFollowup(lead, LeadActionUtils.cancelledBooking),
          menuActions: LeadMenuActionUtils.cancelledBooking,
          filterItems: LeadFilterItemListUtils.cancelledBooking,
        );
      case LeadListScreenType.dpr:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.dpr,
          title: LocaleKeys.lblDpr.tr(),
          actions: LeadActionUtils.dpr,
          menuActions: LeadMenuActionUtils.dpr,
          filterItems: LeadFilterItemListUtils.dpr,
        );
      case LeadListScreenType.transferredLeads:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.transferredLeads,
          title: LocaleKeys.lblTransferredLeads.tr(),
          actions: LeadActionUtils.transferredLeads,
          menuActions: LeadMenuActionUtils.transferredLeads,
          filterItems: LeadFilterItemListUtils.transferredLeads,
        );
      case LeadListScreenType.hoLeads:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.hoLead,
          title: LocaleKeys.hoLeads.tr(),
          actions: LeadActionUtils.hoLead,
          menuActions: LeadMenuActionUtils.hoLead,
          filterItems: LeadFilterItemListUtils.hoLead,
        );
      case LeadListScreenType.call:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.call,
          title: LocaleKeys.calls.tr(),
          actions: LeadActionUtils.call,
          menuActions: LeadMenuActionUtils.call,
          filterItems: LeadFilterItemListUtils.call,
        );
      case LeadListScreenType.homeVisit:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.homeVisit,
          title: LocaleKeys.homeVisit.tr(),
          actions: LeadActionUtils.homeVisit,
          menuActions: LeadMenuActionUtils.homeVisit,
          filterItems: LeadFilterItemListUtils.homeVisit,
        );
      case LeadListScreenType.showroom:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.showroomVisit,
          title: LocaleKeys.lblShowroomVisit.tr(),
          actions: LeadActionUtils.showroomVisit,
          menuActions: LeadMenuActionUtils.showroomVisit,
          filterItems: LeadFilterItemListUtils.showroomVisit,
        );
      case LeadListScreenType.coldCalling:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.coldCalling,
          title: LocaleKeys.coldCalling.tr(),
          actions: LeadActionUtils.coldCalling,
          menuActions: LeadMenuActionUtils.coldCalling,
          filterItems: LeadFilterItemListUtils.coldCalling,
        );
      case LeadListScreenType.allLeads:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.allLeads,
          title: LocaleKeys.lblAllLeads.tr(),
          actions: _calculateAction(lead),
          menuActions: _calculateMenuAction(lead),
          filterItems: LeadFilterItemListUtils.allLeads,
        );
      case LeadListScreenType.activeNoTestDrive:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.activeNoTestDrive,
          title: "No Test Drive",
          actions: _calculateAction(lead),
          menuActions: _calculateMenuAction(lead),
          filterItems: LeadFilterItemListUtils.activeNoTestDrive,
        );
      case LeadListScreenType.epe:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.epe,
          title: "EPE",
          actions: LeadActionUtils.evaluator,
          menuActions: LeadMenuActionUtils.hotLeads,
        );
      case LeadListScreenType.ec:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.ec,
          title: "EC",
          actions: LeadActionUtils.evaluator,
          menuActions: LeadMenuActionUtils.hotLeads,
        );
      case LeadListScreenType.bookingFollowup:
        return LeadListItem(
          defaultRequest: LeadListRequestUtils.bookingFollowup,
          title: LocaleKeys.lblBookingFollowup.tr(),
          actions: _calculateBookingFollowupAction(lead),
          menuActions: LeadMenuActionUtils.bookingFollowup,
          filterItems: LeadFilterItemListUtils.bookingFollowup,
        );
      default:
        throw ArgumentError("Unknown LeadListScreenType: $type");
    }
  }

  static LeadListScreenType? getScreenType(Lead lead) {
    if (lead.workflow?.isBooked ?? false) {
      return LeadListScreenType.activeBookings;
    }
    if (lead.workflow?.isDelivered ?? false) {
      return LeadListScreenType.deliveries;
    }
    if (lead.workflow?.isLost ?? false) {
      return LeadListScreenType.lostLeads;
    }
    if (lead.workflow?.isLPA ?? false) {
      return LeadListScreenType.lpa;
    }
    if ((lead.workflow?.isEPR ?? false) ||
        (lead.workflow?.isRegistered ?? false)) {
      return LeadListScreenType.epr;
    }
    if (lead.workflow?.isClosed ?? false) {
      return LeadListScreenType.closed;
    }
    if (lead.workflow?.isBPR ?? false) {
      return LeadListScreenType.bpr;
    }
    if (lead.workflow?.isCPA ?? false) {
      return LeadListScreenType.cpa;
    }
    if (lead.workflow?.isInactive ?? false) {
      return LeadListScreenType.inactiveBooking;
    }
    if (lead.workflow?.isCancelled ?? false) {
      return LeadListScreenType.cancelledBooking;
    }
    if (lead.workflow?.isDPR ?? false) {
      return LeadListScreenType.dpr;
    }

    return null;
  }

  static List<LeadListItemAction> _withBookingFollowup(
    Lead? lead,
    List<LeadListItemAction> actions,
  ) {
    if ((lead?.hasBookingFollowup ?? false) &&
        !actions.contains(LeadListItemAction.followup)) {
      return [...actions, LeadListItemAction.followup];
    }
    return actions;
  }

  static List<LeadListItemAction> _calculateAction(Lead? lead) {
    if (lead == null) return [];

    final screenType = getScreenType(lead);

    final List<LeadListItemAction> actions = screenType == null
        ? []
        : getLeadListDetails(screenType, lead: lead).actions;

    return _withBookingFollowup(lead, actions);
  }

  static List<LeadListItemAction> _calculateBookingFollowupAction(Lead? lead) {
    final actions = _calculateAction(lead).toList();
    actions.remove(LeadListItemAction.delivery);
    if (!actions.contains(LeadListItemAction.followup)) {
      actions.insert(0, LeadListItemAction.followup);
    }
    return actions;
  }

  static List<LeadListItemMenuAction> _withBookingFollowupMenu(
    Lead? lead,
    List<LeadListItemMenuAction> menuActions,
  ) {
    if ((lead?.hasBookingFollowup ?? false) &&
        !menuActions.contains(LeadListItemMenuAction.bookingFollowup)) {
      return [...menuActions, LeadListItemMenuAction.bookingFollowup];
    }
    return menuActions;
  }

  static List<LeadListItemMenuAction> _calculateMenuAction(Lead? lead) {
    if (lead == null) return [];

    final screenType = getScreenType(lead);

    final List<LeadListItemMenuAction> menuActions = screenType == null
        ? []
        : getLeadListDetails(screenType, lead: lead).menuActions;

    return _withBookingFollowupMenu(lead, menuActions);
  }

  static List<LeadListMenuMoreAction> getAppBarMenuItems({
    GetLeadRequest? leadRequest,
    bool isLeadSelected = false,
    LeadListScreenType? listType,
  }) {
    final items = <LeadListMenuMoreAction>[];
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    final hasAccess = user?.isAdmin == true || user?.isSalesManager == true;
    final hasLeadStatus = (leadRequest?.leadStatus ?? "").isNotEmpty;
    final isAllLeads = listType?.isAllLeads ?? false;

    if (!isLeadSelected && hasAccess && isAllLeads && hasLeadStatus) {
      items.add(LeadListMenuMoreAction.downloadExcel);
    }

    if (isLeadSelected && hasAccess && isAllLeads) {
      items.add(LeadListMenuMoreAction.transferLeads);
    }

    return items;
  }
}
