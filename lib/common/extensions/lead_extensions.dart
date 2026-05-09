import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/contact_type.dart';
import 'package:salesdocket_mobile/common/constants/customer_type.dart';
import 'package:salesdocket_mobile/common/constants/lead_source_type.dart';
import 'package:salesdocket_mobile/common/constants/profession.dart';
import 'package:salesdocket_mobile/common/constants/first_time_buyer_state.dart';
import 'package:salesdocket_mobile/common/constants/interested_in_exchange_state.dart';
import 'package:salesdocket_mobile/common/constants/purchase_mode.dart';
import 'package:salesdocket_mobile/common/constants/select_brand_reason.dart';
import 'package:salesdocket_mobile/common/constants/workflow_state.dart';
import 'package:salesdocket_mobile/common/constants/customer_quote_state.dart';
import 'package:salesdocket_mobile/common/entity/customer_quote.dart';
import 'package:salesdocket_mobile/common/entity/exchange_product_images.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/entity/interested_in_comp.dart';
import 'package:salesdocket_mobile/common/entity/lead_source.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/booking_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/delivery_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/lead_utils.dart';
import 'package:salesdocket_mobile/utility/user_utils.dart';

import '../constants/lead_state.dart';

extension CreateLeadExtensions on CreateLeadRequest {
  String get fullName {
    return UserUtils.fullName(salutation, firstName, lastName);
  }

  String get fullNameWOSalutation {
    return UserUtils.fullName(
      salutation,
      firstName,
      lastName,
      includeSalutation: false,
    );
  }

  List<InterestedVariant> updatedVariants(
    int? newVariantId,
    String? newVariant,
  ) {
    final prevVariants = (variants ?? []).toList();
    if (prevVariants.any((prevVariant) => prevVariant.id == newVariantId)) {
      return prevVariants;
    }

    prevVariants.add(
      InterestedVariant(
        product: LeadProduct(id: model, name: modelName),
        engineType: engineType,
        id: newVariantId,
        variant: newVariant,
      ),
    );

    return prevVariants;
  }

  CreateLeadRequest onVariantRemoved(int? toRemove) {
    final prevVariants = (variants ?? []).toList();
    final lastVariant = prevVariants.lastOrNull;
    final isLastVariantRemoved = lastVariant?.id == toRemove;
    prevVariants.removeWhere((variant) => variant.id == toRemove);

    return isLastVariantRemoved
        ? copyWith(
          primaryVariantId: null,
          variant: null,
          model: null,
          modelName: null,
          engineType: null,
          variants: prevVariants,
        )
        : copyWith(variants: prevVariants);
  }
}

extension UpdateLeadExtension on UpdateLeadRequest {
  get fullName {
    return "${firstName ?? ""}${(lastName?.length ?? 0) > 1 ? " $lastName" : ""}";
  }
}

extension LeadExtension on Lead {
  bool get isItCCLead {
    return isCCLead == LeadValidState.isCCLead.value;
  }

  bool get isEC {
    return exchangeStatus == LeadValidState.ec.value;
  }

  bool get isEPE {
    return exchangeStatus == LeadValidState.epe.value;
  }

  bool get isExchangeStatus {
    return exchangeStatus == LeadValidState.ec.value;
  }

  bool get isItHOLead {
    return isHoCampaign == LeadValidState.isHOLead.value;
  }

  String get fullName {
    if ((delivery?.fullName ?? "").isNotEmpty) {
      return delivery!.fullName;
    }
    if ((booking?.fullName ?? "").isNotEmpty) {
      return booking!.fullName;
    }
    if ((firstName ?? "").isNotEmpty || (lastName ?? "").isNotEmpty) {
      return UserUtils.fullName(salutation, firstName, lastName);
    }
    return UserUtils.fullName(salutation, leadFirstName, leadLastName);
  }

  String get campaignFullName {
    return UserUtils.campaignFullName(leadFirstName, leadLastName);
  }

  String get prospectFullName {
    if ((firstName ?? "").isNotEmpty || (lastName ?? "").isNotEmpty) {
      return UserUtils.fullName(salutation, firstName, lastName);
    }
    return originalEnquiryFullName;
  }

  String get originalEnquiryFullName {
    return UserUtils.fullName(salutation, leadFirstName, leadLastName);
  }

  String get deliveryFullName {
    if ((delivery?.fullName ?? "").isNotEmpty) {
      return delivery!.fullName;
    }
    return bookingFullName;
  }

  String get deliveryFullNameWOSalutation {
    if ((delivery?.fullNameWOSalutation ?? "").isNotEmpty) {
      return delivery!.fullNameWOSalutation;
    }
    return bookingFullNameWOSalutation;
  }

  String get bookingFullName {
    if ((booking?.fullName ?? "").isNotEmpty) {
      return booking!.fullName;
    }
    return prospectFullName;
  }

  String get bookingFullNameWOSalutation {
    if ((booking?.fullNameWOSalutation ?? "").isNotEmpty) {
      return booking!.fullNameWOSalutation;
    }
    return prospectFullNameWOSalutation;
  }

  String get prospectFullNameWOSalutation {
    if ((firstName ?? "").isNotEmpty || (lastName ?? "").isNotEmpty) {
      return UserUtils.fullName(
        salutation,
        firstName,
        lastName,
        includeSalutation: false,
      );
    }
    return UserUtils.fullName(
      salutation,
      leadFirstName,
      leadLastName,
      includeSalutation: false,
    );
  }

  String get fullNameWOSalutation {
    if ((delivery?.fullNameWOSalutation ?? "").isNotEmpty) {
      return delivery!.fullNameWOSalutation;
    }
    if ((booking?.fullNameWOSalutation ?? "").isNotEmpty) {
      return booking!.fullNameWOSalutation;
    }
    if ((firstName ?? "").isNotEmpty || (lastName ?? "").isNotEmpty) {
      return UserUtils.fullName(
        salutation,
        firstName,
        lastName,
        includeSalutation: false,
      );
    }
    return UserUtils.fullName(
      salutation,
      leadFirstName,
      leadLastName,
      includeSalutation: false,
    );
  }

  String? get stateValue {
    final stateValues = LeadUtils.leadStateValues;
    return stateValues[workflow?.state?.toUpperCase()];
  }

  Color? get stateColor {
    final colors = LeadUtils().leadStateColors;
    return colors[leadState?.toUpperCase()];
  }

  String get primaryContactNumber {
    return phoneNumbers?.firstOrNull?.phoneNumber ?? "";
  }

  String get primaryEmail {
    return emails?.firstOrNull?.emailId ?? "";
  }

  String get contactNumber {
    return primaryContactNumber.isNotEmpty
        ? primaryContactNumber
        : (leadMobileNumber ?? "");
  }

  String get listCardDisplayName {
    if (workflow.isDeliveryGroup) {
      return (delivery?.fullName ?? "").isNotEmpty
          ? delivery!.fullName
          : (booking?.fullName ?? "").isNotEmpty
          ? booking!.fullName
          : prospectFullName;
    }
    if (workflow.isBookingGroup) {
      return (booking?.fullName ?? "").isNotEmpty
          ? booking!.fullName
          : prospectFullName;
    }
    return prospectFullName;
  }

  String get listCardDisplayMobile {
    if (workflow.isDeliveryGroup) {
      final deliveryPhone = delivery
          ?.contactDetails(null)
          .where((c) => c.type != ContactType.email.value)
          .firstOrNull
          ?.value;
      if ((deliveryPhone ?? "").isNotEmpty) return deliveryPhone!;

      final bookingPhone = booking
          ?.contactDetails(null)
          .where((c) => c.type != ContactType.email.value)
          .firstOrNull
          ?.value;
      if ((bookingPhone ?? "").isNotEmpty) return bookingPhone!;

      return contactNumber;
    }
    if (workflow.isBookingGroup) {
      final bookingPhone = booking
          ?.contactDetails(null)
          .where((c) => c.type != ContactType.email.value)
          .firstOrNull
          ?.value;
      if ((bookingPhone ?? "").isNotEmpty) return bookingPhone!;

      return contactNumber;
    }
    return contactNumber;
  }

  String? get productImage {
    return primaryVariant?.product?.image;
  }

  String get primaryCarName {
    return primaryVariant?.carName ?? "";
  }

  String get carName {
    return sortedVariants?.map((variant) => variant.carName).join(", ") ?? "";
  }

  String? get dateOfBPR {
    return discountApprovals?.lastOrNull?.createdAt;
  }

  User? get smReceiver {
    if (workflow.isCPA) {
      return bookingCancel?.lastOrNull?.receiver;
    }
    return discountApprovals?.lastOrNull?.receiver;
  }

  String? get cancellationReason {
    if (workflow.isBPR) {
      return discountApprovals?.lastOrNull?.requestResponse;
    }
    if (workflow.isDPR) {
      return delivery?.deliveryApprovals?.lastOrNull?.requestResponse;
    }

    return null;
  }

  User? get dprSmReceiver {
    return delivery?.deliveryApprovals?.lastOrNull?.receiver;
  }

  User? get lpaValidator {
    return leadLostApprovers?.lastOrNull?.receiver;
  }

  User? get cpaReceiver {
    return bookingCancel?.lastOrNull?.receiver;
  }

  List<BookingReason>? get bookingReasons {
    return booking?.bookingReasons
        ?.where(
          (bookingReason) => bookingReason.reasonType != "BOOKING_INACTIVE",
        )
        .toList();
  }

  String get completeAddress {
    return UserUtils.completeAddress(address, locality);
  }

  List<ContactDetails> get contactDetails {
    final details = <ContactDetails>[];
    phoneNumbers?.forEach((phone) {
      details.add(
        ContactDetails(value: phone.phoneNumber, type: phone.phoneType),
      );
    });
    emails?.forEach((email) {
      details.add(
        ContactDetails(value: email.emailId, type: ContactType.email.value),
      );
    });

    return details;
  }

  List<MenuItem> get bookingForm {
    return [
      MenuItem(
        title:
            assigned?.type == 1
                ? '${LocaleKeys.smName.tr()} : '
                : '${LocaleKeys.scName.tr()} : ',
        subtitle: assigned?.fullName,
      ),
      MenuItem(
        title: '${LocaleKeys.lblLeadSource.tr()} : ',
        subtitle: leadSource,
      ),
      MenuItem(title: '${LocaleKeys.dmsId.tr()} : ', subtitle: dmsId),
      MenuItem(
        title: '${LocaleKeys.sourceOfInformation.tr()} : ',
        subtitle: sourceOfInformation == SourceOfInformationReasons.othersValue
            ? ((otherSourceOfInformation ?? "").isNotEmpty
                ? '$sourceOfInformation : $otherSourceOfInformation'
                : sourceOfInformation)
            : sourceOfInformation,
      ),
      MenuItem(
        title: '${LocaleKeys.lblModel.tr()} : ',
        subtitle: primaryVariant?.product?.name,
      ),
      MenuItem(
        title: '${LocaleKeys.variant.tr()} : ',
        subtitle: primaryVariant?.variant,
      ),
      MenuItem(
        title: '${LocaleKeys.color.tr()} : ',
        subtitle: interestedColor?.lastOrNull?.color,
      ),
    ].filteredNonEmptyItems;
  }

  List<MenuItem> get enquiryDetail {
    return [
      MenuItem(
        title: '${LocaleKeys.lblDateOfEnquiry.tr()}: ',
        subtitle: eprDate?.formatDateTime(),
      ),
      MenuItem(title: '${LocaleKeys.name.tr()} : ', subtitle: prospectFullName),
    ].filteredNonEmptyItems;
  }

  List<MenuItem> get personalDetailItems {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    return [
      MenuItem(
        title: '${LocaleKeys.name.tr()} : ',
        subtitle: bookingFullName,
      ),
      MenuItem(
        title: '${LocaleKeys.mobileNo.tr()} : ',
        subtitle: (phoneNumbers ?? [])
            .map((phone) => phone.phoneNumber ?? "")
            .toSet()
            .where((phone) => phone.isNotEmpty)
            .map(
              (phone) =>
                  (user?.maskMobile ?? false) ? phone.maskedPhoneNumber : phone,
            )
            .join(", "),
      ),
      MenuItem(
        title: '${LocaleKeys.email.tr()} : ',
        subtitle: (emails ?? []).map((email) => email.emailId).join(", "),
      ),
      MenuItem(
        title: '${LocaleKeys.address.tr()} : ',
        subtitle:
            (user?.maskAddress ?? false)
                ? completeAddress.maskedPhoneNumber
                : completeAddress,
      ),
      MenuItem(
        title: '${LocaleKeys.typeOfCustomer.tr()} : ',
        subtitle: customerType,
      ),
      MenuItem(
        title: '${LocaleKeys.corporateName.tr()} : ',
        subtitle: corporateName,
      ),
      MenuItem(
        title: '${LocaleKeys.profession.tr()} : ',
        subtitle: booking?.profession == Profession.other.value
            ? ((booking?.otherProfession ?? "").isNotEmpty
                ? '${booking?.profession} : ${booking?.otherProfession}'
                : booking?.profession)
            : booking?.profession,
      ),
      MenuItem(
        title: '${LocaleKeys.documentType.tr()} : ',
        subtitle: booking?.documentValueType,
      ),
      MenuItem(
        title: '${LocaleKeys.documentValue.tr()} : ',
        subtitle: booking?.documentValue,
      ),
      MenuItem(
        title: '${LocaleKeys.dob.tr()} : ',
        subtitle: dob?.formatDateTime(inputFormat: "yyyy-MM-DD"),
      ),
    ].filteredNonEmptyItems;
  }

  List<MenuItem> get buyingDetailItems {
    final effectivePurchaseMode = purchaseMode?.isNotEmpty == true ? purchaseMode : booking?.purchaseMode;
    final isFinance = effectivePurchaseMode == PurchaseMode.finance.value;
    return [
      MenuItem(
        title: '${LocaleKeys.firstTimeBuyer.tr()} : ',
        subtitle:
            isExistingVehicle == FirstTimeBuyerState.yes.value ? "Yes" : "No",
      ),
      MenuItem(
        title: '${LocaleKeys.lblModeOfPurchase.tr()} : ',
        subtitle: effectivePurchaseMode,
      ),
      MenuItem(
        title: '${LocaleKeys.financeForm.tr()} : ',
        subtitle: isFinance ? booking?.financeType : null,
      ),
      MenuItem(
        title: '${LocaleKeys.bank.tr()} : ',
        subtitle: isFinance ? booking?.bank?.name : null,
      ),
      MenuItem(
        title: '${LocaleKeys.payoutPercentage.tr()} : ',
        subtitle: isFinance ? booking?.payoutPercentage : null,
      ),
      MenuItem(
        title: '${LocaleKeys.disbursalAmount.tr()}: ',
        subtitle: isFinance ? "${booking?.disbursalAmount ?? ""}" : null,
      ),
      MenuItem(
        title: '${LocaleKeys.dsaName.tr()} : ',
        subtitle: isFinance ? booking?.dsaName : null,
      ),
      MenuItem(
        title: '${LocaleKeys.dsaMobile.tr()} : ',
        subtitle: isFinance ? booking?.dsaMobile : null,
      ),
      MenuItem(
        title: '${LocaleKeys.reasonForOutsideFinance.tr()} : ',
        subtitle: isFinance ? (booking?.bookingReasons ?? [])
            .map((reason) => reason.reason ?? "")
            .where((reason) => reason.isNotEmpty)
            .join(",") : null,
      ),
      MenuItem(
        title: '${LocaleKeys.didCustomerTakeQuote.tr()} : ',
        subtitle: customerQuoteDetails.tookQuoteLabel,
      ),
      MenuItem(
        title: '${LocaleKeys.quoteDate.tr()} : ',
        subtitle: customerQuoteDetails.quoteDate?.formatDateTime(),
      ),
    ].filteredNonEmptyItems;
  }

  List<MenuItem> get exchangeDetailItems {
    final bookingReason = booking?.bookingReasons?.lastOrNull;
    final exchangeProduct = exchangeProducts?.lastOrNull;
    final variant = exchangeProduct?.variant;
    final product = variant?.product;
    final isInHouse = booking?.exchangeType == ExchangeType.inHouse.value;

    return [
      MenuItem(
        title: '${LocaleKeys.exchangeType.tr()} : ',
        subtitle: booking?.exchangeType,
      ),
      MenuItem(
        title: '${LocaleKeys.betterValueOutside.tr()} : ',
        subtitle: "${bookingReason?.exchangeBetterValue ?? ""}",
      ),
      MenuItem(
        title: '${LocaleKeys.lblOther.tr()} : ',
        subtitle: bookingReason?.otherReason,
      ),
      MenuItem(
        title: '${LocaleKeys.exchangeReason.tr()} : ',
        subtitle: bookingReason?.reason,
      ),
      MenuItem(
        title: '${LocaleKeys.manufacture.tr()} : ',
        subtitle: product?.brand?.name,
      ),
      MenuItem(
        title: '${LocaleKeys.lblModel.tr()} : ',
        subtitle: product?.name,
      ),
      MenuItem(
        title: '${LocaleKeys.variant.tr()} : ',
        subtitle: variant?.variant,
      ),
      MenuItem(
        title: '${LocaleKeys.modelYear.tr()} : ',
        subtitle: "${exchangeProduct?.modelYear ?? ""}",
      ),
      MenuItem(
        title: '${LocaleKeys.ownership.tr()} : ',
        subtitle: exchangeProduct?.ownership,
      ),
      MenuItem(
        title: '${LocaleKeys.insuranceValidity.tr()} : ',
        subtitle: exchangeProduct?.insuranceValidity?.formatDateTime(),
      ),
      MenuItem(
        title: '${LocaleKeys.registrationNo.tr()} : ',
        subtitle: exchangeProduct?.registrationNumber,
      ),
      MenuItem(
        title: '${LocaleKeys.mileageKm.tr()} : ',
        subtitle: "${exchangeProduct?.millage ?? ""}",
      ),
      MenuItem(
        title: '${LocaleKeys.tyreReplacement.tr()}: ',
        subtitle: exchangeProduct?.tyreReplacement
            ?.split(",")
            .map((value) => value.formatTyreText)
            .join(", "),
      ),
      MenuItem(
        title: '${LocaleKeys.purchasePrice.tr()} : ',
        subtitle: isInHouse ? "${exchangeProduct?.purchasePrice ?? ""}" : null,
      ),
      MenuItem(
        title: '${LocaleKeys.adjust.tr()} : ',
        subtitle:
            isInHouse
                ? exchangeProduct?.paymentMode == "Cashback"
                    ? "No"
                    : exchangeProduct?.paymentMode == "Adjust"
                    ? "Yes"
                    : null
                : null,
      ),
      MenuItem(
        title: '${LocaleKeys.interestedInExchange.tr()} : ',
        subtitle: "$isExchange" == "0" ? "No" : null,
      ),
    ].filteredNonEmptyItems;
  }

  List<MenuItem> get deliveryDetails {
    return [
      MenuItem(
        title: assigned?.type == 1 ? 'SM Name : ' : 'SC Name : ',
        subtitle: assigned?.fullName,
      ),
      MenuItem(
        title: '${LocaleKeys.lblLeadSource.tr()} : ',
        subtitle: leadSource,
      ),
      MenuItem(title: '${LocaleKeys.dmsId.tr()} : ', subtitle: dmsId),
      MenuItem(
        title: '${LocaleKeys.sourceOfInformation.tr()} : ',
        subtitle: sourceOfInformation == SourceOfInformationReasons.othersValue
            ? ((otherSourceOfInformation ?? "").isNotEmpty
                ? '$sourceOfInformation : $otherSourceOfInformation'
                : sourceOfInformation)
            : sourceOfInformation,
      ),
      MenuItem(
        title: '${LocaleKeys.lblModel.tr()} : ',
        subtitle: primaryVariant?.product?.name,
      ),
      MenuItem(
        title: '${LocaleKeys.variant.tr()} : ',
        subtitle: primaryVariant?.variant,
      ),
      MenuItem(
        title: '${LocaleKeys.color.tr()} : ',
        subtitle: delivery?.color?.color ?? interestedColor?.lastOrNull?.color,
      ),
    ].filteredNonEmptyItems;
  }

  List<MenuItem> get bookingDetails {
    return [
      MenuItem(
        title: '${LocaleKeys.dateOfBooking.tr()} : ',
        subtitle: (booking?.bookingDate ?? bookingDate)?.formatDateTime(),
      ),
      MenuItem(
        title: '${LocaleKeys.name.tr()} : ',
        subtitle: booking?.fullName,
      ),
    ].filteredNonEmptyItems;
  }

  List<MenuItem> get deliveryPersonalDetailItems {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    return [
      MenuItem(
        title: '${LocaleKeys.name.tr()} : ',
        subtitle: (delivery?.fullName ?? "").isNotEmpty
            ? delivery?.fullName
            : fullName,
      ),
      MenuItem(
        title: '${LocaleKeys.mobileNo.tr()} : ',
        subtitle: (phoneNumbers ?? [])
            .map((phone) => phone.phoneNumber ?? "")
            .toSet()
            .where((phone) => phone.isNotEmpty)
            .map(
              (phone) =>
                  (user?.maskMobile ?? false) ? phone.maskedPhoneNumber : phone,
            )
            .join(", "),
      ),
      MenuItem(
        title: '${LocaleKeys.email.tr()} : ',
        subtitle: (delivery ?? const Delivery())
            .contactDetails(this)
            .where((contact) => contact.type == ContactType.email.value)
            .map((email) => email.value ?? "")
            .toSet()
            .where((email) => email.isNotEmpty)
            .join(", "),
      ),
      MenuItem(
        title: '${LocaleKeys.address.tr()} : ',
        subtitle:
            (user?.maskAddress ?? false)
                ? completeAddress.maskedPhoneNumber
                : completeAddress,
      ),
      MenuItem(
        title: '${LocaleKeys.typeOfCustomer.tr()} : ',
        subtitle: customerType,
      ),
      MenuItem(
        title: '${LocaleKeys.corporateName.tr()} : ',
        subtitle: corporateName,
      ),
      MenuItem(
        title: '${LocaleKeys.profession.tr()} : ',
        subtitle: delivery?.profession == Profession.other.value
            ? ((delivery?.otherProfession ?? "").isNotEmpty
                ? '${delivery?.profession} : ${delivery?.otherProfession}'
                : delivery?.profession)
            : delivery?.profession,
      ),
      MenuItem(
        title: '${LocaleKeys.documentType.tr()} : ',
        subtitle: delivery?.documentValueType,
      ),
      MenuItem(
        title: '${LocaleKeys.documentValue.tr()} : ',
        subtitle: delivery?.documentValue,
      ),
      MenuItem(
        title: '${LocaleKeys.dob.tr()} : ',
        subtitle: dob?.formatDateTime(inputFormat: "yyyy-MM-DD"),
      ),
    ].filteredNonEmptyItems;
  }

  List<MenuItem> get deliveryBuyingDetailItems {
    final effectivePurchaseMode = purchaseMode?.isNotEmpty == true
        ? purchaseMode
        : (delivery?.purchaseMode?.isNotEmpty == true ? delivery?.purchaseMode : booking?.purchaseMode);
    return [
      MenuItem(
        title: '${LocaleKeys.firstTimeBuyer.tr()} : ',
        subtitle:
            isExistingVehicle == FirstTimeBuyerState.yes.value ? "Yes" : "No",
      ),
      MenuItem(
        title: '${LocaleKeys.lblModeOfPurchase.tr()} : ',
        subtitle: effectivePurchaseMode,
      ),
      MenuItem(
        title: '${LocaleKeys.financeForm.tr()} : ',
        subtitle: delivery?.financeType,
      ),
      MenuItem(
        title: '${LocaleKeys.bank.tr()} : ',
        subtitle: delivery?.bank?.name,
      ),
      MenuItem(
        title: '${LocaleKeys.payoutPercentage.tr()} : ',
        subtitle: delivery?.payoutPercentage,
      ),
      MenuItem(
        title: '${LocaleKeys.disbursalAmount.tr()} : ',
        subtitle: "${delivery?.disbursalAmount ?? ""}",
      ),
      MenuItem(
        title: '${LocaleKeys.dsaName.tr()} : ',
        subtitle: delivery?.dsaName,
      ),
      MenuItem(
        title: '${LocaleKeys.didCustomerTakeQuote.tr()} : ',
        subtitle: customerQuoteDetails.tookQuoteLabel,
      ),
      MenuItem(
        title: '${LocaleKeys.quoteDate.tr()} : ',
        subtitle: customerQuoteDetails.quoteDate?.formatDateTime(),
      ),
      MenuItem(
        title: '${LocaleKeys.dsaMobile.tr()} : ',
        subtitle: delivery?.dsaMobile,
      ),
      MenuItem(
        title: '${LocaleKeys.reasonForOutsideFinance.tr()} : ',
        subtitle: (delivery?.deliveryReasons ?? [])
            .map((reason) => reason.reason ?? "")
            .where((reason) => reason.isNotEmpty)
            .join(","),
      ),
    ].filteredNonEmptyItems;
  }

  List<MenuItem> get deliveryExchangeDetailItems {
    final deliveryReason = delivery?.deliveryReasons?.lastOrNull;
    final exchangeProduct = exchangeProducts?.lastOrNull;
    final product = exchangeProduct?.variant?.product;
    final isInHouse = booking?.exchangeType == ExchangeType.inHouse.value;
    final isOutHouse = booking?.exchangeType == ExchangeType.outHouse.value;

    return [
      MenuItem(
        title: '${LocaleKeys.exchangeType.tr()} : ',
        subtitle: booking?.exchangeType,
      ),
      MenuItem(
        title: '${LocaleKeys.betterValueOutside.tr()} : ',
        subtitle: "${deliveryReason?.exchangeBetterValue ?? ""}",
      ),
      MenuItem(
        title: '${LocaleKeys.lblOther.tr()} : ',
        subtitle: deliveryReason?.otherReason,
      ),
      MenuItem(
        title: '${LocaleKeys.exchangeReason.tr()} : ',
        subtitle: isOutHouse ? bookingExchangeHouse.reason : deliveryReason?.reason,
      ),
      MenuItem(
        title: '${LocaleKeys.manufacture.tr()} : ',
        subtitle: product?.brand?.name,
      ),
      MenuItem(
        title: '${LocaleKeys.lblModel.tr()} : ',
        subtitle: product?.name,
      ),
      MenuItem(
        title: '${LocaleKeys.color.tr()} : ',
        subtitle: exchangeProduct?.color,
      ),
      MenuItem(
        title: '${LocaleKeys.modelYear.tr()} : ',
        subtitle: "${exchangeProduct?.modelYear ?? ""}",
      ),
      MenuItem(
        title: '${LocaleKeys.ownership.tr()} : ',
        subtitle: exchangeProduct?.ownership,
      ),
      MenuItem(
        title: '${LocaleKeys.insuranceValidity.tr()} : ',
        subtitle: exchangeProduct?.insuranceValidity?.formatDateTime(),
      ),
      MenuItem(
        title: '${LocaleKeys.registrationNo.tr()} : ',
        subtitle: exchangeProduct?.registrationNumber,
      ),
      MenuItem(
        title: '${LocaleKeys.mileageKm.tr()} : ',
        subtitle: "${exchangeProduct?.millage ?? ""}",
      ),
      MenuItem(
        title: '${LocaleKeys.tyreReplacement.tr()} : ',
        subtitle: exchangeProduct?.tyreReplacement
            ?.split(",")
            .map((value) => value.formatTyreText)
            .join(", "),
      ),
      MenuItem(
        title: '${LocaleKeys.expectedPrice.tr()} : ',
        subtitle: "${exchangeProduct?.expectedPrice ?? ""}",
      ),
      MenuItem(
        title: '${LocaleKeys.quotedPrice.tr()} : ',
        subtitle: "${exchangeProduct?.quotedPrice ?? ""}",
      ),
      MenuItem(
        title: '${LocaleKeys.purchasePrice.tr()} : ',
        subtitle: isInHouse ? "${exchangeProduct?.purchasePrice ?? ""}" : null,
      ),
      MenuItem(
        title: '${LocaleKeys.adjust.tr()} : ',
        subtitle:
            isInHouse
                ? exchangeProduct?.paymentMode == "Cashback"
                    ? "No"
                    : exchangeProduct?.paymentMode == "Adjust"
                    ? "Yes"
                    : null
                : null,
      ),
      MenuItem(
        title: '${LocaleKeys.interestedInExchange.tr()} : ',
        subtitle: "$isExchange" == "0" ? "No" : null,
      ),
    ].filteredNonEmptyItems;
  }

  LeadSource get leadSourceDetails {
    return LeadSource(
      source: leadSource,
      information: sourceOfInformation,
      otherReason: otherSourceOfInformation,
      referralName: referralName,
      referralNumber: referralNumber,
    );
  }

  InterestedInComp get interestedInCompDetails {
    return InterestedInComp(
      status: interestedInCompetition,
      model: competitionProduct?.id,
      brand: competitionProduct?.brand?.id,
    );
  }

  CustomerQuote get customerQuoteDetails {
    return CustomerQuote(
      tookQuote:
          sentQuote == 1
              ? CustomerQuoteState.yes.value
              : sentQuote == 0
              ? CustomerQuoteState.no.value
              : CustomerQuoteState.none.value,
      quoteDate: quoteDate,
    );
  }

  FirstTimeBuyer get exchangeCarDetails {
    final exchangeProduct = exchangeProducts?.firstOrNull?.variant?.product;

    if (exchangeProduct == null) {
      return FirstTimeBuyer(
        isExistingVehicle: isExistingVehicle,
        oldVehicleId: oldProduct?.brand?.id,
        oldVehicleName: oldProduct?.brand?.name,
        oldVehicleVariantId: oldProduct?.id,
        oldVehicleVariantName: oldProduct?.name,
      );
    }

    return FirstTimeBuyer(
      isExistingVehicle: isExistingVehicle,
      oldVehicleId: exchangeProduct.brand?.id,
      oldVehicleName: exchangeProduct.brand?.name,
      oldVehicleVariantId: exchangeProduct.id,
      oldVehicleVariantName: exchangeProduct.name,
    );
  }

  FirstTimeBuyer get oldVehicleDetails {
    Loggy("oldVehicleDetails").debug(isExistingVehicle);

    return FirstTimeBuyer(
      isExistingVehicle: isExistingVehicle,
      oldVehicleId: oldProduct?.brand?.id,
      oldVehicleVariantId: oldVehicleId,
      oldVehicleMakeYear: oldVehicleMakeYear,
    );
  }

  String get exchangeCarName {
    final brandName = oldProduct?.brand?.name ?? "";
    final modelName = oldProduct?.name ?? "";

    return "$brandName $modelName";
  }

  int? get interestedColorId {
    return interestedColor?.lastOrNull?.id;
  }

  String get latestFollowup {
    String value = "";
    final followupAction = workflow?.followupAction;
    final status = followupAction?.action;
    if (status != null) {
      value += "$status ";
    }
    final dateTime = followupAction?.dueDate;
    if (dateTime != null) {
      value += "${dateTime.formatDateTime(format: "MMM dd, yyyy hh:mm aa")} ";
    }

    return value;
  }

  String get previousComments {
    String value = "";
    final followupAction = workflow?.followupAction;
    final status = followupAction?.action;
    if (status != null) {
      value += "$status ";
    }
    final dateTime = followupAction?.dueDate;
    if (dateTime != null) {
      value += "${dateTime.formatDateTime(format: "MMM dd, yyyy hh:mm aa")} ";
    }

    return value;
  }

  List<Quotation> get previousQuotationRemarks {
    return (quotations ?? [])
        .where(
          (quotation) =>
              (quotation.remark ?? "").isNotEmpty &&
              quotation.createdAt != null,
        )
        .toList();
  }

  List<Quotation> get offerList {
    return (quotations?.whereOrNull(
              (quotation) =>
                  primaryVariantId == quotation.variantId &&
                  quotation.colorId == interestedColorId,
            ) ??
            [])
        .toList();
  }

  ExchangeHouseRequest get bookingExchangeHouse {
    final exchangeOuthouseReason = (booking?.bookingReasons ?? [])
        .lastWhereOrNull((reason) => reason.reasonType == "EXCHANGE_OUTHOUSE");
    final exchangeProduct = exchangeProducts?.lastOrNull;

    return ExchangeHouseRequest(
      exchangeType: booking?.exchangeType,
      reason: exchangeOuthouseReason?.reason,
      otherReason: exchangeOuthouseReason?.otherReason,
      approxValue: exchangeOuthouseReason?.exchangeBetterValue,
      purchasePrice: exchangeProduct?.purchasePrice,
      adjust: exchangeProduct?.paymentMode == "adjust",
    );
  }

  ExchangeProductImages get exchangeProductImages {
    final exchangeProduct = exchangeProducts?.firstOrNull;

    return ExchangeProductImages(
      insuranceImage: exchangeProduct?.imageInsurance?.documentUrlFromPath,
      rcFrontImage: exchangeProduct?.imageRcFront?.documentUrlFromPath,
      rcBackImage: exchangeProduct?.imageRcBack?.documentUrlFromPath,
      blueBookImage: exchangeProduct?.imageRcFront?.documentUrlFromPath,
      lotNoImage: exchangeProduct?.imageRcBack?.documentUrlFromPath,
      carImages: {
        1: exchangeProduct?.imageCarFront?.documentUrlFromPath,
        2: exchangeProduct?.imageCarBack?.documentUrlFromPath,
        3: exchangeProduct?.imageCarLeft?.documentUrlFromPath,
        4: exchangeProduct?.imageCarRight?.documentUrlFromPath,
        5: exchangeProduct?.imageCarInterior?.documentUrlFromPath,
      },
    );
  }

  Booking get bookingFormDetails {
    final currentTime = DateTime.now().formatDateTime();

    return (booking ?? const Booking()).copyWith(
      bookingDate: booking?.bookingDate ?? bookingDate ?? currentTime,
      expectedDelivery: booking?.expectedDelivery ?? currentTime,
    );
  }

  Delivery get deliveryFormDetails {
    final reasons = delivery?.deliveryReasons ?? [];
    List<String> getReasons(String type) {
      return reasons
          .where((reason) => reason.reasonType == type)
          .map((reason) => reason.reason ?? "")
          .where((reason) => reason.isNotEmpty)
          .toList();
    }

    final selectBrandReason = getReasons('REASON_FOR_SELECING_BRAND');
    final reasonForSelectingBrandOther = selectBrandReason.firstWhereOrNull(
      (reason) =>
          !SelectBrandReason.values
              .map((brandReason) => brandReason.value)
              .contains(reason),
    );

    return (delivery ?? const Delivery()).copyWith(
      deliveryDate: delivery?.deliveryDate ?? DateTime.now().formatDateTime(),
      pendingCommitment: delivery?.pendingCommitment,
      reasonForSelectingBrand: selectBrandReason,
      reasonForSelectingBrandOther: reasonForSelectingBrandOther,
    );
  }

  bool get showBookingDiscountApproval {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    return (workflow?.isBPR == true || workflow?.isCPA == true) &&
        (user?.isSalesManager == true || user?.isAdmin == true);
  }

  bool get showDeliveryDiscountApproval {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    return workflow?.isDPR == true &&
        (user?.isSalesManager == true || user?.isAdmin == true);
  }

  List<Scheme> getFilteredSchemes(List<Scheme> schemes) {
    final filtered = <Scheme>[].toList();

    for (var scheme in schemes) {
      switch (scheme.schemeType) {
        case "EXCHANGE":
          if (isExchange == 1) {
            filtered.add(scheme);
          }
          break;
        case "CORPORATE":
          if (customerType == CustomerType.corporate.value) {
            filtered.add(scheme);
          }
          break;
        case "LOYALTY":
          final oldProductId =
              exchangeProducts?.firstOrNull?.variant?.product?.brand?.id;
          final newProductId = primaryVariant?.product?.brandId;
          if (oldProductId == newProductId) {
            filtered.add(scheme);
          }
          break;
        default:
          filtered.add(scheme);
          break;
      }
    }

    return filtered;
  }

  bool get isFinance {
    return purchaseMode == PurchaseMode.finance.value;
  }

  List<InterestedVariant>? get sortedVariants {
    if (primaryVariant == null) return interestedVariant;

    return [
      primaryVariant!,
      ...(interestedVariant?.whereOrNull((e) => e.id != primaryVariantId) ??
          []),
    ];
  }

  InterestedVariant? get primaryVariant {
    return interestedVariant?.firstWhereOrNull((e) => e.id == primaryVariantId);
  }

  List<String> get inactiveBookingReasons {
    return (booking?.bookingReasons
                ?.whereOrNull(
                  (reason) => reason.reasonType == "BOOKING_INACTIVE",
                )
                ?.map((reason) => reason.reason ?? "") ??
            [])
        .toList();
  }

  bool get isFirstTimeBuyer {
    return isExistingVehicle == FirstTimeBuyerState.yes.value;
  }

  int get calculateEvaluationPriceDifference {
    final expectedPrice = exchangeProducts?.firstOrNull?.expectedPrice ?? 0;
    final quotedPrice = exchangeProducts?.firstOrNull?.quotedPrice ?? 0;

    return expectedPrice - quotedPrice;
  }

  bool get hasBookingFollowup {
    return workflow?.actions?.any((action) =>
            action.action?.toLowerCase() == 'booking_call' &&
            action.status == 1) ??
        false;
  }

  int? get openBookingFollowupId {
    return workflow?.actions
        ?.firstWhereOrNull((action) =>
            action.action?.toLowerCase() == 'booking_call' &&
            action.status == 1)
        ?.id;
  }
}

extension QuotationFieldExtension on QuotationField {
  int? get dealerDiscount {
    switch (priceOrSchemeType) {
      case 'scheme':
        return schemes?.firstOrNull?.schemeCost;
      case 'price':
        return discount;
      case 'accessories':
        final price = accessories?.firstOrNull?.price ?? 0;
        final dealerOutflow = (amount ?? 0) - (discount ?? 0);
        return price > dealerOutflow ? price - dealerOutflow : 0;
      default:
        return null;
    }
  }
}

extension QuotationExtension on Quotation {
  int get totalDiscount {
    return quotationFields
            ?.map(
              (quotation) => quotation.freeFlag == 1 ? 0 : quotation.discount,
            )
            .fold(0, (a, b) => (a ?? 0) + (b ?? 0)) ??
        0;
  }

  int get upfrontNotGiven {
    quotationFields?.forEach((f) {
      Loggy("").debug(f);
    });
    return quotationFields
            ?.map(
              (quotation) =>
                  ((quotation.schemes ?? []).isNotEmpty &&
                          quotation.schemeType == 0)
                      ? quotation.discount
                      : 0,
            )
            .fold(0, (a, b) => (a ?? 0) + (b ?? 0)) ??
        0;
  }

  int get totalFreeDiscount {
    return quotationFields
            ?.map(
              (quotation) => quotation.freeFlag == 1 ? quotation.discount : 0,
            )
            .fold(0, (a, b) => (a ?? 0) + (b ?? 0)) ??
        0;
  }

  int get totalCost {
    return (quotationFields ?? [])
            .map((quotation) => quotation.freeFlag == 1 ? 0 : quotation.amount)
            .fold(0, (a, b) => (a ?? 0) + (b ?? 0)) ??
        0;
  }

  int get totalDealerDiscount {
    return (quotationFields ?? [])
            .map((quotation) => quotation.dealerDiscount)
            .fold(0, (a, b) => (a ?? 0) + (b ?? 0)) ??
        0;
  }

  List<Scheme> get schemeList {
    return (quotationFields?.whereOrNull(
              (field) => field.priceOrSchemeType == "scheme",
            ) ??
            [])
        .expand((field) => field.schemes ?? <Scheme>[])
        .toList();
  }

  List<Accessory> get accessoriesList {
    return (quotationFields?.whereOrNull(
              (field) => field.priceOrSchemeType == "accessories",
            ) ??
            [])
        .expand((field) => field.accessories ?? <Accessory>[])
        .toList();
  }

  Quotation modifiedGroups(List<Price> prices) {
    return copyWith(
      quotationFields:
          (quotationFields?.map(
                    (field) => field.copyWith(
                      schemes:
                          field.schemes ??
                          [
                            prices
                                    .firstWhereOrNull(
                                      (price) =>
                                          price.name == field.description,
                                    )
                                    ?.scheme ??
                                const Scheme(),
                          ],
                      accessories:
                          field.accessories ??
                          [
                            prices
                                    .firstWhereOrNull(
                                      (price) =>
                                          price.name == field.description,
                                    )
                                    ?.accessory ??
                                const Accessory(),
                          ],
                    ),
                  ) ??
                  [])
              .toList(),
    );
  }
}

extension PricesExtension on List<Price> {
  int get totalDiscount {
    return map(
      (price) =>
          (price.ngnc ?? false) || (price.foc ?? false) || (price.free ?? false)
              ? 0
              : (price.discount ?? 0),
    ).fold(0, (value, element) => value + element);
  }

  int get totalCost {
    return map(
      (price) =>
          (price.ngnc ?? false) || (price.foc ?? false) || (price.free ?? false)
              ? 0
              : (price.amount ?? 0),
    ).fold(0, (value, element) => value + element);
  }
}

extension InterestedVariantExtension on InterestedVariant {
  String get carName {
    String value = "";
    final productName = product?.name ?? "";
    if (productName.isNotEmpty) {
      value += "$productName ";
    }
    value += variant ?? "";

    return value;
  }

  bool get hasEmptyField {
    return id == null || product?.id == null || engineType == null;
  }
}

extension CompetitionProductExtension on CompetitionProduct {
  String get carName {
    String value = "";
    final productName = brand?.name ?? "";
    if (productName.isNotEmpty) {
      value += "$productName ";
    }
    value += name ?? "";

    return value;
  }
}

extension GetLeadRequestExtension on GetLeadRequest {
  bool get isSearchApplied {
    return (search ?? "").trim().isNotEmpty &&
        (searchBy ?? "").trim().isNotEmpty;
  }

  bool get isSortApplied {
    return (orderBy ?? "").isNotEmpty;
  }

  bool isFilterSelected(MenuItem item) {
    if (item.title == LocaleKeys.lblLeadStatus.tr()) {
      return leadStatus != null;
    } else if (item.title == LocaleKeys.lblEnquiryPeriod.tr()) {
      return creationDateTo != null || creationDateFrom != null;
    } else if (item.title == LocaleKeys.lblModel.tr()) {
      return productIds != null;
    } else if (item.title == LocaleKeys.lblLeadSource.tr()) {
      return leadSources != null;
    } else if (item.title == LocaleKeys.lblMyLeads.tr()) {
      return myLeads != null;
    } else if (item.title == LocaleKeys.lblLeadType.tr()) {
      return leadState != null;
    } else if (item.title == LocaleKeys.lblScName.tr()) {
      return assignedTo != null || scType != null;
    } else if (item.title == LocaleKeys.lblExchange.tr()) {
      return isExchange != null;
    } else if (item.title == LocaleKeys.lblDmsId.tr()) {
      return dmsId != null;
    } else if (item.title == LocaleKeys.lblTestDrive.tr()) {
      return isTestDriveGiven != null;
    } else if (item.title == LocaleKeys.lblHomeVisit.tr()) {
      return followupStatus != null;
    } else if (item.title == LocaleKeys.lblExpectedDateOfDelivery.tr()) {
      return expectedDeliveryFrom != null || expectedDeliveryTo != null;
    } else if (item.title == LocaleKeys.lblDueDateOfFollowup.tr()) {
      return followupDueFrom != null || followupDueTo != null;
    } else if (item.title == LocaleKeys.lblDateOfLost.tr()) {
      return lostDateFrom != null || lostDateTo != null;
    } else if (item.title == LocaleKeys.lblDateOfClosed.tr()) {
      return closedDateFrom != null || closedDateTo != null;
    } else if (item.title == LocaleKeys.lblDateOfBooking.tr()) {
      return bookingDateTo != null || bookingDateFrom != null;
    } else if (item.title == LocaleKeys.lblDateOfDelivery.tr()) {
      return deliveryDateFrom != null || deliveryDateTo != null;
    } else if (item.title == LocaleKeys.lblDateOfBookingCancellation.tr()) {
      return cancelledDateFrom != null || cancelledDateTo != null;
    } else if (item.title == LocaleKeys.lblFollowType.tr()) {
      return followup != null;
    } else if (item.title == LocaleKeys.lblClosedReason.tr()) {
      return closedReason != null;
    } else if (item.title == LocaleKeys.lblLostReason.tr()) {
      return lostReason != null;
    } else if (item.title == LocaleKeys.lblEmail.tr()) {
      return searchBy != null || search != null;
    } else if (item.title == LocaleKeys.lblEmail.tr()) {
      return interestedInCompetition != null;
    } else if (item.title == LocaleKeys.lblExpectedMonthOfConversion.tr()) {
      return expectedMonthOfConversion != null;
    } else {
      return false;
    }
  }

  GetLeadRequest clearFilters() {
    return copyWith(
      leadStatus: null,
      creationDateFrom: null,
      creationDateTo: null,
      productIds: null,
      leadSources: null,
      myLeads: null,
      leadState: null,
      assignedTo: null,
      scType: null,
      isExchange: null,
      expectedDeliveryFrom: null,
      expectedDeliveryTo: null,
      followupDueFrom: null,
      followupDueTo: null,
      dmsId: null,
      isTestDriveGiven: null,
      followup: null,
      lostReason: null,
      closedReason: null,
      lostDateFrom: null,
      lostDateTo: null,
      closedDateFrom: null,
      closedDateTo: null,
      bookingDateFrom: null,
      bookingDateTo: null,
      deliveryDateFrom: null,
      deliveryDateTo: null,
      cancelledDateFrom: null,
      cancelledDateTo: null,
      search: null,
      searchBy: null,
      followupStatus: null,
      interestedInCompetition: null,
      expectedMonthOfConversion: null,
    );
  }

  GetLeadRequest get formattedFilters {
    final statusList = leadFiltersWorkflowStatusList;

    return copyWith(
      leadStatus: leadStatus
          ?.split(",")
          .where((value) => value.isNotEmpty)
          .map(
            (status) =>
                statusList
                    .whereOrNull((value) => value[1] == status)
                    ?.firstOrNull
                    ?.firstOrNull,
          )
          .where((value) => value != null && value.toString().isNotEmpty)
          .join(",")
          .replaceAll("+", ","),
    );
  }

  GetLeadRequest get createFilterRequest {
    final statusList = leadFiltersWorkflowStatusList;

    return copyWith(
      leadStatus: leadStatus
          ?.replaceFirst("epr,registered", "epr+registered")
          .split(",")
          .where((value) => value != "null" && value.isNotEmpty)
          .map(
            (status) =>
                statusList
                    .whereOrNull((value) => value[0] == status)
                    ?.firstOrNull
                    ?.lastOrNull,
          )
          .where((value) => value != null && value.toString().isNotEmpty)
          .join(","),
    );
  }
}

extension ExchangeHouseExtension on ExchangeHouseRequest {
  bool get isExchanged {
    return exchangeType == ExchangeType.inHouse.value && (adjust ?? false);
  }
}

extension InterestedVariants on List<InterestedVariant> {
  List<InterestedVariant> updatedVariants(InterestedVariant? newVariant) {
    if (newVariant == null) return this;

    final prevVariants = toList();
    if (prevVariants.any((prevVariant) => prevVariant.id == newVariant.id)) {
      return prevVariants;
    }

    prevVariants.insert(0, newVariant);
    return prevVariants;
  }

  List<InterestedVariant> onVariantRemoved(InterestedVariant toRemove) {
    final prevVariants = toList();
    prevVariants.removeWhere((variant) => variant.id == toRemove.id);

    return prevVariants;
  }
}

extension LeadCountsExtension on LeadCounts {
  int count(String status) {
    final statusMap = {
      WorkflowState.active.value.toLowerCase(): active,
      WorkflowState.booking.value.toLowerCase(): booking,
      WorkflowState.booked.value.toLowerCase(): booking,
      WorkflowState.bpr.value.toLowerCase(): bpr,
      "cancel booking": cancelledBooking,
      WorkflowState.closed.value.toLowerCase(): closed,
      WorkflowState.cpa.value.toLowerCase(): cpa,
      WorkflowState.delivered.value.toLowerCase(): delivery,
      WorkflowState.dpr.value.toLowerCase(): dpr,
      "inactive booking": inactiveBooking,
      WorkflowState.lost.value.toLowerCase(): lost,
      WorkflowState.lpa.value.toLowerCase(): lpa,
    };

    return statusMap[status.toLowerCase()] ?? 0;
  }
}