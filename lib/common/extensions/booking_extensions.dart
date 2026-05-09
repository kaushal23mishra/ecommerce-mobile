import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/contact_type.dart';
import 'package:salesdocket_mobile/common/constants/customer_quote_state.dart';
import 'package:salesdocket_mobile/common/constants/profession.dart';
import 'package:salesdocket_mobile/common/constants/customer_type.dart';
import 'package:salesdocket_mobile/common/constants/document_type.dart';
import 'package:salesdocket_mobile/common/constants/purchase_mode.dart';
import 'package:salesdocket_mobile/common/entity/customer_quote.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/entity/interested_in_comp.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/common/entity/personal_details_images.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/user_utils.dart';

extension BookingExtensions on Booking {
  Booking initBooking(Lead? lead) {
    return copyWith(
      firstName: (firstName ?? "").isNotEmpty 
          ? firstName 
          : ((lead?.firstName ?? "").isNotEmpty ? lead!.firstName : lead?.leadFirstName),
      lastName: (lastName ?? "").isNotEmpty 
          ? lastName 
          : ((lead?.lastName ?? "").isNotEmpty ? lead!.lastName : lead?.leadLastName),
      salutation: (salutation ?? "").isNotEmpty ? salutation : lead?.salutation,
      profession: (profession ?? "").isNotEmpty ? profession : lead?.profession,
      otherProfession: (otherProfession ?? "").isNotEmpty ? otherProfession : lead?.otherProfession,
      address: address ?? lead?.address,
      phoneNumbers: (bookingPhoneNumbers ?? []).isNotEmpty 
          ? bookingPhoneNumbers 
          : ((phoneNumbers ?? []).isNotEmpty 
              ? phoneNumbers 
              : ((lead?.phoneNumbers ?? []).isNotEmpty ? lead!.phoneNumbers : null)),
      emails: (bookingEmails ?? []).isNotEmpty 
          ? bookingEmails 
          : ((emails ?? []).isNotEmpty 
              ? emails 
              : ((lead?.emails ?? []).isNotEmpty ? lead!.emails : null)),
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
    return const PanImages();
  }

  String get completeAddress {
    return UserUtils.completeAddress(address, locality);
  }

  List<MenuItem> bookingPersonalDetailItems(Lead? lead) {
    final booking = initBooking(lead);
    final computedAddress = booking.completeAddress;
    final bookingContactDetails = booking.contactDetails(null);
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    return [
      MenuItem(
        title: '${LocaleKeys.customerName.tr()} : ',
        subtitle: booking.fullName,
      ),
      MenuItem(
        title: '${LocaleKeys.mobileNo.tr()} : ',
        subtitle: bookingContactDetails
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
        subtitle: bookingContactDetails
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
        subtitle: booking.profession == Profession.other.value
            ? ((booking.otherProfession ?? "").isNotEmpty
                ? '${booking.profession} : ${booking.otherProfession}'
                : booking.profession)
            : booking.profession,
      ),
      MenuItem(
        title: '${LocaleKeys.dob.tr()} : ',
        subtitle: lead?.dob?.formatDateTime(inputFormat: "yyyy-MM-DD"),
      ),
    ].filteredNonEmptyItems;
  }

  List<MenuItem> bookingBuyingDetailItems(
    Lead? lead,
    TestDriveGiven? testDriveGiven,
    InterestedInComp? interestedInComp,
    FirstTimeBuyer? firstTimeBuyer,
    CustomerQuote? customerQuote,
  ) {
    final selectedCar = lead?.primaryVariant;
    final selectedCarColor = lead?.interestedColor?.lastOrNull;
    final effectivePurchaseMode = lead?.purchaseMode?.isNotEmpty == true ? lead?.purchaseMode : purchaseMode;
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
        subtitle: lead?.purchaseMode?.isNotEmpty == true ? lead?.purchaseMode : purchaseMode,
      ),
      MenuItem(
        title: '${LocaleKeys.financeForm.tr()} : ',
        subtitle: isFinance ? financeType : null,
      ),
      MenuItem(title: '${LocaleKeys.dsaName.tr()} : ', subtitle: dsaName),
      MenuItem(title: '${LocaleKeys.dsaMobile.tr()} : ', subtitle: dsaMobile),
      MenuItem(
        title: '${LocaleKeys.payoutPercentage.tr()} : ',
        subtitle:
            isFinance && financeType == FinanceForm.dO.value
                ? payoutPercentage != null
                    ? "$payoutPercentage %"
                    : null
                : null,
      ),
      MenuItem(
        title: '${LocaleKeys.lblReason.tr()} : ',
        subtitle:
            isFinance && financeType == FinanceForm.self.value
                ? (bookingReasons ?? [])
                    .map((reason) => reason.reason ?? "")
                    .where((reason) => reason.isNotEmpty)
                    .toList()
                    .join(",")
                : null,
      ),
    ].filteredNonEmptyItems;
  }
}

extension BookingLeadExtensions on Lead {
  List<MenuItem> get bookingExchangeDetailsItems {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );
    return [
      MenuItem(
        title: '${LocaleKeys.customerName.tr()} : ',
        subtitle: this.bookingFullName,
      ),
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

  List<MenuItem> get bookingOfferDetailsItems {
    return [
      MenuItem(title: '${LocaleKeys.customerName.tr()} : ', subtitle: bookingFullName),
      MenuItem(
        title: '${LocaleKeys.lblInterestedIn.tr()} : ',
        subtitle: carName,
      ),
    ].filteredNonEmptyItems;
  }
}

extension DocumentsExtensions on List<Document> {
  String? getDocument(DocumentType type) =>
      firstWhereOrNull((doc) => doc.documentType == type.value)?.fileName;
}
