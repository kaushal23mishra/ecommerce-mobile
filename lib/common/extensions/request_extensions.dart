import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/contact_type.dart';
import 'package:salesdocket_mobile/common/constants/customer_type.dart';
import 'package:salesdocket_mobile/common/constants/first_time_buyer_state.dart';
import 'package:salesdocket_mobile/common/constants/follow_up_plan_type.dart';
import 'package:salesdocket_mobile/common/constants/interested_in_exchange_state.dart';
import 'package:salesdocket_mobile/common/constants/purchase_mode.dart';
import 'package:salesdocket_mobile/common/constants/receipt.dart';
import 'package:salesdocket_mobile/common/constants/customer_quote_state.dart';
import 'package:salesdocket_mobile/common/entity/credit_given.dart';
import 'package:salesdocket_mobile/common/entity/customer_quote.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/entity/followup_data_given.dart';
import 'package:salesdocket_mobile/common/entity/interested_in_comp.dart';
import 'package:salesdocket_mobile/common/entity/old_car_payment.dart';
import 'package:salesdocket_mobile/common/entity/personal_details_images.dart';
import 'package:salesdocket_mobile/common/entity/lead_source.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/features/followup/presentation/components/call_status_mode.dart';
import 'package:salesdocket_mobile/common/extensions/discount_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';

extension CreateLeadRequestExtension on CreateLeadRequest {
  CreateLeadRequest createRequest({Lead? duplicateLead}) {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );
    final phone =
        contactDetails
            ?.whereOrNull((contact) => contact.type != ContactType.email.value)
            ?.map(
              (detail) =>
                  ContactDetails(number: detail.value, type: detail.type),
            )
            .toList();
    final email =
        contactDetails
            ?.whereOrNull((contact) => contact.type == ContactType.email.value)
            ?.map(
              (detail) =>
                  ContactDetails(email: detail.value, type: detail.type),
            )
            .toList();

    return copyWith(
      phone: phone,
      email: email,
      actorId: user?.id,
      duplicateLeadInOutlet: duplicateLead != null,
      contactDetails: null,
      model: null,
      modelName: null,
      engineType: null,
      variants: null,
      primaryVariantId: variants?.firstOrNull?.id,
      followUpPlan:
          followUpPlan == FollowUpPlanType.showroomVisit.value
              ? FollowUpPlanType.dealerVisit.value
              : followUpPlan,
      variant:
          (variants
                      ?.whereOrNull((variant) => variant.id != null)
                      ?.map((variant) => variant.id!) ??
                  [])
              .toList(),
    );
  }
}

extension LeadProspectRequestExtension on Lead {
  Lead prospectPersonalDetailsRequest({
    List<ContactDetails> newContactDetails = const [],
  }) {
    final oldPhoneNumbers = phoneNumbers ?? [];
    final oldEmails = emails ?? [];
    final newPhoneNumbers = <LeadPhoneNumber>[].toList();
    final newEmails = <LeadEmail>[].toList();

    for (var contact in newContactDetails) {
      if (contact.type == ContactType.email.value) {
        final indexOf = oldEmails.indexWhere(
          (email) => email.emailId == contact.value,
        );
        if (indexOf != -1) {
          newEmails.add(oldEmails[indexOf]);
        } else {
          newEmails.add(
            LeadEmail(emailId: contact.value, emailType: contact.type),
          );
        }
      } else {
        final indexOf = oldPhoneNumbers.indexWhere(
          (phone) =>
              phone.phoneNumber == contact.value &&
              phone.phoneType == contact.type,
        );
        if (indexOf != -1) {
          newPhoneNumbers.add(oldPhoneNumbers[indexOf]);
        } else {
          newPhoneNumbers.add(
            LeadPhoneNumber(
              phoneNumber: contact.value,
              phoneType: contact.type,
            ),
          );
        }
      }
    }

    return Lead(
      salutation: salutation,
      firstName: firstName,
      lastName: lastName,
      phoneNumbers: newPhoneNumbers,
      emails: newEmails,
      customerType: customerType,
      corporateName:
          customerType == CustomerType.corporate.value ? corporateName : "",
      profession: profession,
      otherProfession: otherProfession,
      dob: dob,
    );
  }

  Lead prospectBuyingDetailsRequest({
    List<InterestedVariant> newSelectedCars = const [],
    InterestedColor? newCarColor,
    TestDriveGiven? newTestDrive,
    InterestedInComp? newInterestedInComp,
    FirstTimeBuyer? newFirstTimeBuyer,
    CustomerQuote? newCustomerQuote,
    LeadSource? newLeadSource,
  }) {
    return Lead(
      primaryVariantId: newSelectedCars.firstOrNull?.id,
      variants: newSelectedCars.map((car) => car.id ?? 0).toList(),
      colorIds: [newCarColor?.id ?? 0],
      purchaseMode: purchaseMode,
      isExistingVehicle: newFirstTimeBuyer?.isExistingVehicle,
      isExchange:
          newFirstTimeBuyer?.isExistingVehicle == FirstTimeBuyerState.yes.value
              ? InterestedInExchangeState.no.value
              : InterestedInExchangeState.yes.value,
      oldVehicleId: newFirstTimeBuyer?.oldVehicleVariantId,
      oldVehicleMakeYear: newFirstTimeBuyer?.oldVehicleMakeYear,
      interestedCompetitionModelId: newInterestedInComp?.model,
      interestedInCompetition: newInterestedInComp?.status,
      isTestDriveGiven: newTestDrive?.given,
      sentQuote:
          newCustomerQuote?.tookQuote == CustomerQuoteState.yes.value
              ? 1
              : newCustomerQuote?.tookQuote == CustomerQuoteState.no.value
              ? 0
              : null,
      quoteDate:
          newCustomerQuote?.tookQuote == CustomerQuoteState.yes.value
              ? newCustomerQuote?.quoteDate
              : null,
      leadSource: newLeadSource?.source,
      sourceOfInformation: newLeadSource?.information,
      otherSourceOfInformation: newLeadSource?.otherReason,
      referralName: newLeadSource?.referralName,
      referralNumber: newLeadSource?.referralNumber,
    );
  }

  Lead prospectExchangeDetailsRequest() {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );
    return Lead(
      isExchange: isExchange,
      isExistingVehicle:
          isExchange == InterestedInExchangeState.yes.value
              ? FirstTimeBuyerState.no.value
              : FirstTimeBuyerState.yes.value,
      exchangeStatus:
          exchangeStatus == 'EC'
              ? 'EC'
              : user!.isEvaluator
              ? 'EC'
              : 'EPE',
    );
  }

  CreateQuotationRequest createQuotationRequest({
    List<Price> newOffers = const [],
    Quotation? quotation,
    String? quotationType,
  }) {
    final items =
        newOffers
            .map(
              (offer) => QuotationItem(
                description: offer.name,
                amount:
                    (offer.ngnc ?? false) || (offer.foc ?? false)
                        ? 0
                        : offer.amount,
                discount:
                    (offer.ngnc ?? false) || (offer.foc ?? false)
                        ? 0
                        : offer.discount,
                propertyType: offer.priceGroup,
                propertyId: offer.id,
                freeFlag:
                    (offer.ngnc ?? false) ||
                            (offer.foc ?? false) ||
                            (offer.free ?? false)
                        ? 1
                        : 0,
                schemeType: (offer.upfront ?? false) ? 1 : 0,
              ),
            )
            .toList();
    final totalCost = newOffers.totalCost;

    final totalDiscount = newOffers.totalDiscount;

    return CreateQuotationRequest(
      items: items,
      colorId: interestedColorId,
      rowCount: items.length,
      leadId: id,
      variantId: primaryVariantId,
      quotationType: quotationType,
      totalCost: totalCost,
      totalOffer: totalDiscount,
      remark: quotation?.remark ?? "",
      finalOfferPrice: totalCost - totalDiscount,
    );
  }

  LeadFollowupRequest updateFollowupRequest() {
    final followup = followups?.lastOrNull;
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    return LeadFollowupRequest(
      workflowId: workflow?.actions?.lastOrNull?.id,
      followUpPlan:
          followup?.followupType == FollowUpPlanType.showroomVisit.value
              ? FollowUpPlanType.dealerVisit.value
              : followup?.followupType,
      followUpDateTime: followup?.followupDueAt,
      actorId: user?.id,
      comments: "",
      editReason: "",
    );
  }

  ChangeLeadStatusRequest changeLeadStatusRequest() {
    return const ChangeLeadStatusRequest(leadStatus: "REGISTERED");
  }

  CreateLeadHistoryRequest createPlanFollowupLeadHistoryRequest({
    CreateLeadHistoryRequest? followupPlan,
  }) {
    return CreateLeadHistoryRequest(
      responseType: "registration_comment",
      remarks: followupPlan?.remarks,
      leadStatus: leadState,
    );
  }

  LeadFollowupRequest createReschedulePlanFollowupRequest({
    LeadFollowupRequest? newFollowupPlan,
  }) {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );
    return LeadFollowupRequest(
      actorId: user?.id,
      workflowId: workflow?.followupAction?.id,
      followUpPlan:
          newFollowupPlan?.followUpPlan == FollowUpPlanType.showroomVisit.value
              ? FollowUpPlanType.dealerVisit.value
              : newFollowupPlan?.followUpPlan,
      followUpDateTime: newFollowupPlan?.followUpDateTime,
      editReason: newFollowupPlan?.editReason,
    );
  }
}

extension LeadBookingRequestExtension on Lead {
  Lead bookingPersonalDetailsRequest({
    List<ContactDetails> newContactDetails = const [],
  }) {
    return Lead(
      customerType: customerType,
      corporateName:
          customerType == CustomerType.corporate.value ? corporateName : "",
      dob: dob,
    );
  }

  Lead bookingBuyingDetailsRequest({
    List<InterestedVariant> newSelectedCars = const [],
    InterestedColor? newCarColor,
    TestDriveGiven? newTestDrive,
    InterestedInComp? newInterestedInComp,
    FirstTimeBuyer? newFirstTimeBuyer,
  }) {
    return Lead(
      primaryVariantId: newSelectedCars.firstOrNull?.id,
      variants: newSelectedCars.map((car) => car.id ?? 0).toList(),
      colorIds: [newCarColor?.id ?? 0],
      purchaseMode: purchaseMode,
      isExistingVehicle: newFirstTimeBuyer?.isExistingVehicle,
      isExchange:
          newFirstTimeBuyer?.isExistingVehicle == FirstTimeBuyerState.yes.value
              ? InterestedInExchangeState.no.value
              : InterestedInExchangeState.yes.value,
      oldVehicleId: newFirstTimeBuyer?.oldVehicleVariantId,
      oldVehicleMakeYear: newFirstTimeBuyer?.oldVehicleMakeYear,
      interestedCompetitionModelId: newInterestedInComp?.model,
      interestedInCompetition: newInterestedInComp?.status,
      isTestDriveGiven: newTestDrive?.given,
    );
  }

  Lead bookingExchangeDetailsRequest() {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );
    return Lead(
      isExchange: isExchange,
      isExistingVehicle:
          isExchange == InterestedInExchangeState.yes.value
              ? FirstTimeBuyerState.no.value
              : FirstTimeBuyerState.yes.value,
      exchangeStatus:
          exchangeStatus == 'EC'
              ? 'EC'
              : user!.isEvaluator
              ? 'EC'
              : 'EPE',
    );
  }

  Booking exchangeCreateBookingRequest({
    ExchangeHouseRequest? newExchangeHouseDetails,
  }) {
    final bookingPhoneNumbers =
        (phoneNumbers ?? []) +
        (emails ?? [])
            .map(
              (email) => LeadPhoneNumber(
                id: email.id,
                phoneNumber: email.emailId,
                phoneType: ContactType.email.value,
              ),
            )
            .toList();

    Booking newBooking = Booking(
      leadId: id,
      salutation: salutation,
      firstName: firstName,
      lastName: lastName,
      exchangeType: newExchangeHouseDetails?.exchangeType,
      bookingPhoneNumbers: bookingPhoneNumbers,
    );

    if (newExchangeHouseDetails?.exchangeType == ExchangeType.outHouse.value) {
      newBooking = newBooking.copyWith(
        exchangeOuthouse: "EXCHANGE_OUTHOUSE",
        exchangeReason: [newExchangeHouseDetails?.reason ?? ""],
        exchangeBetterValue: newExchangeHouseDetails?.approxValue,
        exchangeOtherReason: newExchangeHouseDetails?.otherReason,
      );
    }

    return newBooking;
  }

  Booking exchangeUpdateBookingRequest({
    ExchangeHouseRequest? newExchangeHouseDetails,
  }) {
    Booking newBooking = Booking(
      leadId: id,
      salutation: booking?.salutation,
      firstName: booking?.firstName,
      lastName: booking?.lastName,
      exchangeType: newExchangeHouseDetails?.exchangeType,
    );

    if (newExchangeHouseDetails?.exchangeType == ExchangeType.outHouse.value) {
      newBooking = newBooking.copyWith(
        exchangeOuthouse: "EXCHANGE_OUTHOUSE",
        exchangeReason: [newExchangeHouseDetails?.reason ?? ""],
        exchangeBetterValue: newExchangeHouseDetails?.approxValue,
        exchangeOtherReason: newExchangeHouseDetails?.otherReason,
      );
    }

    return newBooking;
  }

  Lead bookingFormRequest({Booking? newBookingDetails}) {
    return Lead(bookingDate: newBookingDetails?.bookingDate);
  }

  Booking bookingFormCreateBookingRequest({Booking? newBookingDetails}) {
    final bookingPhoneNumbers =
        (phoneNumbers ?? []) +
        (emails ?? [])
            .map(
              (email) => LeadPhoneNumber(
                id: email.id,
                phoneNumber: email.emailId,
                phoneType: ContactType.email.value,
              ),
            )
            .toList();

    Booking newBooking = Booking(
      leadId: id,
      salutation: salutation,
      firstName: firstName,
      lastName: lastName,
      amountCollected: newBookingDetails?.amountCollected,
      bookingDate: newBookingDetails?.bookingDate,
      expectedDelivery: newBookingDetails?.expectedDelivery,
      bookingPhoneNumbers: bookingPhoneNumbers,
    );

    return newBooking;
  }

  Booking bookingFormUpdateBookingRequest({Booking? newBookingDetails}) {
    Booking newBooking = Booking(
      leadId: id,
      salutation: booking?.salutation,
      firstName: booking?.firstName,
      lastName: booking?.lastName,
      amountCollected: newBookingDetails?.amountCollected,
      bookingDate: newBookingDetails?.bookingDate,
      expectedDelivery: newBookingDetails?.expectedDelivery,
    );

    return newBooking;
  }

  CreateLeadHistoryRequest bookingCloseFollowupRequest() {
    return CreateLeadHistoryRequest(
      responseType: "",
      workflowId: workflow?.actions?.firstOrNull?.id,
      status: "2",
      leadId: id,
      when: "",
      toWhom: "",
      notDoneReason: FollowupReasonState.alreadyBooked.value,
    );
  }

  ChangeLeadStatusRequest bookingFormChangeLeadStatusRequest() {
    return const ChangeLeadStatusRequest(leadStatus: "BOOKED");
  }

  ChangeLeadStatusRequest bookingDiscountApprovalChangeLeadStatusRequest() {
    return const ChangeLeadStatusRequest(leadStatus: "BPR");
  }

  CreateLeadHistoryRequest bookingDiscountApprovalLeadHistoryRequest() {
    return CreateLeadHistoryRequest(
      responseType: "discount_approval",
      workflowId: workflow?.actions?.firstOrNull?.id,
      status: "1",
      leadId: id,
      leadStatus: "BPR",
      remarks: "Sent for discount approval",
    );
  }

  ChangeLeadStatusRequest deliveryFormChangeLeadStatusRequest() {
    return const ChangeLeadStatusRequest(leadStatus: "DELIVERED");
  }

  ChangeLeadStatusRequest deliveryDiscountApprovalChangeLeadStatusRequest() {
    return const ChangeLeadStatusRequest(leadStatus: "DPR");
  }

  CreateLeadHistoryRequest deliveryCloseFollowupRequest() {
    return CreateLeadHistoryRequest(
      responseType: "",
      workflowId: workflow?.actions?.firstOrNull?.id,
      status: "1",
      leadId: id,
      when: "",
      toWhom: "",
      notDoneReason: FollowupReasonState.alreadyBooked.value,
    );
  }

  CreateLeadHistoryRequest cancelBookingCloseFollowupRequest() {
    return CreateLeadHistoryRequest(
      responseType: "",
      workflowId: workflow?.actions?.firstOrNull?.id,
      status: "1",
      leadId: id,
      when: "",
      toWhom: "",
      notDoneReason: FollowupReasonState.bookingCancelled.value,
    );
  }

  CreateLeadHistoryRequest inactiveBookingCloseFollowupRequest() {
    return CreateLeadHistoryRequest(
      responseType: "",
      workflowId: workflow?.actions?.firstOrNull?.id,
      status: "1",
      leadId: id,
      when: "",
      toWhom: "",
      notDoneReason: FollowupReasonState.bookingInactivated.value,
    );
  }
}

extension LeadDeliveryRequestExtension on Lead {
  Lead deliveryPersonalDetailsRequest({
    List<ContactDetails> newContactDetails = const [],
  }) {
    return Lead(
      customerType: customerType,
      corporateName:
          customerType == CustomerType.corporate.value ? corporateName : "",
      dob: dob,
    );
  }

  Lead deliveryBuyingDetailsRequest({
    List<InterestedVariant> newSelectedCars = const [],
    InterestedColor? newCarColor,
    TestDriveGiven? newTestDrive,
    InterestedInComp? newInterestedInComp,
    FirstTimeBuyer? newFirstTimeBuyer,
  }) {
    return Lead(
      primaryVariantId: newSelectedCars.firstOrNull?.id,
      variants: newSelectedCars.map((car) => car.id ?? 0).toList(),
      colorIds: [newCarColor?.id ?? 0],
      purchaseMode: purchaseMode,
      isExistingVehicle: newFirstTimeBuyer?.isExistingVehicle,
      isExchange:
          newFirstTimeBuyer?.isExistingVehicle == FirstTimeBuyerState.yes.value
              ? InterestedInExchangeState.no.value
              : InterestedInExchangeState.yes.value,
      oldVehicleId: newFirstTimeBuyer?.oldVehicleVariantId,
      oldVehicleMakeYear: newFirstTimeBuyer?.oldVehicleMakeYear,
      interestedCompetitionModelId: newInterestedInComp?.model,
      interestedInCompetition: newInterestedInComp?.status,
      isTestDriveGiven: newTestDrive?.given,
    );
  }

  Delivery deliveryBuyingCreateDeliveryRequest({
    CustomerQuote? newCustomerQuote,
  }) {
    final deliveryPhoneNumbers =
        (phoneNumbers ?? []) +
        (emails ?? [])
            .map(
              (email) => LeadPhoneNumber(
                id: email.id,
                phoneNumber: email.emailId,
                phoneType: ContactType.email.value,
              ),
            )
            .toList();

    return Delivery(
      leadId: id,
      salutation: salutation,
      firstName: firstName,
      lastName: lastName,
      deliveryPhoneNumbers: deliveryPhoneNumbers,
      sentQuote:
          newCustomerQuote?.tookQuote == CustomerQuoteState.yes.value
              ? 1
              : newCustomerQuote?.tookQuote == CustomerQuoteState.no.value
              ? 0
              : null,
      quoteDate:
          newCustomerQuote?.tookQuote == CustomerQuoteState.yes.value
              ? newCustomerQuote?.quoteDate
              : null,
    );
  }

  Delivery deliveryBuyingUpdateDeliveryRequest({
    CustomerQuote? newCustomerQuote,
  }) {
    return Delivery(
      leadId: id,
      salutation: delivery?.salutation,
      firstName: delivery?.firstName,
      lastName: delivery?.lastName,
      sentQuote:
          newCustomerQuote?.tookQuote == CustomerQuoteState.yes.value
              ? 1
              : newCustomerQuote?.tookQuote == CustomerQuoteState.no.value
              ? 0
              : null,
      quoteDate:
          newCustomerQuote?.tookQuote == CustomerQuoteState.yes.value
              ? newCustomerQuote?.quoteDate
              : null,
    );
  }

  Lead deliveryExchangeDetailsRequest() {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );
    return Lead(
      isExchange: isExchange,
      isExistingVehicle:
          isExchange == InterestedInExchangeState.yes.value
              ? FirstTimeBuyerState.no.value
              : FirstTimeBuyerState.yes.value,
      exchangeStatus:
          exchangeStatus == 'EC'
              ? 'EC'
              : user!.isEvaluator
              ? 'EC'
              : 'EPE',
    );
  }

  Delivery exchangeCreateDeliveryRequest({
    ExchangeHouseRequest? newExchangeHouseDetails,
  }) {
    final deliveryPhoneNumbers =
        (phoneNumbers ?? []) +
        (emails ?? [])
            .map(
              (email) => LeadPhoneNumber(
                id: email.id,
                phoneNumber: email.emailId,
                phoneType: ContactType.email.value,
              ),
            )
            .toList();

    Delivery newDelivery = Delivery(
      leadId: id,
      salutation: salutation,
      firstName: firstName,
      lastName: lastName,
      exchangeType: newExchangeHouseDetails?.exchangeType,
      deliveryPhoneNumbers: deliveryPhoneNumbers,
    );

    if (newExchangeHouseDetails?.exchangeType == ExchangeType.outHouse.value) {
      newDelivery = newDelivery.copyWith(
        exchangeOuthouse: "EXCHANGE_OUTHOUSE",
        exchangeReason: [newExchangeHouseDetails?.reason ?? ""],
        exchangeBetterValue: newExchangeHouseDetails?.approxValue,
        exchangeOtherReason: newExchangeHouseDetails?.otherReason,
      );
    }

    return newDelivery;
  }

  Delivery exchangeUpdateDeliveryRequest({
    ExchangeHouseRequest? newExchangeHouseDetails,
  }) {
    Delivery newDelivery = Delivery(
      leadId: id,
      salutation: delivery?.salutation,
      firstName: delivery?.firstName,
      lastName: delivery?.lastName,
      exchangeType: newExchangeHouseDetails?.exchangeType,
    );

    if (newExchangeHouseDetails?.exchangeType == ExchangeType.outHouse.value) {
      newDelivery = newDelivery.copyWith(
        exchangeOuthouse: "EXCHANGE_OUTHOUSE",
        exchangeReason: [newExchangeHouseDetails?.reason ?? ""],
        exchangeBetterValue: newExchangeHouseDetails?.approxValue,
        exchangeOtherReason: newExchangeHouseDetails?.otherReason,
      );
    }

    return newDelivery;
  }

  Delivery deliveryPaymentDetailUploadDocumentRequest({
    Delivery? newDeliveryDetails,
  }) {
    return Delivery(
      leadId: id,
      salutation: delivery?.salutation ?? salutation,
      firstName: delivery?.firstName ?? firstName,
      lastName: delivery?.lastName ?? lastName,
      addressId: delivery?.addressId ?? addressId,
      deliveryPhoneNumbers: delivery?.phoneNumbers ?? phoneNumbers,
    );
  }

  Lead deliveryFormRequest({Delivery? newDeliveryDetails}) {
    return Lead(deliveryDate: newDeliveryDetails?.deliveryDate);
  }

  Delivery deliveryFormDeliveryRequest({Delivery? newDeliveryDetails}) {
    var newDelivery = Delivery(
      leadId: id,
      chasisNumber: newDeliveryDetails?.chasisNumber,
      pendingCommitment: newDeliveryDetails?.pendingCommitment,
      deliveryDate: newDeliveryDetails?.deliveryDate,
      referenceTaken: newDeliveryDetails?.referenceTaken,
    );

    final selectReasons =
        (newDeliveryDetails?.reasonForSelectingBrand ?? []).toList();
    final otherSelectReason = newDeliveryDetails?.reasonForSelectingBrandOther;
    if (otherSelectReason != null && otherSelectReason.isNotEmpty) {
      selectReasons.add(otherSelectReason);
    }
    newDelivery = newDelivery.copyWith(reasonForSelectingBrand: selectReasons);

    return newDelivery;
  }

  Delivery deliveryFormCreateDeliveryRequest({Delivery? newDeliveryDetails}) {
    final deliveryPhoneNumbers =
        (phoneNumbers ?? []) +
        (emails ?? [])
            .map(
              (email) => LeadPhoneNumber(
                id: email.id,
                phoneNumber: email.emailId,
                phoneType: ContactType.email.value,
              ),
            )
            .toList();

    return deliveryFormDeliveryRequest(
      newDeliveryDetails: newDeliveryDetails,
    ).copyWith(
      salutation: salutation,
      firstName: firstName,
      lastName: lastName,
      deliveryPhoneNumbers: deliveryPhoneNumbers,
    );
  }

  Delivery deliveryFormUpdateDeliveryRequest({Delivery? newDeliveryDetails}) {
    return deliveryFormDeliveryRequest(
      newDeliveryDetails: newDeliveryDetails,
    ).copyWith(
      salutation: delivery?.salutation,
      firstName: delivery?.firstName,
      lastName: delivery?.lastName,
    );
  }

  Delivery deliveryFormUploadDeliveryDocumentRequest({
    Delivery? newDeliveryDetails,
  }) {
    return Delivery(
      leadId: id,
      salutation: delivery?.salutation,
      firstName: delivery?.firstName,
      lastName: delivery?.lastName,
    );
  }

  Delivery deliveryApprovalRequest({Delivery? newDeliveryDetails}) {
    return Delivery(
      leadId: id,
      salutation: delivery?.salutation,
      firstName: delivery?.firstName,
      lastName: delivery?.lastName,
      pendingCommitment: newDeliveryDetails?.pendingCommitment,
      deliveryRemarks: newDeliveryDetails?.deliveryRemarks,
      discountPermittedBy: newDeliveryDetails?.discountPermittedBy,
    );
  }
}

extension ExchangeProductRequestExtension on ExchangeProduct {
  ExchangeProduct prospectCreateExchangeDetailsRequest({
    Lead? lead,
    FirstTimeBuyer? newFirstTimeBuyer,
  }) {
    return ExchangeProduct(
      leadId: lead?.id,
      productId: newFirstTimeBuyer?.oldVehicleVariantId,
      modelYear: modelYear,
      ownership: ownership,
      insuranceValidity: insuranceValidity,
      tyreReplacement: tyreReplacement,
      color: color,
      millage: millage,
      registrationNumber: registrationNumber,
      expectedPrice: expectedPrice,
      quotedPrice: quotedPrice,
      dateOfEvaluation: dateOfEvaluation,
      priceDifference: ((expectedPrice ?? 0) - (quotedPrice ?? 0)).toString(),
    );
  }

  ExchangeProduct prospectUpdateExchangeDetailsRequest({
    Lead? lead,
    FirstTimeBuyer? newFirstTimeBuyer,
  }) {
    return prospectCreateExchangeDetailsRequest(
      lead: lead,
      newFirstTimeBuyer: newFirstTimeBuyer,
    ).copyWith(id: id);
  }

  ExchangeProduct bookingCreateExchangeDetailsRequest({
    Lead? lead,
    FirstTimeBuyer? newFirstTimeBuyer,
    ExchangeHouseRequest? newExchangeHouseDetails,
  }) {
    return ExchangeProduct(
      leadId: lead?.id,
      productId: newFirstTimeBuyer?.oldVehicleVariantId,
      modelYear: modelYear,
      ownership: ownership,
      insuranceValidity: insuranceValidity,
      tyreReplacement: tyreReplacement,
      color: color,
      millage: millage,
      registrationNumber: registrationNumber,
      expectedPrice: expectedPrice,
      quotedPrice: quotedPrice,
      dateOfEvaluation: dateOfEvaluation,
      purchasePrice: newExchangeHouseDetails?.purchasePrice,
      paymentMode:
          (newExchangeHouseDetails?.adjust ?? false) ? "adjust" : "cashback",
      priceDifference: ((expectedPrice ?? 0) - (quotedPrice ?? 0)).toString(),
    );
  }

  ExchangeProduct bookingUpdateExchangeDetailsRequest({
    Lead? lead,
    FirstTimeBuyer? newFirstTimeBuyer,
    ExchangeHouseRequest? newExchangeHouseDetails,
  }) {
    return bookingCreateExchangeDetailsRequest(
      lead: lead,
      newFirstTimeBuyer: newFirstTimeBuyer,
      newExchangeHouseDetails: newExchangeHouseDetails,
    ).copyWith(id: id);
  }

  ExchangeProduct deliveryCreateExchangeDetailsRequest({
    Lead? lead,
    FirstTimeBuyer? newFirstTimeBuyer,
    ExchangeHouseRequest? newExchangeHouseDetails,
  }) {
    return bookingCreateExchangeDetailsRequest(
      lead: lead,
      newFirstTimeBuyer: newFirstTimeBuyer,
      newExchangeHouseDetails: newExchangeHouseDetails,
    );
  }

  ExchangeProduct deliveryUpdateExchangeDetailsRequest({
    Lead? lead,
    FirstTimeBuyer? newFirstTimeBuyer,
    ExchangeHouseRequest? newExchangeHouseDetails,
  }) {
    return deliveryCreateExchangeDetailsRequest(
      lead: lead,
      newFirstTimeBuyer: newFirstTimeBuyer,
      newExchangeHouseDetails: newExchangeHouseDetails,
    ).copyWith(id: id);
  }
}

extension BrokrageRequestExtension on Brokerage {
  Brokerage createBrokerageRequest({Lead? lead}) {
    return Brokerage(
      id: id,
      leadId: lead?.id,
      brokerName: brokerName,
      brokerMobile: brokerMobile,
      brokerCity: brokerCity,
      brokerAmount: brokerAmount,
    );
  }
}

extension FollowupChangeStatusRequestExtension on FollowupDataGiven {
  CloseFollowupRequest closeFollowupRequest() {
    return CloseFollowupRequest(
      followupResponse: '1',
      followupResponseRemarks: 'Spoke to Customer',
      followupDoneAt: '2025-04-28 17:37:02',
      planNext: '0',
      nextFollowupTime: "",
      nextFollowupType: "",
      isRejected: '1',
      rejectionReason: closedReason,
    );
  }

  ChangeLeadStatusRequest followupChangeStatusRequest(Lead lead) {
    final String? status = leadStatus?.toLowerCase();
    final bool isLost = status == 'lost';
    final int? lpaApprover = lead.assigned?.lpaApprover;

    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    final bool hasLpaApprover =
        (lpaApprover != null && user?.id != lpaApprover);

    return ChangeLeadStatusRequest(
      leadStatus: isLost && hasLpaApprover ? 'LPA' : leadStatus?.toUpperCase(),
      closedReason: closedReason,
      lostToCoDealerName: lostToCoDealerName,
      lostToProductId: productId,
      lostToCompetitionReason: lostToCompetitionReason,
      lostRemarks: "",
      sentTo: lead.assigned?.lpaApprover,
      lostTo: lostTo,
    );
  }
}

extension CreateFollowupRequestExtension on FollowupDataGiven {
  LeadFollowupRequest createLeadFollowupRequest() {
    return LeadFollowupRequest(
      followUpPlan:
          nextFollowup == FollowUpPlanType.showroomVisit.value
              ? FollowUpPlanType.dealerVisit.value
              : nextFollowup,
      followUpDateTime: when,
      comments: '',
    );
  }
}

extension LeadFollowupRequestExtension on LeadFollowupRequest {
  CreateLeadHistoryRequest transferLeadHistoryRequest({Lead? lead}) {
    return CreateLeadHistoryRequest(
      remarks: "",
      workflowId: lead?.workflow?.actions?.lastOrNull?.id,
      status: "2",
      leadId: lead?.id,
      when: followUpDateTime,
      toWhom: "",
      notDoneReason: FollowupReasonState.leadTransferred.value,
    );
  }

  LeadFollowupRequest transferLeadFollowupRequest() {
    return LeadFollowupRequest(
      followUpPlan:
          followUpPlan == FollowUpPlanType.showroomVisit.value
              ? FollowUpPlanType.dealerVisit.value
              : followUpPlan,
      actorId: actorId,
      followUpDateTime: followUpDateTime,
      comments: "",
    );
  }

  Lead transferLeadRequest() {
    return Lead(
      nextAction:
          followUpPlan == FollowUpPlanType.showroomVisit.value
              ? FollowUpPlanType.dealerVisit.value
              : followUpPlan,
      assignedTo: actorId,
      nextFollowupTime: followUpDateTime,
      firstName: assigned?.firstName,
    );
  }

  LeadFollowupRequest reactivateFollowupRequest() {
    return copyWith(
      followUpPlan:
          followUpPlan == FollowUpPlanType.showroomVisit.value
              ? FollowUpPlanType.dealerVisit.value
              : followUpPlan,
      actorId: actorId,
    );
  }
}

extension BookingRequestExtension on Booking {
  Booking personalDetailsUpdateBookingRequest({
    Lead? lead,
    PanImages? panImages,
    LeadLocality? newLocality,
    CreateAddressResponse? addressData,
    List<ContactDetails> newContactDetails = const [],
  }) {
    final existingPhoneNumbers = phoneNumbers ?? lead?.phoneNumbers ?? [];
    final existingEmails = emails ?? lead?.emails ?? [];
    final updatedPhoneNumbers = <LeadPhoneNumber>[];
    final updatedEmails = <LeadEmail>[];

    for (var contact in newContactDetails) {
      if (contact.type == ContactType.email.value) {
        final indexOf = existingEmails.indexWhere(
          (email) => email.emailId == contact.value,
        );
        if (indexOf != -1) {
          updatedEmails.add(existingEmails[indexOf]);
        } else {
          updatedEmails.add(
            LeadEmail(emailId: contact.value, emailType: contact.type),
          );
        }
      } else {
        final indexOf = existingPhoneNumbers.indexWhere(
          (phone) =>
              phone.phoneNumber == contact.value &&
              phone.phoneType == contact.type,
        );
        if (indexOf != -1) {
          updatedPhoneNumbers.add(existingPhoneNumbers[indexOf]);
        } else {
          updatedPhoneNumbers.add(
            LeadPhoneNumber(
              phoneNumber: contact.value,
              phoneType: contact.type,
            ),
          );
        }
      }
    }

    Booking newBooking = Booking(
      leadId: lead?.id,
      salutation: salutation,
      firstName: firstName,
      lastName: lastName,
      profession: profession,
      otherProfession: otherProfession,
      documentValue: panImages?.value,
      documentValueType: panImages?.valueType,
      localityId: newLocality?.id,
      addressId: addressData?.addressId,
      bookingPhoneNumbers: updatedPhoneNumbers,
      bookingEmails: updatedEmails,
    );

    return newBooking;
  }

  Booking personalDetailsCreateBookingRequest({
    Lead? lead,
    PanImages? panImages,
    LeadLocality? newLocality,
    CreateAddressResponse? addressData,
    List<ContactDetails> newContactDetails = const [],
  }) {
    final newPhoneNumbers =
        newContactDetails
            .where((contact) => contact.type != ContactType.email.value)
            .map(
              (contact) => LeadPhoneNumber(
                phoneNumber: contact.value,
                phoneType: contact.type,
              ),
            )
            .toList();

    final newEmails =
        newContactDetails
            .where((contact) => contact.type == ContactType.email.value)
            .map(
              (contact) =>
                  LeadEmail(emailId: contact.value, emailType: contact.type),
            )
            .toList();

    Booking newBooking = Booking(
      leadId: lead?.id,
      salutation: salutation,
      firstName: firstName,
      lastName: lastName,
      profession: profession,
      otherProfession: otherProfession,
      documentValue: panImages?.value,
      documentValueType: panImages?.valueType,
      localityId: newLocality?.id,
      addressId: addressData?.addressId,
      bookingPhoneNumbers: newPhoneNumbers,
      bookingEmails: newEmails,
    );

    return newBooking;
  }

  Booking buyingCreateBookingRequest({
    Lead? lead,
    CustomerQuote? newCustomerQuote,
  }) {
    Booking newBooking = Booking(
      vehicleColor: lead?.interestedColorId,
      purchaseMode: lead?.purchaseMode,
      leadId: lead?.id,
      salutation: lead?.salutation,
      firstName: lead?.firstName,
      lastName: lead?.lastName,
      bankId: bankName == "OTHER" ? null : bankId,
      otherBank: bankName == "OTHER" ? otherBank : null,
      disbursalAmount: disbursalAmount,
      financeType: financeType,
      sentQuote:
          newCustomerQuote?.tookQuote == CustomerQuoteState.yes.value
              ? 1
              : newCustomerQuote?.tookQuote == CustomerQuoteState.no.value
              ? 0
              : null,
      quoteDate:
          newCustomerQuote?.tookQuote == CustomerQuoteState.yes.value
              ? newCustomerQuote?.quoteDate
              : null,
    );
    final financeReasons =
        (bookingReasons ?? [])
            .map((reason) => reason.reason ?? "")
            .where((reason) => reason.isNotEmpty)
            .toList();

    if (lead?.purchaseMode == PurchaseMode.finance.value) {
      if (financeType == FinanceForm.dO.value) {
        newBooking = newBooking.copyWith(
          payoutPercentage: payoutPercentage,
        );
      } else if (financeType == FinanceForm.self.value) {
        newBooking = newBooking.copyWith(
          financeSelfDsa: "FINANCE_SELF_DSA",
          financeReasons: financeReasons,
        );
      }
    }

    return newBooking;
  }

  Booking buyingUpdateBookingRequest({
    Lead? lead,
    CustomerQuote? newCustomerQuote,
  }) {
    Booking newBooking = Booking(
      vehicleColor: lead?.interestedColorId,
      purchaseMode: lead?.purchaseMode,
      leadId: lead?.id,
      salutation: salutation,
      firstName: firstName,
      lastName: lastName,
      bankId: bankName == "OTHER" ? null : bankId,
      otherBank: bankName == "OTHER" ? otherBank : null,
      disbursalAmount: disbursalAmount,
      financeType: financeType,
      sentQuote:
          newCustomerQuote?.tookQuote == CustomerQuoteState.yes.value
              ? 1
              : newCustomerQuote?.tookQuote == CustomerQuoteState.no.value
              ? 0
              : null,
      quoteDate:
          newCustomerQuote?.tookQuote == CustomerQuoteState.yes.value
              ? newCustomerQuote?.quoteDate
              : null,
    );
    final financeReasons =
        (bookingReasons ?? [])
            .map((reason) => reason.reason ?? "")
            .where((reason) => reason.isNotEmpty)
            .toList();

    if (lead?.purchaseMode == PurchaseMode.finance.value) {
      if (financeType == FinanceForm.dO.value) {
        newBooking = newBooking.copyWith(
          payoutPercentage: payoutPercentage,
        );
      } else if (financeType == FinanceForm.self.value) {
        newBooking = newBooking.copyWith(
          financeSelfDsa: "FINANCE_SELF_DSA",
          financeReasons: financeReasons,
        );
      }
    }

    return newBooking;
  }

  Booking paymentCreateBookingRequest({Lead? lead}) {
    Booking newBooking = Booking(
      leadId: lead?.id,
      salutation: lead?.salutation,
      firstName: lead?.firstName,
      lastName: lead?.lastName,
      bankId: bankName == "OTHER" ? null : bankId,
      otherBank: bankName == "OTHER" ? otherBank : null,
      disbursalAmount: disbursalAmount,
      financeType: financeType,
    );

    final financeReasons =
        (bookingReasons ?? [])
            .map((reason) => reason.reason ?? "")
            .where((reason) => reason.isNotEmpty)
            .toList();

    if (lead?.purchaseMode == PurchaseMode.finance.value) {
      if (financeType == FinanceForm.dO.value) {
        newBooking = newBooking.copyWith(
          payoutPercentage: payoutPercentage,
        );
      } else if (financeType == FinanceForm.self.value) {
        newBooking = newBooking.copyWith(
          financeSelfDsa: "FINANCE_SELF_DSA",
          financeReasons: financeReasons,
        );
      }
    }

    return newBooking;
  }

  Booking paymentUpdateBookingRequest({Lead? lead}) {
    Booking newBooking = Booking(
      leadId: lead?.id,
      salutation: salutation,
      firstName: firstName,
      lastName: lastName,
      bankId: bankName == "OTHER" ? null : bankId,
      otherBank: bankName == "OTHER" ? otherBank : null,
      disbursalAmount: disbursalAmount,
      financeType: financeType,
    );

    final financeReasons =
        (bookingReasons ?? [])
            .map((reason) => reason.reason ?? "")
            .where((reason) => reason.isNotEmpty)
            .toList();

    if (lead?.purchaseMode == PurchaseMode.finance.value) {
      if (financeType == FinanceForm.dO.value) {
        newBooking = newBooking.copyWith(
          payoutPercentage: payoutPercentage,
        );
      } else if (financeType == FinanceForm.self.value) {
        newBooking = newBooking.copyWith(
          financeSelfDsa: "FINANCE_SELF_DSA",
          financeReasons: financeReasons,
        );
      }
    }

    return newBooking;
  }
}

extension DeliveryRequestExtension on Delivery {
  Delivery personalDetailsUpdateDeliveryRequest({
    Lead? lead,
    PanImages? panImages,
    LeadLocality? newLocality,
    CreateAddressResponse? addressData,
    List<ContactDetails> newContactDetails = const [],
  }) {
    final existingPhoneNumbers = phoneNumbers ?? lead?.phoneNumbers ?? [];
    final existingEmails = emails ?? lead?.emails ?? [];
    final updatedPhoneNumbers = <LeadPhoneNumber>[];
    final updatedEmails = <LeadEmail>[];

    for (var contact in newContactDetails) {
      if (contact.type == ContactType.email.value) {
        final indexOf = existingEmails.indexWhere(
          (email) => email.emailId == contact.value,
        );
        if (indexOf != -1) {
          updatedEmails.add(existingEmails[indexOf]);
        } else {
          updatedEmails.add(
            LeadEmail(emailId: contact.value, emailType: contact.type),
          );
        }
      } else {
        final indexOf = existingPhoneNumbers.indexWhere(
          (phone) =>
              phone.phoneNumber == contact.value &&
              phone.phoneType == contact.type,
        );
        if (indexOf != -1) {
          updatedPhoneNumbers.add(existingPhoneNumbers[indexOf]);
        } else {
          updatedPhoneNumbers.add(
            LeadPhoneNumber(
              phoneNumber: contact.value,
              phoneType: contact.type,
            ),
          );
        }
      }
    }

    return Delivery(
      leadId: lead?.id,
      salutation: salutation,
      firstName: firstName,
      lastName: lastName,
      profession: profession,
      otherProfession: otherProfession,
      documentValue: panImages?.value,
      documentValueType: panImages?.valueType,
      localityId: newLocality?.id,
      addressId: addressData?.addressId,
      deliveryPhoneNumbers: updatedPhoneNumbers,
      deliveryEmails: updatedEmails,
    );
  }

  Delivery personalDetailsCreateDeliveryRequest({
    Lead? lead,
    PanImages? panImages,
    LeadLocality? newLocality,
    CreateAddressResponse? addressData,
    List<ContactDetails> newContactDetails = const [],
  }) {
    final newPhoneNumbers =
        newContactDetails
            .where((contact) => contact.type != ContactType.email.value)
            .map(
              (contact) => LeadPhoneNumber(
                phoneNumber: contact.value,
                phoneType: contact.type,
              ),
            )
            .toList();

    final newEmails =
        newContactDetails
            .where((contact) => contact.type == ContactType.email.value)
            .map(
              (contact) =>
                  LeadEmail(emailId: contact.value, emailType: contact.type),
            )
            .toList();

    return Delivery(
      leadId: lead?.id,
      salutation: salutation,
      firstName: firstName,
      lastName: lastName,
      profession: profession,
      otherProfession: otherProfession,
      documentValue: panImages?.value,
      documentValueType: panImages?.valueType,
      localityId: newLocality?.id,
      addressId: addressData?.addressId,
      deliveryPhoneNumbers: newPhoneNumbers,
      deliveryEmails: newEmails,
    );
  }
}

extension CreditGivenRequestExtension on CreditGiven {
  ReceiptReason sendReceiptReasonRequest({Lead? lead}) {
    return ReceiptReason(
      reason: ReceiptReasonType.creditGivenToCustomer.value,
      pendingAmount: amountPending ?? 0,
      expectedDate: expectedDateOfPayment ?? "",
      leadId: lead?.id,
      permittedBy: permittedBy ?? "",
    );
  }

  ReceiptReason updateReceiptReasonRequest({Lead? lead}) {
    return sendReceiptReasonRequest(lead: lead);
  }
}

extension OldCarPaymentRequestExtension on OldCarPayment {
  ReceiptReason sendOldCarPaymentRequest({Lead? lead}) {
    return ReceiptReason(
      reason: ReceiptReasonType.oldCarPaymentPendingFromAgent.value,
      pendingAmount: amountPending ?? 0,
      expectedDate: expectedDateOfPayment ?? "",
      leadId: lead?.id,
      agentName: agentName ?? "",
      agentNo: int.tryParse(agentNumber ?? "0"),
    );
  }

  ReceiptReason updateOldCarPaymentRequest({Lead? lead}) {
    return sendOldCarPaymentRequest(lead: lead);
  }
}

extension DiscountApprovalRequestExtension on DiscountApproval {
  DiscountApproval bookingDiscountApprovalRequest({
    List<String> approvalReasons = const [],
  }) {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    return copyWith(
      discountReason: approvalReasons.join(", "),
      sentFrom: user?.id,
    );
  }

  DiscountApproval deliveryDiscountApprovalRequest({
    List<String> approvalReasons = const [],
  }) {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    return copyWith(
      approvalType: discountGivenInExcess ? 'discount_approval' : 'normal',
      discountReason: approvalReasons.join(", "),
      sentFrom: user?.id,
    );
  }
}

