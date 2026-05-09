import 'package:salesdocket_mobile/common/constants/constant.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';

class WorkflowState extends Constant<String> {
  const WorkflowState(super.value);

  static const active = WorkflowState('ACTIVE');
  static const booking = WorkflowState('BOOKING');
  static const booked = WorkflowState('BOOKED');
  static const bpr = WorkflowState('BPR');
  static const cancelled = WorkflowState('CANCELLED');
  static const closed = WorkflowState('CLOSED');
  static const cpa = WorkflowState('CPA');
  static const delivered = WorkflowState('DELIVERED');
  static const dpr = WorkflowState('DPR');
  static const epr = WorkflowState('EPR');
  static const inactive = WorkflowState('INACTIVE');
  static const inactiveBooking = WorkflowState('INACTIVE_BOOKING');
  static const lost = WorkflowState('LOST');
  static const lpa = WorkflowState('LPA');
  static const registered = WorkflowState('REGISTERED');
  static const none = WorkflowState('NONE');
  static const competitor = WorkflowState('COMPETITOR');
}

List<List<String>> get leadFiltersWorkflowStatusList => [
  ["epr+registered", WorkflowState.active.value.toCamelCase],
  ["epr", WorkflowState.epr.value],
  ["registered", WorkflowState.registered.value],
  ["booked", WorkflowState.booked.value.toCamelCase],
  ["delivered", WorkflowState.delivered.value.toCamelCase],
  ["lost", WorkflowState.lost.value.toCamelCase],
  ["closed", WorkflowState.closed.value.toCamelCase],
  ["BPR", WorkflowState.bpr.value],
  ["DPR", WorkflowState.dpr.value],
  ["INACTIVE", "Inactive Booking"],
  ["CANCELLED", "Cancel Booking"],
  ["CPA", WorkflowState.cpa.value],
  ["LPA", WorkflowState.lpa.value],
];
