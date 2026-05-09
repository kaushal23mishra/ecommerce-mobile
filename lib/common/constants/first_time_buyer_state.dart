import 'package:salesdocket_mobile/common/constants/constant.dart';

class FirstTimeBuyerState extends Constant<int> {
  final String label;

  const FirstTimeBuyerState(super.value, this.label);

  static const yes = FirstTimeBuyerState(0, "Yes");
  static const no = FirstTimeBuyerState(1, "No");
  static const none = FirstTimeBuyerState(2, "None");
}

String? getFirstTimeBuyerLabel(int? value) {
  switch (value) {
    case 0:
      return FirstTimeBuyerState.yes.label;
    case 1:
      return FirstTimeBuyerState.no.label;
    default:
      return null;
  }
}

int getFirstTimeBuyerValue(String? value) {
  switch (value) {
    case "No":
      return 1;
    case "Yes":
      return 0;
    default:
      return 2;
  }
}

List<FirstTimeBuyerState> get firstTimeBuyerStateList =>
    [FirstTimeBuyerState.yes, FirstTimeBuyerState.no].toList();
