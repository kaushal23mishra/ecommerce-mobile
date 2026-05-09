import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/follow_up_plan_type.dart';
import 'package:salesdocket_mobile/common/constants/lead_state.dart';
import 'package:salesdocket_mobile/common/constants/workflow_state.dart';

class LeadListRequestUtils {
  static final GetLeadRequest hotLeads = GetLeadRequest(
    leadState: LeadState.hot.value.toLowerCase(),
    orderBy: "date",
  );

  static final GetLeadRequest warmLeads = GetLeadRequest(
    leadState: LeadState.warm.value.toLowerCase(),
    orderBy: "date",
  );

  static final GetLeadRequest coldLeads = GetLeadRequest(
    leadState: LeadState.cold.value.toLowerCase(),
    orderBy: "date",
  );

  static final GetLeadRequest activeBookings = GetLeadRequest(
    leadStatus: WorkflowState.booked.value.toLowerCase(),
    orderBy: "date",
  );

  static final GetLeadRequest deliveries = GetLeadRequest(
    leadStatus: WorkflowState.delivered.value.toLowerCase(),
    orderBy: "date",
  );

  static final GetLeadRequest lostLeads = GetLeadRequest(
    leadStatus: WorkflowState.lost.value.toLowerCase(),
    // isLocked: "0",
    orderBy: "date",
  );

  static final GetLeadRequest lpa = GetLeadRequest(
    leadStatus: WorkflowState.lpa.value.toUpperCase(),
    // isLocked: "0",
    orderBy: "date",
  );

  static final GetLeadRequest epr = GetLeadRequest(
    leadStatus: WorkflowState.epr.value.toLowerCase(),
    orderBy: "date",
  );
  static final GetLeadRequest registered = GetLeadRequest(
    leadStatus: WorkflowState.registered.value.toLowerCase(),
    orderBy: "date",
  );

  static final GetLeadRequest closed = GetLeadRequest(
    leadStatus: WorkflowState.closed.value.toLowerCase(),
    // isLocked: "0",
    orderBy: "date",
  );

  static final GetLeadRequest bpr = GetLeadRequest(
    leadStatus: WorkflowState.bpr.value.toUpperCase(),
    orderBy: "date",
  );

  static final GetLeadRequest cpa = GetLeadRequest(
    leadStatus: WorkflowState.cpa.value.toUpperCase(),
    // isLocked: "0",
    orderBy: "date",
  );

  static final GetLeadRequest inactiveBooking = GetLeadRequest(
    leadStatus: WorkflowState.inactive.value.toUpperCase(),
    orderBy: "date",
  );

  static final GetLeadRequest cancelledBooking = GetLeadRequest(
    leadStatus: WorkflowState.cancelled.value.toUpperCase(),
    orderBy: "date",
  );

  static final GetLeadRequest dpr = GetLeadRequest(
    leadStatus: WorkflowState.dpr.value.toUpperCase(),
    orderBy: "date",
  );

  static const GetLeadRequest transferredLeads = GetLeadRequest(
    transferredLeadsOnly: "yes",
    orderBy: "date",
  );

  static const GetLeadRequest call = GetLeadRequest(
    onlyDue: true,
    orderBy: "date",
    followup: 'call',
    // isLocked: '0',
  );

  static const GetLeadRequest homeVisit = GetLeadRequest(
    onlyDue: true,
    orderBy: "date",
    followup: 'home visit',
    // isLocked: "0",
  );

  static const GetLeadRequest showroomVisit = GetLeadRequest(
    onlyDue: true,
    orderBy: "date",
    followup: 'dealer visit',
  );

  static const GetLeadRequest hoLead = GetLeadRequest(
    isCampaign: "yes",
    orderBy: "date",
    leadStatus: 'epr',
    isLocked: "1",
  );

  static const GetLeadRequest coldCalling = GetLeadRequest(
    leadType: "cc_leads",
    orderBy: 'date',
    transferredLeadsOnly: 'yes',
  );

  static const GetLeadRequest allLeads = GetLeadRequest(
    allLeads: "",
    orderBy: "date",
  );

  static const GetLeadRequest activeNoTestDrive = GetLeadRequest(
    orderBy: "date",
    leadStatus: 'epr,registered',
    isTestDriveGiven: "no",
  );
  static const GetLeadRequest epe = GetLeadRequest(
    orderBy: "date",
    exchangeStatus: "EPE",
  );
  static const GetLeadRequest ec = GetLeadRequest(
    orderBy: "date",
    exchangeStatus: "EC",
  );
  static final GetLeadRequest bookingFollowup = GetLeadRequest(
    onlyDue: true,
    orderBy: "date",
    followup: FollowUpPlanType.bookingCall.value,
  );
}
