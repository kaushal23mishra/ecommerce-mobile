import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/action.dart';
import 'package:salesdocket_mobile/common/constants/lead_list_item_action.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';

class LeadActionUtils {
  static List<LeadListItemAction> get allLeads => [];

  static List<LeadListItemAction> get hotLeads => [];

  static List<LeadListItemAction> get warmLeads => [];

  static List<LeadListItemAction> get coldLeads => [];

  static List<LeadListItemAction> get epr => [
    LeadListItemAction.followup,
    LeadListItemAction.prospectSheet,
    LeadListItemAction.booking,
  ];

  static List<LeadListItemAction> get lpa => [LeadListItemAction.prospectSheet];

  static List<LeadListItemAction> get activeBookings => [
    LeadListItemAction.booking,
    LeadListItemAction.delivery,
  ];

  static List<LeadListItemAction> get deliveries => [
    LeadListItemAction.delivery,
  ];

  static List<LeadListItemAction> get lostLeads => [
    LeadListItemAction.prospectSheet,
  ];

  static List<LeadListItemAction> get closed => [
    LeadListItemAction.prospectSheet,
  ];

  static List<LeadListItemAction> get bpr => [LeadListItemAction.booking];

  static List<LeadListItemAction> get cpa => [LeadListItemAction.booking];

  static List<LeadListItemAction> get inactiveBooking => [
    LeadListItemAction.booking,
  ];

  static List<LeadListItemAction> get cancelledBooking => [
    LeadListItemAction.booking,
  ];

  static List<LeadListItemAction> get dpr => [LeadListItemAction.delivery];

  static List<LeadListItemAction> get transferredLeads => [];

  static List<LeadListItemAction> get hoLead => [LeadListItemAction.followup];

  static List<LeadListItemAction> get call => [
    LeadListItemAction.followup,
    LeadListItemAction.prospectSheet,
    LeadListItemAction.booking,
  ];

  static List<LeadListItemAction> get homeVisit => [
    LeadListItemAction.followup,
    LeadListItemAction.prospectSheet,
    LeadListItemAction.booking,
  ];

  static List<LeadListItemAction> get showroomVisit => [
    LeadListItemAction.followup,
    LeadListItemAction.prospectSheet,
    LeadListItemAction.booking,
  ];

  static List<LeadListItemAction> get coldCalling => [
    LeadListItemAction.followup,
  ];
  static List<LeadListItemAction> get evaluator => [
    LeadListItemAction.prospectSheet,
  ];
}

class LeadMenuActionUtils {
  static bool get _isSC {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );
    return user?.isSalesConsultant ?? false;
  }

  static List<LeadListItemMenuAction> get allLeads => [];

  static List<LeadListItemMenuAction> get hotLeads => [];

  static List<LeadListItemMenuAction> get warmLeads => [];

  static List<LeadListItemMenuAction> get coldLeads => [];

  static List<LeadListItemMenuAction> get epr => [
    LeadListItemMenuAction.call,
    if (!_isSC) LeadListItemMenuAction.transferLead,
    LeadListItemMenuAction.followupHistory,
    LeadListItemMenuAction.testDrive,
  ];

  static List<LeadListItemMenuAction> get lpa {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    return [
      LeadListItemMenuAction.call,
      user?.isSalesManager ?? false
          ? LeadListItemMenuAction.validate
          : LeadListItemMenuAction.reactivate,
      LeadListItemMenuAction.followupHistory,
    ];
  }

  static List<LeadListItemMenuAction> get activeBookings => [
    LeadListItemMenuAction.call,
    if (!_isSC) LeadListItemMenuAction.transferLead,
    LeadListItemMenuAction.cancelBooking,
    LeadListItemMenuAction.inactiveBooking,
    LeadListItemMenuAction.paymentReceipt,
  ];

  static List<LeadListItemMenuAction> get deliveries => [
    LeadListItemMenuAction.call,
    LeadListItemMenuAction.followupHistory,
    LeadListItemMenuAction.addDeliveryReceipt,
    LeadListItemMenuAction.viewDeliveryReceipt,
  ];

  static List<LeadListItemMenuAction> get lostLeads => [
    LeadListItemMenuAction.call,
    LeadListItemMenuAction.reactivate,
    LeadListItemMenuAction.followupHistory,
  ];

  static List<LeadListItemMenuAction> get closed => [
    LeadListItemMenuAction.call,
    LeadListItemMenuAction.reactivate,
    LeadListItemMenuAction.followupHistory,
  ];

  static List<LeadListItemMenuAction> get bpr => [
    LeadListItemMenuAction.call,
    LeadListItemMenuAction.followupHistory,
  ];

  static List<LeadListItemMenuAction> get cpa => [
    LeadListItemMenuAction.call,
    LeadListItemMenuAction.followupHistory,
  ];

  static List<LeadListItemMenuAction> get inactiveBooking {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    return [
      LeadListItemMenuAction.call,
      user?.isSalesManager ?? false
          ? LeadListItemMenuAction.validate
          : LeadListItemMenuAction.reactivate,
      LeadListItemMenuAction.followupHistory,
    ];
  }

  static List<LeadListItemMenuAction> get cancelledBooking => [
    LeadListItemMenuAction.call,
    LeadListItemMenuAction.followupHistory,
  ];

  static List<LeadListItemMenuAction> get dpr => [
    LeadListItemMenuAction.call,
    LeadListItemMenuAction.followupHistory,
  ];

  static List<LeadListItemMenuAction> get transferredLeads => [];

  static List<LeadListItemMenuAction> get hoLead => [];

  static List<LeadListItemMenuAction> get call => [
    LeadListItemMenuAction.call,
    if (!_isSC) LeadListItemMenuAction.transferLead,
    LeadListItemMenuAction.followupHistory,
    LeadListItemMenuAction.testDrive,
  ];

  static List<LeadListItemMenuAction> get homeVisit => [
    LeadListItemMenuAction.call,
    if (!_isSC) LeadListItemMenuAction.transferLead,
    LeadListItemMenuAction.followupHistory,
    LeadListItemMenuAction.testDrive,
  ];

  static List<LeadListItemMenuAction> get showroomVisit => [
    LeadListItemMenuAction.call,
    if (!_isSC) LeadListItemMenuAction.transferLead,
    LeadListItemMenuAction.followupHistory,
    LeadListItemMenuAction.testDrive,
  ];

  static List<LeadListItemMenuAction> get coldCalling => [];
  static List<LeadListItemMenuAction> get bookingFollowup => [
    LeadListItemMenuAction.call,
    LeadListItemMenuAction.followupHistory,
    LeadListItemMenuAction.bookingFollowup,
  ];
}
