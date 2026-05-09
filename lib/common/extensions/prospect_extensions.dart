import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/contact_type.dart';
import 'package:salesdocket_mobile/common/constants/customer_type.dart';
import 'package:salesdocket_mobile/common/constants/lead_source_type.dart';
import 'package:salesdocket_mobile/common/constants/profession.dart';
import 'package:salesdocket_mobile/common/entity/customer_quote.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/entity/interested_in_comp.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';

import '../entity/lead_source.dart';

extension ProspectLeadExtenions on Lead {
  MenuItem get mobileDetailsItem {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    return MenuItem(
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
    );
  }

  MenuItem get emailDetailsItem {
    return MenuItem(
      title: '${LocaleKeys.email.tr()} : ',
      subtitle: contactDetails
          .where((contact) => contact.type == ContactType.email.value)
          .map((email) => email.value ?? "")
          .toSet()
          .where((email) => email.isNotEmpty)
          .join(", "),
    );
  }

  MenuItem get addressDetailsItem {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    return MenuItem(
      title: '${LocaleKeys.address.tr()} : ',
      subtitle:
          (user?.maskAddress ?? false)
              ? completeAddress.maskedPhoneNumber
              : completeAddress,
    );
  }

  List<MenuItem> get prospectPersonalDetailsItems {
    return [
      MenuItem(title: '${LocaleKeys.customerName.tr()} : ', subtitle: prospectFullName),
      MenuItem(
        title: '${LocaleKeys.lblInterestedIn.tr()} : ',
        subtitle: carName,
      ),
      mobileDetailsItem,
      emailDetailsItem,
      addressDetailsItem,
      MenuItem(title: '${LocaleKeys.dmsId.tr()} : ', subtitle: dmsId),
      MenuItem(
        title: '${LocaleKeys.scName.tr()} : ',
        subtitle: assigned?.fullName,
      ),
      MenuItem(
        title: '${LocaleKeys.typeOfCustomer.tr()} : ',
        subtitle: customerType,
      ),
      MenuItem(
        title: '${LocaleKeys.corporateName.tr()} : ',
        subtitle:
            customerType == CustomerType.corporate.value ? corporateName : null,
      ),
      MenuItem(
        title: '${LocaleKeys.profession.tr()} : ',
        subtitle: profession == Profession.other.value
            ? ((otherProfession ?? "").isNotEmpty
                ? '$profession : $otherProfession'
                : profession)
            : profession,
      ),
      MenuItem(
        title: '${LocaleKeys.dob.tr()} : ',
        subtitle: dob?.formatDateTime(inputFormat: "yyyy-MM-DD"),
      ),
    ].filteredNonEmptyItems;
  }

  List<MenuItem> prospectBuyingDetailsItems({
    TestDriveGiven? testDriveGiven,
    FirstTimeBuyer? firstTimeBuyer,
    InterestedInComp? interestedInComp,
    CustomerQuote? customerQuote,
    LeadSource? selectedLeadSource,
  }) {
    return [
      MenuItem(title: '${LocaleKeys.customerName.tr()} : ', subtitle: prospectFullName),
      MenuItem(
        title: '${LocaleKeys.lblInterestedIn.tr()} : ',
        subtitle: carName,
      ),
      MenuItem(
        title: '${LocaleKeys.color.tr()} : ',
        subtitle: interestedColor?.lastOrNull?.color,
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
        title: '${LocaleKeys.lblLeadSource.tr()} : ',
        subtitle: selectedLeadSource?.source ?? leadSource,
      ),
      MenuItem(
        title: '${LocaleKeys.sourceOfInformation.tr()} : ',
        subtitle: (selectedLeadSource?.information == SourceOfInformationReasons.othersValue)
            ? ((selectedLeadSource?.otherReason ?? "").isNotEmpty
                ? '${selectedLeadSource?.information} : ${selectedLeadSource?.otherReason}'
                : selectedLeadSource?.information)
            : (selectedLeadSource?.information ??
                (sourceOfInformation == SourceOfInformationReasons.othersValue
                    ? ((otherSourceOfInformation ?? "").isNotEmpty
                        ? '$sourceOfInformation : $otherSourceOfInformation'
                        : sourceOfInformation)
                    : sourceOfInformation)),
      ),
      MenuItem(
        title: '${selectedLeadSource?.source == LeadSourceType.institutional.value ? 'Institution' : 'Referral'} Name : ',
        subtitle: selectedLeadSource?.referralName,
      ),
      MenuItem(
        title: '${selectedLeadSource?.source == LeadSourceType.institutional.value ? 'Institution' : 'Referral'} Number : ',
        subtitle: selectedLeadSource?.referralNumber,
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
        title: '${LocaleKeys.lblModeOfPurchase.tr()} : ',
        subtitle: purchaseMode,
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
    ].filteredNonEmptyItems;
  }

  List<MenuItem> get prospectExchangeDetailsItems {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );
    return [
      MenuItem(title: '${LocaleKeys.customerName.tr()} : ', subtitle: prospectFullName),
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

  List<MenuItem> get prospectOfferDetailsItems {
    return [
      MenuItem(title: '${LocaleKeys.customerName.tr()} : ', subtitle: prospectFullName),
      MenuItem(
        title: '${LocaleKeys.lblInterestedIn.tr()} : ',
        subtitle: carName,
      ),
    ].filteredNonEmptyItems;
  }

  List<MenuItem> get prospectPlanFollowupDetailsItems {
    return [
      MenuItem(title: '${LocaleKeys.customerName.tr()} : ', subtitle: prospectFullName),
      MenuItem(
        title: '${LocaleKeys.lblInterestedIn.tr()} : ',
        subtitle: carName,
      ),
    ].filteredNonEmptyItems;
  }
}
