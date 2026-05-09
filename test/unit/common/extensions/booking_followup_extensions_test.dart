import 'package:flutter_test/flutter_test.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/extensions/request_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/features/followup/presentation/components/call_status_mode.dart';

void main() {
  group('booking close followup requests', () {
    const lead = Lead(
      id: 8,
      workflow: Workflow(actions: [LeadAction(id: 12, status: 1)]),
    );

    test('uses booking cancellation reason without exposing it in manual list', () {
      final request = lead.cancelBookingCloseFollowupRequest();

      expect(request.leadId, 8);
      expect(request.workflowId, 12);
      expect(request.status, '1');
      expect(request.notDoneReason, FollowupReasonState.bookingCancelled.value);
      expect(
        followupReasonStateList,
        isNot(contains(FollowupReasonState.bookingCancelled.value)),
      );
    });

    test('uses booking inactive reason without exposing it in manual list', () {
      final request = lead.inactiveBookingCloseFollowupRequest();

      expect(request.leadId, 8);
      expect(request.workflowId, 12);
      expect(request.status, '1');
      expect(request.notDoneReason, FollowupReasonState.bookingInactivated.value);
      expect(
        followupReasonStateList,
        isNot(contains(FollowupReasonState.bookingInactivated.value)),
      );
    });
  });

  group('workflow followup labels', () {
    test('maps booking call action case-insensitively', () {
      const workflow = Workflow(
        actions: [LeadAction(action: 'BOOKING_CALL', status: 1)],
      );

      expect(workflow.followupType, 'Booking Call on');
    });

    test('maps dealer visit action case-insensitively', () {
      const workflow = Workflow(
        actions: [LeadAction(action: 'dealer visit', status: 1)],
      );

      expect(workflow.followupType, 'Showroom visit on');
    });

    test('keeps unknown action casing in fallback label', () {
      const workflow = Workflow(
        actions: [LeadAction(action: 'Home visit', status: 1)],
      );

      expect(workflow.followupType, 'Home visit on');
    });
  });
}
