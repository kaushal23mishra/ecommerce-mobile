import 'package:salesdocket_mobile/common/constants/constant.dart';

class LeadListScreenType extends Constant<String> {
  const LeadListScreenType(super.val);

  static const hotLeads = LeadListScreenType("lblHotLeads");
  static const warmLeads = LeadListScreenType("lblWarmLeads");
  static const coldLeads = LeadListScreenType("lblColdLeads");
  static const activeBookings = LeadListScreenType("lblActiveBookings");
  static const deliveries = LeadListScreenType("lblDeliveries");
  static const lostLeads = LeadListScreenType("lblLostLeads");
  static const lpa = LeadListScreenType("lblLpa");
  static const epr = LeadListScreenType("lblEPR");
  static const closed = LeadListScreenType("lblClosed");
  static const bpr = LeadListScreenType("lblBpr");
  static const cpa = LeadListScreenType("lblCpa");
  static const inactiveBooking = LeadListScreenType("lblInactiveBooking");
  static const cancelledBooking = LeadListScreenType("lblCancelledBooking");
  static const dpr = LeadListScreenType("lblDpr");
  static const transferredLeads = LeadListScreenType("lblTransferredLeads");
  static const call = LeadListScreenType("call");
  static const homeVisit = LeadListScreenType("homeVisit");
  static const showroom = LeadListScreenType("showroom");
  static const hoLeads = LeadListScreenType("hoLeads");
  static const coldCalling = LeadListScreenType("coldCalling");
  static const allLeads = LeadListScreenType("allLeads");
  static const registered = LeadListScreenType("registered");
  static const activeNoTestDrive = LeadListScreenType("activeNoTestDrive");
  static const epe = LeadListScreenType("EPE");
  static const ec = LeadListScreenType("EC");
  static const bookingFollowup = LeadListScreenType("bookingFollowup");

  bool get isHotLeads => this == hotLeads;

  bool get isWarmLeads => this == warmLeads;

  bool get isColdLeads => this == coldLeads;

  bool get isActiveBookings => this == activeBookings;

  bool get isDeliveries => this == deliveries;

  bool get isLostLeads => this == lostLeads;

  bool get isLpa => this == lpa;

  bool get isEpr => this == epr;

  bool get isClosed => this == closed;

  bool get isBpr => this == bpr;

  bool get isCpa => this == cpa;

  bool get isInactiveBooking => this == inactiveBooking;

  bool get isCancelledBooking => this == cancelledBooking;

  bool get isDpr => this == dpr;

  bool get isTransferredLeads => this == transferredLeads;

  bool get isCall => this == call;

  bool get isShowroom => this == showroom;

  bool get isHomeVisit => this == homeVisit;

  bool get isHoLeads => this == hoLeads;

  bool get isColdCalling => this == coldCalling;

  bool get isAllLeads => this == allLeads;

  bool get isRegistered => this == registered;

  bool get isActiveNoTestDrive => this == activeNoTestDrive;
  bool get isBookingFollowup => this == bookingFollowup;
}
