import 'package:salesdocket_mobile/common/constants/constant.dart';

class InactiveBookingReasons extends Constant<String> {
  const InactiveBookingReasons(super.value);

  static const poorResponseFromCustomer = InactiveBookingReasons(
    'Poor response from customer',
  );
  static const customerConfused = InactiveBookingReasons('Customer Confused');
  static const financeProblem = InactiveBookingReasons('Finance Problem');
  static const problemInFamily = InactiveBookingReasons('Problem in family');
  static const evaluatingCompetitiorModel = InactiveBookingReasons(
    'Evaluating Competitior Model',
  );
  static const wantsMoreDiscount = InactiveBookingReasons(
    'Wants more discount',
  );
  static const programPostponed = InactiveBookingReasons('Program Postponed');
  static const others = InactiveBookingReasons('Others');

  static List<InactiveBookingReasons> get values => [
    InactiveBookingReasons.poorResponseFromCustomer,
    InactiveBookingReasons.customerConfused,
    InactiveBookingReasons.financeProblem,
    InactiveBookingReasons.problemInFamily,
    InactiveBookingReasons.evaluatingCompetitiorModel,
    InactiveBookingReasons.wantsMoreDiscount,
    InactiveBookingReasons.programPostponed,
    InactiveBookingReasons.others,
  ];
}
