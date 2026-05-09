import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/features/lead/presentation/lead_filter/lead_filters.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';

class LeadFilterItemsUtils {
  static MenuItem get leadStatus => MenuItem(
    title: LocaleKeys.lblLeadStatus.tr(),
    content: const LeadStatusWidget(),
  );

  static MenuItem get enquiryPeriod => MenuItem(
    title: LocaleKeys.lblEnquiryPeriod.tr(),
    content: const EnquiryPeriodWidget(),
  );

  static MenuItem get model =>
      MenuItem(title: LocaleKeys.lblModel.tr(), content: const ModelsWidget());

  static MenuItem get leadSource => MenuItem(
    title: LocaleKeys.lblLeadSource.tr(),
    content: const LeadSourceWidget(),
  );

  static MenuItem get leadType => MenuItem(
    title: LocaleKeys.lblLeadType.tr(),
    content: const LeadTypeWidget(),
  );

  static MenuItem get scName => MenuItem(
    title: LocaleKeys.lblScName.tr(),
    content: const ScNamesWidget(),
  );

  static MenuItem get exchange => MenuItem(
    title: LocaleKeys.lblExchange.tr(),
    content: const ExchangeWidget(),
  );

  static MenuItem get expectedDeliveryDate => MenuItem(
    title: LocaleKeys.lblExpectedDateOfDelivery.tr(),
    content: const ExpectedDeliveryDateWidget(),
  );

  static MenuItem get followupDueDate => MenuItem(
    title: LocaleKeys.lblDueDateOfFollowup.tr(),
    content: const FollowupDueDateWidget(),
  );

  static MenuItem get dmsId =>
      MenuItem(title: LocaleKeys.lblDmsId.tr(), content: const DmsIdWidget());

  static MenuItem get testDrive => MenuItem(
    title: LocaleKeys.lblTestDrive.tr(),
    content: const TestDriveWidget(),
  );

  static MenuItem get followupType => MenuItem(
    title: LocaleKeys.lblFollowType.tr(),
    content: const FollowupTypeWidget(),
  );

  static MenuItem get lostReason => MenuItem(
    title: LocaleKeys.lblLostReason.tr(),
    content: const LostReasonWidget(),
  );

  static MenuItem get closedReason => MenuItem(
    title: LocaleKeys.lblClosedReason.tr(),
    content: const ClosedReasonWidget(),
  );

  static MenuItem get dateOfLost => MenuItem(
    title: LocaleKeys.lblDateOfLost.tr(),
    content: const DateOfLostWidget(),
  );

  static MenuItem get dateOfClosed => MenuItem(
    title: LocaleKeys.lblDateOfClosed.tr(),
    content: const DateOfClosedWidget(),
  );

  static MenuItem get dateOfBooking => MenuItem(
    title: LocaleKeys.lblDateOfBooking.tr(),
    content: const DateOfBookingWidget(),
  );

  static MenuItem get dateOfDelivery => MenuItem(
    title: LocaleKeys.lblDateOfDelivery.tr(),
    content: const DateOfDeliveryWidget(),
  );

  static MenuItem get dateOfBookingCancellation => MenuItem(
    title: LocaleKeys.lblDateOfBookingCancellation.tr(),
    content: const DateOfBookingCancellationWidget(),
  );

  static MenuItem get email =>
      MenuItem(title: LocaleKeys.lblEmail.tr(), content: const EmailWidget());

  static MenuItem get homeVisit => MenuItem(
    title: LocaleKeys.lblHomeVisit.tr(),
    content: const HomeVisitWidget(),
  );

  static MenuItem get interestedInCompetition => MenuItem(
    title: LocaleKeys.lblInterestedInCompetition.tr(),
    content: const InterestedInCompetitionWidget(),
  );

  static MenuItem get expectedMonthOfConversion => MenuItem(
    title: LocaleKeys.lblExpectedMonthOfConversion.tr(),
    content: const ExpectedMonthOfConversionWidget(),
  );

  static MenuItem get myLeads {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );
    final show = user?.isAdmin == true || user?.isSalesManager == true;

    return MenuItem(
      title: LocaleKeys.lblMyLeads.tr(),
      content: const MyLeadsWidget(),
      show: show,
    );
  }
}

class LeadFilterItemListUtils {
  static List<MenuItem> get allLeads => [
    LeadFilterItemsUtils.leadStatus,
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.enquiryPeriod,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.leadType,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.expectedDeliveryDate,
    LeadFilterItemsUtils.followupDueDate,
    LeadFilterItemsUtils.dmsId,
    LeadFilterItemsUtils.testDrive,
    LeadFilterItemsUtils.followupType,
    LeadFilterItemsUtils.lostReason,
    LeadFilterItemsUtils.closedReason,
    LeadFilterItemsUtils.dateOfLost,
    LeadFilterItemsUtils.dateOfClosed,
    LeadFilterItemsUtils.dateOfBooking,
    LeadFilterItemsUtils.dateOfDelivery,
    LeadFilterItemsUtils.dateOfBookingCancellation,
    LeadFilterItemsUtils.email,
    LeadFilterItemsUtils.homeVisit,
    LeadFilterItemsUtils.interestedInCompetition,
    LeadFilterItemsUtils.expectedMonthOfConversion,
  ];

  static List<MenuItem> get hotLeads => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.enquiryPeriod,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.dmsId,
    LeadFilterItemsUtils.testDrive,
    // LeadFilterItemsUtils.homeVisit,
  ];

  static List<MenuItem> get registered => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.enquiryPeriod,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.followupDueDate,
    LeadFilterItemsUtils.followupType,
  ];

  static List<MenuItem> get warmLeads => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.enquiryPeriod,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.dmsId,
    LeadFilterItemsUtils.testDrive,
    // LeadFilterItemsUtils.homeVisit,
  ];

  static List<MenuItem> get coldLeads => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.enquiryPeriod,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.dmsId,
    LeadFilterItemsUtils.testDrive,
    // LeadFilterItemsUtils.homeVisit,
  ];

  static List<MenuItem> get epr => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.enquiryPeriod,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.followupDueDate,
    LeadFilterItemsUtils.followupType,
  ];

  static List<MenuItem> get lpa => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.leadStatus,
    LeadFilterItemsUtils.enquiryPeriod,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.leadType,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.expectedDeliveryDate,
    LeadFilterItemsUtils.followupDueDate,
    LeadFilterItemsUtils.dmsId,
    LeadFilterItemsUtils.testDrive,
    LeadFilterItemsUtils.followupType,
    LeadFilterItemsUtils.lostReason,
    LeadFilterItemsUtils.closedReason,
    LeadFilterItemsUtils.dateOfLost,
    LeadFilterItemsUtils.dateOfClosed,
    LeadFilterItemsUtils.dateOfBooking,
    LeadFilterItemsUtils.dateOfDelivery,
    LeadFilterItemsUtils.dateOfBookingCancellation,
    LeadFilterItemsUtils.email,
    // LeadFilterItemsUtils.homeVisit,
    LeadFilterItemsUtils.interestedInCompetition,
    LeadFilterItemsUtils.expectedMonthOfConversion,
  ];

  static List<MenuItem> get activeBookings => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.followupDueDate,
    LeadFilterItemsUtils.dmsId,
    LeadFilterItemsUtils.testDrive,
    LeadFilterItemsUtils.dateOfBooking,
    LeadFilterItemsUtils.dateOfDelivery,
    // LeadFilterItemsUtils.homeVisit,
  ];

  static List<MenuItem> get deliveries => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.followupDueDate,
    LeadFilterItemsUtils.dmsId,
    LeadFilterItemsUtils.testDrive,
    LeadFilterItemsUtils.dateOfBooking,
    LeadFilterItemsUtils.dateOfDelivery,
    // LeadFilterItemsUtils.homeVisit,
  ];

  static List<MenuItem> get lostLeads => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.followupDueDate,
    LeadFilterItemsUtils.dmsId,
    LeadFilterItemsUtils.testDrive,
    LeadFilterItemsUtils.lostReason,
    LeadFilterItemsUtils.dateOfLost,
    // LeadFilterItemsUtils.homeVisit,
  ];

  static List<MenuItem> get closed => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.leadType,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.dmsId,
    LeadFilterItemsUtils.testDrive,
    LeadFilterItemsUtils.closedReason,
    LeadFilterItemsUtils.dateOfClosed,
    // LeadFilterItemsUtils.homeVisit,
  ];

  static List<MenuItem> get bpr => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.dmsId,
  ];

  static List<MenuItem> get cpa => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.dmsId,
    LeadFilterItemsUtils.testDrive,
    LeadFilterItemsUtils.dateOfBooking,
    // LeadFilterItemsUtils.homeVisit,
  ];

  static List<MenuItem> get inactiveBooking => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.dmsId,
    LeadFilterItemsUtils.testDrive,
    LeadFilterItemsUtils.dateOfBooking,
    // LeadFilterItemsUtils.homeVisit,
  ];

  static List<MenuItem> get cancelledBooking => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.leadType,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.dmsId,
    LeadFilterItemsUtils.testDrive,
    LeadFilterItemsUtils.dateOfBooking,
    LeadFilterItemsUtils.dateOfBookingCancellation,
    // LeadFilterItemsUtils.homeVisit,
  ];

  static List<MenuItem> get dpr => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.dmsId,
  ];

  static List<MenuItem> get transferredLeads => [];

  static List<MenuItem> get hoLead => [];

  static List<MenuItem> get call => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.enquiryPeriod,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.leadType,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.followupDueDate,
    LeadFilterItemsUtils.dmsId,
    LeadFilterItemsUtils.testDrive,
    // LeadFilterItemsUtils.homeVisit,
  ];

  static List<MenuItem> get homeVisit => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.enquiryPeriod,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.leadType,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.followupDueDate,
    LeadFilterItemsUtils.dmsId,
    LeadFilterItemsUtils.testDrive,
    // LeadFilterItemsUtils.homeVisit,
  ];

  static List<MenuItem> get showroomVisit => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.enquiryPeriod,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.leadType,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.followupDueDate,
    LeadFilterItemsUtils.dmsId,
    LeadFilterItemsUtils.testDrive,
    // LeadFilterItemsUtils.homeVisit,
  ];

  static List<MenuItem> get activeNoTestDrive => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.enquiryPeriod,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.followupDueDate,
    LeadFilterItemsUtils.followupType,
  ];

  static List<MenuItem> get coldCalling => [];

  static List<MenuItem> get bookingFollowup => [
    LeadFilterItemsUtils.myLeads,
    LeadFilterItemsUtils.model,
    LeadFilterItemsUtils.leadSource,
    LeadFilterItemsUtils.scName,
    LeadFilterItemsUtils.exchange,
    LeadFilterItemsUtils.testDrive,
    LeadFilterItemsUtils.followupDueDate,
  ];
}
