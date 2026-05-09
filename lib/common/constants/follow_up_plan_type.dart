import 'package:salesdocket_mobile/common/constants/constant.dart';

class FollowUpPlanType extends Constant<String> {
  const FollowUpPlanType(super.value);

  static const homeVisit = FollowUpPlanType("Home visit");
  static const showroomVisit = FollowUpPlanType('Showroom visit');
  static const call = FollowUpPlanType('Call');
  static const dealerVisit = FollowUpPlanType('Dealer Visit');
  static const bookingCall = FollowUpPlanType('booking_call');
  static const testDrive = FollowUpPlanType('test_drive');

  static List<FollowUpPlanType> get values => [
    FollowUpPlanType.homeVisit,
    FollowUpPlanType.showroomVisit,
    FollowUpPlanType.call,
  ];

  static List<FollowUpPlanType> get createLeadDisabledValues => [
    FollowUpPlanType.homeVisit,
    FollowUpPlanType.showroomVisit,
  ];
}
