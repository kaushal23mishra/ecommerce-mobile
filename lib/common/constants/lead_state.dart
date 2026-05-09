class LeadState extends Constant<String> {
  const LeadState(super.value);

  static const hot = LeadState('HOT');
  static const warm = LeadState('WARM');
  static const cold = LeadState('COLD');
  static const registered = LeadState('REGISTERED');

  static List<LeadState> get values => [
    LeadState.hot,
    LeadState.warm,
    LeadState.cold,
  ];
}

class Constant<T> {
  final T value;
  const Constant(this.value);
}

class LeadValidState extends Constant<dynamic> {
  const LeadValidState(super.value);

  static const isCCLead = LeadValidState(1);
  static const isHOLead = LeadValidState(1);
  static const ec = LeadValidState('EC');
  static const epe = LeadValidState('EPE');
  static List<LeadValidState> get values => [
    LeadValidState.isCCLead,
    LeadValidState.isHOLead,
  ];
}
