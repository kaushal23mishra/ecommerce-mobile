import 'package:easy_localization/easy_localization.dart';
import '../../../../common/constants/constant.dart';
import '../../../../generated/locale_keys.g.dart';

class CallState extends Constant<String> {
  CallState(super.value);

  static CallState spokeToCustomer = CallState(
    LocaleKeys.lblSpokeToCustomer.tr(),
  );
  static CallState busy = CallState(LocaleKeys.lblBusy.tr());
  static CallState switchedOff = CallState(LocaleKeys.lblSwitchedOff.tr());
  static CallState incorrectNumber = CallState(
    LocaleKeys.lblIncorrectNumber.tr(),
  );
  static CallState outOfNetwork = CallState(LocaleKeys.lblOutOfNetwork.tr());
}

List<String> get callStateList => [
  CallState.spokeToCustomer.value,
  CallState.busy.value,
  CallState.switchedOff.value,
  CallState.incorrectNumber.value,
  CallState.outOfNetwork.value,
];
List<String> get callDisableStateList => [
  CallState.spokeToCustomer.value,
  CallState.busy.value,
  CallState.incorrectNumber.value,
];
List<String> get callDisableStateListBeforeTenSecond => [
  CallState.busy.value,
  CallState.switchedOff.value,
  CallState.incorrectNumber.value,
  CallState.outOfNetwork.value,
];

class NewActionType extends Constant<String> {
  const NewActionType(super.value);

  static final NewActionType callLater = NewActionType(
    LocaleKeys.lblCallLetter.tr(),
  );
  static final NewActionType redial = NewActionType(
    LocaleKeys.lblBtnRedial.tr(),
  );
  static final NewActionType planHomeVisit = NewActionType(
    LocaleKeys.lblPlanHomeVisit.tr(),
  );
}

List<String> get newActionList => [
  NewActionType.callLater.value,
  NewActionType.redial.value,
];
List<String> get ccActionList => [
  NewActionType.callLater.value,
  NewActionType.redial.value,
];
List<String> get updatedActionList => [
  NewActionType.planHomeVisit.value,
  NewActionType.callLater.value,
  NewActionType.redial.value,
];

class NewLeadStatusType extends Constant<String> {
  const NewLeadStatusType(super.value);

  static final NewLeadStatusType active = NewLeadStatusType(
    LocaleKeys.lblActive.tr(),
  );
  static final NewLeadStatusType lost = NewLeadStatusType(
    LocaleKeys.lblLost.tr(),
  );
  static final NewLeadStatusType closed = NewLeadStatusType(
    LocaleKeys.lblClosed.tr(),
  );
}

List<String> get newLeadStatusList => [
  NewLeadStatusType.active.value,
  NewLeadStatusType.lost.value,
  NewLeadStatusType.closed.value,
];

class ColdCallingStatusType extends Constant<String> {
  const ColdCallingStatusType(super.value);

  static const ColdCallingStatusType active = ColdCallingStatusType(
    LocaleKeys.lblActive,
  );
  static const ColdCallingStatusType reject = ColdCallingStatusType(
    LocaleKeys.lblReject,
  );

  String localized() => value.tr();
}

List<ColdCallingStatusType> get coldCallingStatusList => [
  ColdCallingStatusType.active,
  ColdCallingStatusType.reject,
];

class HOLeadStatusType extends Constant<String> {
  const HOLeadStatusType(super.value);

  static const HOLeadStatusType active = HOLeadStatusType(LocaleKeys.lblActive);
  static const HOLeadStatusType closed = HOLeadStatusType(LocaleKeys.lblClosed);
  static const HOLeadStatusType lost = HOLeadStatusType(LocaleKeys.lblLost);

  String localized() => value.tr();
}

List<HOLeadStatusType> get hoLeadStatusList => [
  HOLeadStatusType.active,
  HOLeadStatusType.closed,
  HOLeadStatusType.lost,
];

class ValidateNewLeadStatusType extends Constant<String> {
  const ValidateNewLeadStatusType(super.value);

  static const ValidateNewLeadStatusType validateLater =
      ValidateNewLeadStatusType('Validate Later');

  static final ValidateNewLeadStatusType active = ValidateNewLeadStatusType(
    LocaleKeys.lblActive.tr(),
  );

  static final ValidateNewLeadStatusType lost = ValidateNewLeadStatusType(
    LocaleKeys.lblLost.tr(),
  );

  // Correct getter to return the list of values
  static List<String> get values => [
    validateLater.value,
    active.value,
    lost.value,
  ];
}

class NotDoneReasonType extends Constant<String> {
  const NotDoneReasonType(super.value);

  static const busy = NotDoneReasonType('Customer was busy');
  static const notAvailable = NotDoneReasonType('Vehicle was not available');
  static const other = NotDoneReasonType('Other');

  static List<String> get notDoneReasonList => [
    busy.value,
    notAvailable.value,
    other.value,
  ];
}

class RejectReasonType extends Constant<String> {
  const RejectReasonType(super.value);

  static const betterDiscount = RejectReasonType("Got Better Discount");
  static const modelNotAvailable = RejectReasonType(
    "Desired Model Not Available",
  );
  static const colorNotAvailable = RejectReasonType(
    "Desired Color Not Available",
  );
  static const betterExchangeValue = RejectReasonType(
    "Got Better Exchange Value for His/Her Existing Wheeler",
  );
  static const betterFinanceFacility = RejectReasonType(
    "Got Better Finance Facility",
  );
  static const creditFacility = RejectReasonType("Got Credit Facility");
  static const unhappyWithDealer = RejectReasonType(
    "Customer was not happy with the Dealing at my dealership",
  );
  static const notRecommended = RejectReasonType(
    "Friend / Family did not recommend",
  );
  static const didNotAsk = RejectReasonType("I Did not ask");
  static const other = RejectReasonType("Other");

  static List<String> get rejectReasonList => [
    betterDiscount.value,
    modelNotAvailable.value,
    colorNotAvailable.value,
    betterExchangeValue.value,
    betterFinanceFacility.value,
    creditFacility.value,
    unhappyWithDealer.value,
    notRecommended.value,
    didNotAsk.value,
    other.value,
  ];
}

class TestDriveGivenType extends Constant<String> {
  const TestDriveGivenType(super.value);

  static const yes = TestDriveGivenType('Yes');
  static const no = TestDriveGivenType('No');

  static List<String> get testDriveGivenList => [yes.value, no.value];
}

List<IncorrectNumberType> get incorrectNumberList => [
  IncorrectNumberType.planHomeVisit,
  IncorrectNumberType.closed,
];

class IncorrectNumberType extends Constant<String> {
  const IncorrectNumberType(super.value);

  static final planHomeVisit = IncorrectNumberType(
    LocaleKeys.lblPlanHomeVisit.tr(),
  );
  static final closed = IncorrectNumberType(LocaleKeys.lblClosed.tr());
}

List<LeadCategoryType> get leadCategoryList => [
  LeadCategoryType.hot,
  LeadCategoryType.warm,
  LeadCategoryType.cold,
];

class LeadCategoryType extends Constant<String> {
  const LeadCategoryType(super.value);

  static final hot = LeadCategoryType(LocaleKeys.lblHot.tr());
  static final warm = LeadCategoryType(LocaleKeys.lblWarm.tr());
  static final cold = LeadCategoryType(LocaleKeys.lblCold.tr());
}

// class NextFollowUpType extends Constant<String> {
//   const NextFollowUpType(super.value);
//
//   static const homeVisit = NextFollowUpType("Home visit");
//   static const showroomVisit = NextFollowUpType('Showroom visit');
//   static const call = NextFollowUpType('Call');
//   static const dealerVisit = NextFollowUpType('Dealer Visit');
// }

// List<String> get nextFollow => [
//       NextFollowUpType.homeVisit,
//       NextFollowUpType.showroomVisit,
//       NextFollowUpType.call,
//     ].map((status) => status.value).toList();

class LostToType {
  final String value;
  final String label;

  const LostToType(this.value, {required this.label});

  static const LostToType competitor = LostToType(
    'competitor',
    label: "Competitor",
  );
  static const LostToType coDealer = LostToType('coDealer', label: "Co-Dealer");

  static List<LostToType> get lostToList => [competitor, coDealer];
}

class FollowupReasonState extends Constant<String> {
  const FollowupReasonState(super.value);

  static const customerPostponedIndefinitely = FollowupReasonState(
    'Customer postponed indefinitely',
  );
  static const poorCustomerResponse = FollowupReasonState(
    'Poor customer response',
  );
  static const alreadyDelivered = FollowupReasonState('Already delivered');
  static const duplicateEntry = FollowupReasonState('Duplicate entry');
  static const alreadyBooked = FollowupReasonState('Already booked');
  static const unableToSpeakToCustomer = FollowupReasonState(
    'Unable to speak to customer',
  );
  static const wrongNumber = FollowupReasonState('Wrong number');
  static const purchaseSecondHandCar = FollowupReasonState(
    'Purchase second-hand car',
  );
  static const switchBackToPetrol = FollowupReasonState(
    'Chose to switch back to petrol vehicle',
  );
  static const doubtInElectricVehicle = FollowupReasonState(
    'Doubt in electric vehicle',
  );
  static const other = FollowupReasonState('Other');
  static const bookingCancelled = FollowupReasonState('Booking Cancelled');
  static const bookingInactivated = FollowupReasonState('Booking Inactivated');
  static const vehicleDelivered = FollowupReasonState('Vehicle Delivered');
  static const leadTransferred = FollowupReasonState('Lead transferred');
}

List<String> get followupReasonStateList =>
    [
      FollowupReasonState.customerPostponedIndefinitely,
      FollowupReasonState.poorCustomerResponse,
      FollowupReasonState.alreadyDelivered,
      FollowupReasonState.duplicateEntry,
      FollowupReasonState.alreadyBooked,
      FollowupReasonState.unableToSpeakToCustomer,
      FollowupReasonState.wrongNumber,
      FollowupReasonState.purchaseSecondHandCar,
      FollowupReasonState.switchBackToPetrol,
      FollowupReasonState.doubtInElectricVehicle,
      FollowupReasonState.other,
    ].map((status) => status.value).toList();

class RejectReasonState extends Constant<String> {
  const RejectReasonState(super.value);

  static const gotBetterDiscount = RejectReasonState('Got Better Discount');
  static const desiredModelNotAvailable = RejectReasonState(
    'Desired Model Not Available',
  );
  static const desiredColorNotAvailable = RejectReasonState(
    'Desired Color Not Available',
  );
  static const betterExchangeValue = RejectReasonState(
    'Got Better Exchange Value for His/Her Existing Wheeler',
  );
  static const betterFinanceFacility = RejectReasonState(
    'Got Better Finance Facility',
  );
  static const gotCreditFacility = RejectReasonState('Got credit facility');
  static const unhappyWithDealership = RejectReasonState(
    'Customer was not happy with the Dealing at my dealership',
  );
  static const friendOrFamilyDidNotRecommend = RejectReasonState(
    'Friend / Family did not recommend',
  );
  static const didNotAsk = RejectReasonState('I Did not ask');
  static const other = RejectReasonState('Other');
}

List<String> get rejectReasonList =>
    [
      RejectReasonState.gotBetterDiscount,
      RejectReasonState.desiredModelNotAvailable,
      RejectReasonState.desiredColorNotAvailable,
      RejectReasonState.betterExchangeValue,
      RejectReasonState.betterFinanceFacility,
      RejectReasonState.gotCreditFacility,
      RejectReasonState.unhappyWithDealership,
      RejectReasonState.friendOrFamilyDidNotRecommend,
      RejectReasonState.didNotAsk,
      RejectReasonState.other,
    ].map((reason) => reason.value).toList();
