import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/contact_type.dart';
import 'package:salesdocket_mobile/common/constants/customer_quote_state.dart';
import 'package:salesdocket_mobile/common/constants/profession.dart';
import 'package:salesdocket_mobile/common/constants/customer_type.dart';
import 'package:salesdocket_mobile/common/constants/document_type.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/customer_quote.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/entity/interested_in_comp.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/common/entity/personal_details_images.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/booking_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/user_utils.dart';
import '../constants/purchase_mode.dart';

extension DeliveryExtensions on Delivery {
  Delivery initDelivery(Lead? lead) {
    return copyWith(
      firstName: (firstName ?? "").isNotEmpty 
          ? firstName 
          : ((lead?.booking?.firstName ?? "").isNotEmpty ? lead!.booking!.firstName : lead?.firstName),
      lastName: (lastName ?? "").isNotEmpty 
          ? lastName 
          : ((lead?.booking?.lastName ?? "").isNotEmpty ? lead!.booking!.lastName : lead?.lastName),
      salutation: (salutation ?? "").isNotEmpty 
          ? salutation 
          : ((lead?.booking?.salutation ?? "").isNotEmpty ? lead!.booking!.salutation : lead?.salutation),
      address: address ?? lead?.booking?.address ?? lead?.address,
      profession: (profession ?? "").isNotEmpty
          ? profession
          : ((lead?.booking?.profession ?? "").isNotEmpty ? lead!.booking!.profession : lead?.profession),
      otherProfession: (otherProfession ?? "").isNotEmpty
          ? otherProfession
          : ((lead?.booking?.otherProfession ?? "").isNotEmpty ? lead!.booking!.otherProfession : lead?.otherProfession),
      documents:
          (documents ?? []).isNotEmpty ? documents : ((lead?.booking?.documents ?? []).isNotEmpty ? lead!.booking!.documents : null),
      documentValue: (documentValue ?? "").isNotEmpty 
          ? documentValue 
          : ((lead?.booking?.documentValue ?? "").isNotEmpty ? lead!.booking!.documentValue : null),
      documentValueType: (documentValueType ?? "").isNotEmpty 
          ? documentValueType 
          : ((lead?.booking?.documentValueType ?? "").isNotEmpty ? lead!.booking!.documentValueType : null),
      phoneNumbers: (deliveryPhoneNumbers ?? []).isNotEmpty 
          ? deliveryPhoneNumbers 
          : ((phoneNumbers ?? []).isNotEmpty 
              ? phoneNumbers 
              : ((lead?.booking?.phoneNumbers ?? []).isNotEmpty ? lead!.booking!.phoneNumbers : lead?.phoneNumbers)),
      emails: (deliveryEmails ?? []).isNotEmpty 
          ? deliveryEmails 
          : ((emails ?? []).isNotEmpty 
              ? emails 
              : ((lead?.booking?.emails ?? []).isNotEmpty ? lead!.booking!.emails : lead?.emails)),
    );
  }

  List<ContactDetails> contactDetails(Lead? lead) {
    return UserUtils.contactDetails(lead, phoneNumbers, emails);
  }

  String get fullNameWOSalutation {
    return UserUtils.fullName(
      salutation,
      firstName,
      lastName,
      includeSalutation: false,
    );
  }

  String get fullName {
    return UserUtils.fullName(salutation, firstName, lastName);
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

  PanImages get panImagesDetails {
    return PanImages(valueType: documentValueType, value: documentValue);
  }

  String get completeAddress {
    return UserUtils.completeAddress(address, locality);
  }

  List<MenuItem> deliveryPersonalDetailItems(Lead? lead) {
    final delivery = initDelivery(lead);
    final computedAddress = delivery.completeAddress;
    final deliveryContactDetails = delivery.contactDetails(null);
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    return [
      MenuItem(
        title: '${LocaleKeys.customerName.tr()} : ',
        subtitle: delivery.fullName,
      ),
      MenuItem(
        title: '${LocaleKeys.mobileNo.tr()} : ',
        subtitle: deliveryContactDetails
            .where((contact) => contact.type != ContactType.email.value)
            .map((phone) => phone.value ?? "")
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
        subtitle: deliveryContactDetails
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
                ? computedAddress.maskedPhoneNumber
                : computedAddress,
      ),
      MenuItem(
        title: '${LocaleKeys.typeOfCustomer.tr()} : ',
        subtitle: lead?.customerType,
      ),
      MenuItem(
        title: '${LocaleKeys.corporateName.tr()} : ',
        subtitle:
            lead?.customerType == CustomerType.corporate.value
                ? lead?.corporateName
                : null,
      ),
      MenuItem(
        title: '${LocaleKeys.profession.tr()} : ',
        subtitle: delivery.profession == Profession.other.value
            ? ((delivery.otherProfession ?? "").isNotEmpty
                ? '${delivery.profession} : ${delivery.otherProfession}'
                : delivery.profession)
            : delivery.profession,
      ),
      MenuItem(
        title: '${LocaleKeys.dob.tr()} : ',
        subtitle: lead?.dob?.formatDateTime(inputFormat: "yyyy-MM-DD"),
      ),
    ].filteredNonEmptyItems;
  }

  List<MenuItem> deliveryBuyingDetailItems(
    Lead? lead,
    TestDriveGiven? testDriveGiven,
    InterestedInComp? interestedInComp,
    FirstTimeBuyer? firstTimeBuyer,
    CustomerQuote? customerQuote,
  ) {
    final booking = lead?.booking;
    final selectedCar = lead?.primaryVariant;
    final selectedCarColor = lead?.interestedColor?.lastOrNull;
    final effectivePurchaseMode = lead?.purchaseMode?.isNotEmpty == true
        ? lead?.purchaseMode
        : (purchaseMode?.isNotEmpty == true ? purchaseMode : booking?.purchaseMode);
    final bool isFinance = effectivePurchaseMode == PurchaseMode.finance.value;

    return [
      MenuItem(
        title: '${LocaleKeys.lblInterestedIn.tr()} : ',
        subtitle: selectedCar?.carName,
      ),
      MenuItem(
        title: '${LocaleKeys.color.tr()} : ',
        subtitle: selectedCarColor?.color,
      ),
      MenuItem(
        title: '${LocaleKeys.lblDidCustomerTakeQuote.tr()} : ',
        subtitle: customerQuote?.tookQuoteLabel,
      ),
      MenuItem(
        title: '${LocaleKeys.lblQuoteDate.tr()} : ',
        subtitle: customerQuote?.quoteDateLabel?.formatDateTime(),
      ),
      MenuItem(
        title: '${LocaleKeys.testDriveGiven.tr()} : ',
        subtitle: testDriveGiven?.testDrivenGivenLabel,
      ),
      MenuItem(
        title: 'Test Drive Details : ',
        subtitle: testDriveGiven?.testDriveDetails,
      ),
      MenuItem(
        title: 'Why Not Given : ',
        subtitle: testDriveGiven?.whyNotGiven,
      ),
      MenuItem(
        title: '${LocaleKeys.interestedInCompetition.tr()} : ',
        subtitle: interestedInComp?.statusLabel,
      ),
      MenuItem(
        title: '${LocaleKeys.interestedInCompetition.tr()} Vehicle : ',
        subtitle: interestedInComp?.vehicle,
      ),
      MenuItem(
        title: '${LocaleKeys.firstTimeBuyer.tr()} : ',
        subtitle: firstTimeBuyer?.existingLabel,
      ),
      MenuItem(
        title: 'Old Vehicle : ',
        subtitle: firstTimeBuyer?.vehicleDetails,
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
        title: '${LocaleKeys.dsaName.tr()} : ',
        subtitle: booking?.dsaName,
      ),
      MenuItem(
        title: '${LocaleKeys.dsaMobile.tr()} : ',
        subtitle: booking?.dsaMobile,
      ),
      MenuItem(
        title: '${LocaleKeys.payoutPercentage.tr()} : ',
        subtitle:
            isFinance && booking?.financeType == FinanceForm.dO.value
                ? booking?.payoutPercentage != null
                    ? "${booking?.payoutPercentage} %"
                    : null
                : null,
      ),
      MenuItem(
        title: '${LocaleKeys.lblReason.tr()} : ',
        subtitle:
            isFinance && booking?.financeType == FinanceForm.self.value
                ? (booking?.bookingReasons ?? [])
                    .map((reason) => reason.reason ?? "")
                    .where((reason) => reason.isNotEmpty)
                    .toList()
                    .join(",")
                : null,
      ),
      MenuItem(
        title: '${LocaleKeys.disbursalAmount.tr()} : ',
        subtitle:
            isFinance
                ? booking?.disbursalAmount?.formatIndianCommas ?? ""
                : null,
      ),
    ].filteredNonEmptyItems;
  }

  Map<FormFields, dynamic> setFormFields() {
    return {};
  }
}

extension DeliveryLeadExtensions on Lead {
  List<MenuItem> get deliveryExchangeDetailsItems {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );
    return [
      MenuItem(title: '${LocaleKeys.customerName.tr()} : ', subtitle: this.deliveryFullName),
      MenuItem(
        title: '${LocaleKeys.mobileNo.tr()} : ',
        subtitle: contactDetails
            .where((contact) => contact.type != ContactType.email.value)
            .map((phone) => phone.value ?? "")
            .toSet()
            .where((phone) => phone.isNotEmpty)
            .map(
              (phone) =>
                  (user?.maskMobile ?? false) ? phone.maskedPhoneNumber : phone,
            )
            .join(", "),
      ),
      MenuItem(
        title: '${LocaleKeys.lblInterestedIn.tr()} : ',
        subtitle: carName,
      ),
    ].filteredNonEmptyItems;
  }

  List<MenuItem> get deliveryOfferDetailsItems {
    return [
      MenuItem(title: '${LocaleKeys.customerName.tr()} : ', subtitle: this.deliveryFullName),
      MenuItem(
        title: '${LocaleKeys.lblInterestedIn.tr()} : ',
        subtitle: carName,
      ),
    ].filteredNonEmptyItems;
  }

  List<MenuItem> get deliveryPaymentDetailsItems {
    return [
      MenuItem(title: '${LocaleKeys.customerName.tr()} : ', subtitle: this.deliveryFullName),
      MenuItem(
        title: '${LocaleKeys.lblInterestedIn.tr()} : ',
        subtitle: carName,
      ),
    ].filteredNonEmptyItems;
  }
}
