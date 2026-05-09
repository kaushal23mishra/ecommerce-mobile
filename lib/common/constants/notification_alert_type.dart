import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';

enum NotificationAlertType {
  campaignCCLeadAssigned('campaign_cc_lead_assigned'),
  campaignHOLeadAssigned('campaign_ho_lead_assigned'),
  exchangeEvaluationPending('exchange_evaluation_pending'),
  leadDuplicate('lead_duplicate'),
  leadLostApproval('lead_lost_approval'),
  leadLostApprovalResponse('lead_lost_approval_response'),
  leadLostRegistered('lead_lost_registered'),
  leadLostRegisteredNTransferred('lead_lost_registered_n_transferred'),
  leadReassigned('leadreassigned'),
  leadTransfer('lead_transfer'),
  leadTransferResponse('lead_transfer_response'),
  smLeadTransfer('sm_lead_transfer'),
  bookingCancelRequest('bookingcancelrequest'),
  bookingCancelResponse('bookingcancelresponse'),
  deliveryApprovalDiscountApproval('deliveryapprovaldiscount_approval'),
  deliveryApprovalNormal('deliveryapprovalnormal'),
  deliveryApprovalResponse('deliveryapprovalresponse'),
  discountApproval('discountapproval'),
  discountApprovalResponse('discountapprovalresponse'),
  exchangeEvaluationCompleted('exchange_evaluation_completed'),
  exchangeLeadGeneratedInHouse('Exchange lead GenratedIn-House'),
  exchangeLeadGeneratedNo('Exchange lead GenratedNo'),
  exchangeLeadGeneratedOutHouse('Exchange lead GenratedOut-House'),
  followup('followup'),
  pendingLeadTransfer('pending_lead_transfer'),
  announcement('announcement');

  final String value;

  const NotificationAlertType(this.value);
}

NotificationAlertType? fromValue(String? value) {
  return NotificationAlertType.values.firstWhereOrNull((e) => e.value == value);
}
