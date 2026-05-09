import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/constants/constant.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';

class LeadSourceType extends Constant<String> {
  final List<String> reasons;

  const LeadSourceType(super.value, this.reasons);

  static final walkIn = LeadSourceType(
    LocaleKeys.lblWalkIn.tr(),
    SourceOfInformationReasons.walkInReasons,
  );
  static final teleIn = LeadSourceType(
    LocaleKeys.lblTaleIn.tr(),
    SourceOfInformationReasons.teleInReasons,
  );
  static final digital = LeadSourceType(
    LocaleKeys.lblDigital.tr(),
    SourceOfInformationReasons.digitalReasons,
  );
  static final referral = LeadSourceType(
    LocaleKeys.lblReferral.tr(),
    SourceOfInformationReasons.referralReasons,
  );
  static final eventsAndPromotions = LeadSourceType(
    LocaleKeys.lblEventsAndPromotions.tr(),
    SourceOfInformationReasons.eventsAndPromotionsReasons,
  );
  static final institutional = LeadSourceType(
    LocaleKeys.lblInstitutional.tr(),
    SourceOfInformationReasons.institutionalReasons,
  );
  static final internalDatabaseSources = LeadSourceType(
    LocaleKeys.lblInternalDatabaseSources.tr(),
    SourceOfInformationReasons.internalDatabaseSourcesReasons,
  );
}

List<LeadSourceType> get leadSourcesList => [
  LeadSourceType.walkIn,
  LeadSourceType.teleIn,
  LeadSourceType.digital,
  LeadSourceType.referral,
  LeadSourceType.eventsAndPromotions,
  LeadSourceType.institutional,
  LeadSourceType.internalDatabaseSources,
];

class SourceOfInformationReasons {
  static String get othersValue => LocaleKeys.others.tr();

  static List<String> getSourceOfReasons(String? leadSource) {
    if (leadSource == LeadSourceType.walkIn.value) {
      return walkInReasons;
    }
    if (leadSource == LeadSourceType.teleIn.value) {
      return teleInReasons;
    }
    if (leadSource == LeadSourceType.digital.value) {
      return digitalReasons;
    }
    if (leadSource == LeadSourceType.referral.value) {
      return referralReasons;
    }
    if (leadSource == LeadSourceType.eventsAndPromotions.value) {
      return eventsAndPromotionsReasons;
    }
    if (leadSource == LeadSourceType.institutional.value) {
      return institutionalReasons;
    }
    if (leadSource == LeadSourceType.internalDatabaseSources.value) {
      return internalDatabaseSourcesReasons;
    }

    return [];
  }

  static final walkInReasons = [
    LocaleKeys.lblCallCenter.tr(),
    LocaleKeys.website.tr(),
    LocaleKeys.digitalMarketing.tr(),
    LocaleKeys.radio.tr(),
      LocaleKeys.lblPress.tr(),
    LocaleKeys.lblFacebookLeadGen.tr(),
    LocaleKeys.lblIkman.tr(),
    LocaleKeys.lblWhatsapp.tr(),
    LocaleKeys.lblDirect.tr(),
    LocaleKeys.lblHoarding.tr(),
    LocaleKeys.lblReferral.tr(),
    LocaleKeys.lblExistingCustomer.tr(),
    LocaleKeys.lblPersonalContact.tr(),
    LocaleKeys.tvcPole.tr(),
    LocaleKeys.lblActivity.tr(),
    othersValue,
  ];

  static final teleInReasons = [
    LocaleKeys.lblCallCenter.tr(),
    LocaleKeys.tvcPole.tr(),
    LocaleKeys.website.tr(),
    LocaleKeys.digitalMarketing.tr(),
    LocaleKeys.radio.tr(),
      LocaleKeys.lblPress.tr(),
         LocaleKeys.lblHoarding.tr(),
       LocaleKeys.lblActivity.tr(),
          LocaleKeys.lblReferral.tr(),
       LocaleKeys.lblExistingCustomer.tr(),
        LocaleKeys.lblPersonalContact.tr(),
    LocaleKeys.lblFacebookLeadGen.tr(),
    LocaleKeys.lblIkman.tr(),
    LocaleKeys.lblWhatsapp.tr(),
    othersValue,
  ];

  static List<String> get digitalReasons => [
    LocaleKeys.lblWebsiteLead.tr(),
    LocaleKeys.socialMedia.tr(),
    LocaleKeys.lblSearchEngine.tr(),
    LocaleKeys.lblAutoPortal.tr(),
    LocaleKeys.lblInfluencersAndReview.tr(),
    LocaleKeys.tvcPole.tr(),
    LocaleKeys.lblBlockAds.tr(),
  ];

  static List<String> get referralReasons => [
    LocaleKeys.lblExistingCustomer.tr(),
    LocaleKeys.lblFriendsAndFamily.tr(),
    LocaleKeys.lblBusinessNetwork.tr(),
    LocaleKeys.lblDirector.tr(),
  ];

  static List<String> get eventsAndPromotionsReasons => [
    LocaleKeys.lblAutoShow.tr(),
    LocaleKeys.lblRoadShow.tr(),
    LocaleKeys.lblMallDisplay.tr(),
    LocaleKeys.lblTestDriveCamp.tr(),
    LocaleKeys.lblActivations.tr(),
  ];

  static List<String> get institutionalReasons => [
    LocaleKeys.lblCorporateAndFleetCustomer.tr(),
    LocaleKeys.lblBanksAndFinancialInstitution.tr(),
  ];

  static List<String> get internalDatabaseSourcesReasons => [
    LocaleKeys.lblCrmFollowUp.tr(),
    LocaleKeys.lblOldEnquiry.tr(),
    LocaleKeys.lblExchange.tr(),
    LocaleKeys.lblUpgradeCustomer.tr(),
  ];
}
