import 'package:salesdocket_mobile/common/constants/constant.dart';

class FormFields extends Constant<String> {
  const FormFields(super.value);
}

class LeadFormFields extends FormFields {
  const LeadFormFields(super.value);

  static const selectModel = LeadFormFields('Select Model');
  static const selectEngineType = LeadFormFields('Select Engine Type');
  static const selectVariant = LeadFormFields('Select Variant');
  static const selectCarColor = LeadFormFields('Select Car Color');

  static const firstTimeBuyerStatus = LeadFormFields('First Time Buyer Status');
  static const selectBrand = LeadFormFields('Select Brand');
  static const selectBrandModel = LeadFormFields('Select Brand Model');
  static const selectModelYear = LeadFormFields('Select Model Year');
  static const ownership = LeadFormFields('Ownership');
  static const insuranceValidity = LeadFormFields('Insurance Validity');
  static const mileage = LeadFormFields('Mileage');
  static const registrationNumber = LeadFormFields('Registration Number');
  static const expectedPrice = LeadFormFields('Expected Price');
  static const quotedPrice = LeadFormFields('Quoted Price');
  static const dateOfEvaluation = LeadFormFields('Date Of Evaluation');

  static const fullName = LeadFormFields('Full Name');
  static const contactDetails = LeadFormFields('Contact Details');
  static const emailId = LeadFormFields('Email ID');

  static const district = LeadFormFields('District');
  static const location = LeadFormFields('Location');
  static const state = LeadFormFields('State');
  static const addressLineOne = LeadFormFields('Address Line 1');
  static const addressLineTwo = LeadFormFields('Address Line 2');

  static const leadSource = LeadFormFields('Lead Source');
  static const sourceOfLead = LeadFormFields('Source of Lead');
  static const othersReason = LeadFormFields('Others Reason');

  static const planFollowUp = LeadFormFields('Plan Follow Up');
  static const followUpDateTime = LeadFormFields('Follow-up Date & Time');
  static const rescheduleReason = LeadFormFields('Reschedule Reason');

  static const dateOfEnquiry = LeadFormFields('Date of Enquiry');

  static const typeOfCustomer = LeadFormFields('Type of Customer');
  static const corporateName = LeadFormFields('Corporate Name');
  static const profession = LeadFormFields('Profession');

  static const dateOfBirth = LeadFormFields('Exchange');


  static const testDriveGiven = LeadFormFields('Test Drive Given');
  static const notGivenReason = LeadFormFields('Not Given Reason');
  static const notGivenOtherReason = LeadFormFields('Not Given Other Reason');
  static const testDriveGivenWhen = LeadFormFields('Test Drive Given When');
  static const testDriveGivenVehicle = LeadFormFields(
    'Test Drive Given Vehicle',
  );
  static const testDriveGivenToWhom = LeadFormFields(
    'Test Drive Given To Whom',
  );

  static const modeOfPurchase = LeadFormFields('Mode Of Purchase');

  static const interestedInComp = LeadFormFields('Interested In Competition');
  static const compBrand = LeadFormFields('Competition Brand');
  static const compModel = LeadFormFields('Competition Model');

  static const exchange = LeadFormFields('Exchange');
  static const finance = LeadFormFields('Finance');
  static const leadStatus = LeadFormFields('Lead Status');
  static const remarks = LeadFormFields('Remarks');

  static const financeType = LeadFormFields('Finance Type');
  static const selectBank = LeadFormFields('Select Bank');
  static const otherBank = LeadFormFields('Other Bank');
  static const bankPayout = LeadFormFields('Bank Payout');
  static const dsaName = LeadFormFields('DSA Name');
  static const dsaMobile = LeadFormFields('DSA Mobile');
  static const disbursalAmount = LeadFormFields('Disbursal Amount');
  static const financeReason = LeadFormFields('Finance Reason');
  static const financeTypeOther = LeadFormFields('Finance Type Other');

  static const exchangeType = LeadFormFields('Exchange Type');
  static const exchangeReason = LeadFormFields('Exchange Reason');
  static const exchangeApproxValue = LeadFormFields('Exchange Approx Value');
  static const exchangeOtherReason = LeadFormFields('Exchange Other Reason');
  static const exchangePurchasePrice = LeadFormFields(
    'Exchange Purchase Price',
  );
  static const exchangePurchasePriceAdjust = LeadFormFields(
    'Exchange Purchase Price Adjust',
  );

  static const expectedDeliveryDate = LeadFormFields('Expected Delivery Date');
  static const amountCollected = LeadFormFields('Amount Collected');
  static const dateOfBooking = LeadFormFields('Date Of Booking');

  static const creditGivenToTheCustomer = LeadFormFields(
    'Credit given to the customer',
  );
  static const amountPending = LeadFormFields('Amount Pending');
  static const permittedBy = LeadFormFields('Permitted By');
  static const expectedDateOfPayment = LeadFormFields(
    'Expected Date Of Payment',
  );











  static const reasonToSelectBrand = LeadFormFields('Reason To Select Brand');
  static const reasonToSelectBrandOther = LeadFormFields(
    'Reason To Select Brand Other',
  );
  static const dateOfDelivery = LeadFormFields('Date of Delivery');
  static const chasisNumber = LeadFormFields('Chasis Number');
  static const pendingCommitment = LeadFormFields('Pending Commitment');
  static const customerPic = LeadFormFields('Customer Picture');
  static const paymentDoc = LeadFormFields('Payment Document');

  static const customerTookQuote = LeadFormFields('Customer Took Quote');
  static const quoteDate = LeadFormFields('Quote Date');
  static const oldCarPayment = LeadFormFields('Old Car Payment');
  static const agentName = LeadFormFields('Agent Name');
  static const agentNumber = LeadFormFields('Agent Number');
  static const poPhoto = LeadFormFields('PO Photo');
  static const doPhoto = LeadFormFields('DO Photo');
}

class BrokerFormFields extends FormFields {
  const BrokerFormFields(super.value);

  static const name = BrokerFormFields('Broker Name');
  static const city = BrokerFormFields('Broker City');
  static const mobile = BrokerFormFields('Broker Mobile');
  static const amount = BrokerFormFields('Broker Amount');
}

class ReceiptFormFields extends FormFields {
  const ReceiptFormFields(super.value);

  static const receiptName = ReceiptFormFields('Receipt Name');
  static const receiptDate = ReceiptFormFields('Receipt Date');
  static const receiptAmount = ReceiptFormFields('Receipt Amount');
  static const receiptModeOfPayment = ReceiptFormFields(
    'Receipt Mode of Payment',
  );
  static const receiptPermittedBy = ReceiptFormFields('Cheque Permitted By');
  static const receiptPaymentType = ReceiptFormFields('Type of Pending Amount');
}

class DiscountFormFields extends FormFields {
  const DiscountFormFields(super.value);

  static const discountReasons = DiscountFormFields('Discount Reasons');
  static const otherDiscountReason = DiscountFormFields(
    'Other Discount Reason',
  );
  static const sentTo = DiscountFormFields('Sent To');
  static const rejectReason = DiscountFormFields('Reject Reason');
  static const otherReason = DiscountFormFields('Other Reason');
  static const pendingCommitments = DiscountFormFields('Pending Commitments');
  static const optionalRemarks = DiscountFormFields('Optional Remarks');
  static const discountPermittedBy = DiscountFormFields(
    'Discount Permitted By',
  );
}

class CancelBookingFormFields extends FormFields {
  const CancelBookingFormFields(super.value);

  static const reasonOfCancellation = CancelBookingFormFields(
    'Reason Of Cancellation',
  );
  static const otherCancellationReason = CancelBookingFormFields(
    'Other Cancellation Reason',
  );
  static const cancellationCharges = CancelBookingFormFields(
    'Cancellation Charges',
  );
  static const sentTo = CancelBookingFormFields('Sent To');
}

class InactiveBookingFormFields extends FormFields {
  const InactiveBookingFormFields(super.value);

  static const inactiveBookingReasons = InactiveBookingFormFields(
    'Inactive Booking Reasons',
  );
  static const otherInactiveBookingReason = InactiveBookingFormFields(
    'Other Inactive Booking Reason',
  );
}

class CreateFollowUpFormFields extends FormFields {
  const CreateFollowUpFormFields(super.value);

  static const visitDate = CreateFollowUpFormFields('Visit Date');
  static const callStatus = CreateFollowUpFormFields('Call Status');
  static const test = CreateFollowUpFormFields('Test');
  static const nextAction = CreateFollowUpFormFields('Next Action');
  static const newLeadStatus = CreateFollowUpFormFields('New Lead Status');
  static const ccLeadLeadStatus = CreateFollowUpFormFields('CC Lead Status');
  static const testDriveGiven = CreateFollowUpFormFields('Test Drive Given');
  static const incorrectNumber = CreateFollowUpFormFields('Incorrect Number');
  static const lostToCompetitionReason = CreateFollowUpFormFields(
    'Lost To Competition Reason',
  );
  static const leadCategory = CreateFollowUpFormFields('Lead Category');
  static const lostTo = CreateFollowUpFormFields('Lost To');
  static const brand = CreateFollowUpFormFields('Brand');
  static const nextFollowup = CreateFollowUpFormFields('Next Followup');
  static const coDealerName = CreateFollowUpFormFields('Co-Dealer Name');
  static const remarks = CreateFollowUpFormFields('Remarks');
  static const selectBrand = CreateFollowUpFormFields('Select Brand');
  static const toWhom = CreateFollowUpFormFields('To Whom');
  static const selectModel = CreateFollowUpFormFields('Select Model');
  static const closedReason = CreateFollowUpFormFields('Closed Reason');
  static const otherClosedReason = CreateFollowUpFormFields('Other Closed Reason');
  static const otherCompetitionReason = CreateFollowUpFormFields('Other Competition Reason');
  static const when = CreateFollowUpFormFields('When');
  static const expectedMonthOfConversion = CreateFollowUpFormFields(
    'Expected Month Of Conversion',
  );
}

class SendDocumentFormFields extends FormFields {
  const SendDocumentFormFields(super.value);

  static const sendType = SendDocumentFormFields('Send Type');
  static const documents = SendDocumentFormFields('Documents');
}
