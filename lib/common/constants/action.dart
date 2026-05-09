import 'package:salesdocket_mobile/common/constants/constant.dart';

class LeadListItemMenuAction extends Constant<String> {
  const LeadListItemMenuAction(super.val);

  static const call = LeadListItemMenuAction('Call');
  // static const message = LeadListItemMenuAction('Message');
  // static const whatsapp = LeadListItemMenuAction('WhatsApp');
  // static const email = LeadListItemMenuAction('Email');
  static const transferLead = LeadListItemMenuAction('Transfer Lead');
  static const followupHistory = LeadListItemMenuAction('Followup History');
  static const testDrive = LeadListItemMenuAction('Test Drive');
  static const cancelBooking = LeadListItemMenuAction('Cancel Booking');
  static const inactiveBooking = LeadListItemMenuAction('Inactive Booking');
  static const paymentReceipt = LeadListItemMenuAction('Receipt');
  static const addDeliveryReceipt = LeadListItemMenuAction('Add Receipt');
  static const viewDeliveryReceipt = LeadListItemMenuAction('View Receipt');
  static const reactivate = LeadListItemMenuAction('Reactivate');
  static const validate = LeadListItemMenuAction('Validate');
  static const bookingFollowup = LeadListItemMenuAction('Booking Followup');
}

class LeadListMenuMoreAction extends Constant<String> {
  const LeadListMenuMoreAction(super.val);

  static const downloadExcel = LeadListMenuMoreAction('Download Excel');
  static const transferLeads = LeadListMenuMoreAction('Transfer Leads');
}

class MediaItemMenuAction extends Constant<String> {
  const MediaItemMenuAction(super.val);

  static const gallery = MediaItemMenuAction('Gallery');
  static const camera = MediaItemMenuAction('Camera');
  static const preview = MediaItemMenuAction('Preview');
  static const remove = MediaItemMenuAction('Remove');
}
