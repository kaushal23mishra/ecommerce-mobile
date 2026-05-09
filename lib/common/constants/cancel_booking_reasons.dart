import 'package:salesdocket_mobile/common/constants/constant.dart';

class CancelBookingReasons extends Constant<String> {
  const CancelBookingReasons(super.value);

  static const lostToCompetitor = CancelBookingReasons('Lost To Competitor');
  static const lostToCoDealer = CancelBookingReasons('Lost To Co-Dealer');
  static const financeProblem = CancelBookingReasons('Finance Problem');
  static const programPostponed = CancelBookingReasons('Program Postponed');
  static const problemInFamily = CancelBookingReasons('Problem in family');
  static const longWaitingPeriod = CancelBookingReasons('Long Waiting Period');
  static const productIssue = CancelBookingReasons('Product Issue');
  static const others = CancelBookingReasons('Others');

  static List<CancelBookingReasons> get values => [
    CancelBookingReasons.lostToCompetitor,
    CancelBookingReasons.lostToCoDealer,
    CancelBookingReasons.financeProblem,
    CancelBookingReasons.programPostponed,
    CancelBookingReasons.problemInFamily,
    CancelBookingReasons.longWaitingPeriod,
    CancelBookingReasons.productIssue,
    CancelBookingReasons.others,
  ];
}
