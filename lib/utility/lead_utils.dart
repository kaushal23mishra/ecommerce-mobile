import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/contact_type.dart';
import 'package:salesdocket_mobile/common/constants/follow_up_plan_type.dart';
import 'package:salesdocket_mobile/common/constants/interested_in_exchange_state.dart';
import 'package:salesdocket_mobile/common/constants/lead_state.dart';
import 'package:salesdocket_mobile/common/constants/purchase_mode.dart';
import 'package:salesdocket_mobile/common/constants/strings.dart';
import 'package:salesdocket_mobile/common/constants/user_type.dart';
import 'package:salesdocket_mobile/common/constants/workflow_state.dart';
import 'package:salesdocket_mobile/common/entity/menu_item.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/number_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/workflow_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/classes/ui_component_widget.dart';

class LeadUtils with UiComponentWidget {
  @override
  bool get isMounted => true;

  Map<String, Color> get leadStateColors {
    return {
      LeadState.hot.value: appColors.redMedium,
      LeadState.warm.value: appColors.orangeMedium,
      LeadState.cold.value: appColors.blueMedium,
    };
  }

  static Map<String, String> get leadStateValues {
    return {
      WorkflowState.delivered.value: "DEL",
      WorkflowState.booked.value: "BKD",
      WorkflowState.lost.value: "LOST",
      WorkflowState.closed.value: "CLOSED",
      WorkflowState.dpr.value: "DPR",
      WorkflowState.bpr.value: "BPR",
      WorkflowState.cpa.value: "CPA",
      WorkflowState.lpa.value: "LPA",
      WorkflowState.epr.value: "EPR",
      WorkflowState.inactive.value: "Inactive",
      WorkflowState.cancelled.value: "Cancelled",
      WorkflowState.registered.value: "Registered",
      WorkflowState.none.value: "EPR",
    };
  }

  static List<MenuItem> getDetailItems(
    Lead lead, {
    bool showEvaluationDetails = false,
  }) {
    final user = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    return [
      MenuItem(title: "${LocaleKeys.lblDmsId.tr()}:", subtitle: lead.dmsId),
      MenuItem(
        title: "${LocaleKeys.lblDateOfEnquiry.tr()}:",
        subtitle:
            lead.createdOn?.formatDateTime() ??
            (lead.followups?.isNotEmpty == true
                ? lead.followups!.first.followupDueAt?.formatDateTime()
                : ""),
      ),

      MenuItem(
        title: "${LocaleKeys.lblEpr.tr()} Created Date:",
        subtitle:
            lead.createdOn?.formatDateTime() ??
            (lead.followups?.isNotEmpty == true
                ? lead.followups!.first.createdAt?.formatDateTime()
                : ""),
      ),
      MenuItem(
        title: "${LocaleKeys.lblBpr.tr()}:",
        subtitle: lead.dateOfBPR?.formatDateTime(),
        show: lead.workflow.isBPR,
      ),
      MenuItem(
        title: "${LocaleKeys.lblDateOfBooking.tr()}:",
        subtitle: lead.bookingDate?.formatDateTime(),
        show: lead.workflow.isBooked || lead.workflow.isDelivered,
      ),
      MenuItem(
        title: "${LocaleKeys.lblDateOfDelivery.tr()}:",
        subtitle: lead.deliveryDate?.formatDateTime(),
        show: lead.workflow.isDelivered,
      ),
      MenuItem(
        title: "${LocaleKeys.lblDateOfLost.tr()}:",
        subtitle: lead.workflow?.updatedOn?.formatDateTime(),
        show: lead.workflow.isLost,
      ),
      MenuItem(
        title: "${LocaleKeys.lblDateOfClosed.tr()}:",
        subtitle: lead.workflow?.updatedOn?.formatDateTime(),
        show: lead.workflow.isClosed,
      ),
      MenuItem(
        title: "${LocaleKeys.lblReason.tr()} -",
        subtitle: lead.workflow?.closedReason ?? "N/A",
        show:
            lead.workflow.isClosed &&
            (lead.workflow?.closedReason ?? "").isNotEmpty,
      ),
      MenuItem(
        title: "${LocaleKeys.expectedPrice.tr()}:",
        subtitle:
            lead.exchangeProducts?.firstOrNull?.expectedPrice?.toString() ?? "",
        show:
            (!(user?.isEvaluator ?? false) || showEvaluationDetails) &&
            (lead.exchangeProducts?.firstOrNull?.expectedPrice != null),
      ),
      MenuItem(
        title: "${LocaleKeys.quotedPrice.tr()}:",
        subtitle:
            lead.exchangeProducts?.firstOrNull?.quotedPrice?.toString() ?? "",
        show:
            (!(user?.isEvaluator ?? false) || showEvaluationDetails) &&
            (lead.exchangeProducts?.firstOrNull?.quotedPrice != null),
      ),
      MenuItem(
        title: "${LocaleKeys.difference.tr()}:",
        subtitle: lead.calculateEvaluationPriceDifference.toString(),
        show: showEvaluationDetails,
      ),
      MenuItem(
        title: lead.assigned?.userType == 1 ? "SM -" : "SC -",
        subtitle: lead.assigned?.fullName,
        show:
            [
              UserType.admin.value,
              UserType.salesManager.value,
            ].contains(user?.type) &&
            (lead.assigned?.firstName ?? "").isNotEmpty,
      ),
      MenuItem(
        title: "${LocaleKeys.lblTransferLead.tr()} From:",
        subtitle: lead.creator?.fullName,
        show:
            lead.assigned?.id != lead.creator?.id &&
            (lead.creator?.firstName ?? "").isNotEmpty,
      ),
      MenuItem(
        title: "SM -",
        subtitle: lead.smReceiver?.fullName,
        show:
            (lead.workflow?.isBPR == true) &&
            [
              UserType.admin.value,
              UserType.salesManager.value,
              UserType.salesConsultant.value,
            ].contains(user?.type) &&
            (lead.smReceiver?.firstName ?? "").isNotEmpty,
      ),
      MenuItem(
        title: "SM -",
        subtitle: lead.dprSmReceiver?.fullName,
        show:
            lead.workflow.isDPR == true &&
            [
              UserType.admin.value,
              UserType.salesManager.value,
              UserType.salesConsultant.value,
            ].contains(user?.type) &&
            (lead.dprSmReceiver?.firstName ?? "").isNotEmpty,
      ),
      MenuItem(
        title: "${lead.cpaReceiver?.isAdmin == true ? "Admin" : "SM"} -",
        subtitle: lead.cpaReceiver?.fullName,
        show:
            (lead.workflow?.isCPA == true) &&
            [
              UserType.admin.value,
              UserType.salesManager.value,
              UserType.salesConsultant.value,
            ].contains(user?.type) &&
            (lead.cpaReceiver?.firstName ?? "").isNotEmpty,
      ),
      MenuItem(
        title: "Evaluator -",
        subtitle: lead.lpaValidator?.fullName,
        show:
            (lead.workflow.isLost || lead.workflow.isLPA) &&
            (lead.lpaValidator?.firstName ?? "").isNotEmpty,
      ),
      MenuItem(
        title: "${LocaleKeys.lblReject.tr()} -",
        subtitle: lead.cancellationReason,
        show:
            (lead.workflow.isBPR || lead.workflow.isDPR) &&
            !lead.cancellationReason.isNullOrEmpty,
      ),
      MenuItem(
        title: "${LocaleKeys.lblReason.tr()} -",
        subtitle: lead.inactiveBookingReasons.join(", "),
        show:
            lead.workflow.isInactive && lead.inactiveBookingReasons.isNotEmpty,
      ),
      MenuItem(
        title: lead.workflow?.lostTo?.isNullOrEmpty == true ? "N/A" : LocaleKeys.lostTo.tr(),
        subtitle:
            (lead.workflow?.lostTo ?? "").isEmpty
                ? ""
                : "${lead.workflow?.lostTo}",
        show: lead.workflow.isLPA || lead.workflow.isLost,
      ),
      MenuItem(
        title:
            lead.workflow?.lostToCoDealerName?.isNullOrEmpty == true
                ? "N/a"
                : "Lost to Co-Dealer Name",
        subtitle:
            (lead.workflow?.lostToCoDealerName ?? "").isEmpty
                ? ""
                : "${lead.workflow?.lostToCoDealerName}",
        show: lead.workflow.isLPA || lead.workflow.isLost,
      ),
      MenuItem(
        title: "${LocaleKeys.difference.tr()} (Quoted & Expected): ",
        subtitle:
            lead.exchangeProducts?.firstOrNull?.priceDifference.isNullOrEmpty ??
                    true
                ? ''
                : lead.exchangeProducts?.firstOrNull?.priceDifference
                        ?.replaceFirst('-', '') ??
                    '',
        show:
            lead.isEC &&
            (user?.isEvaluator ?? false) &&
            !(lead
                    .exchangeProducts
                    ?.firstOrNull
                    ?.priceDifference
                    .isNullOrEmpty ??
                true),
      ),

      MenuItem(
        title: "${LocaleKeys.activeLeadsAging.tr()}: ",
        subtitle:
            lead.exchangeProducts?.firstOrNull?.evaluationPendingAging
                        ?.toString()
                        .isNullOrEmpty ??
                    true
                ? ''
                : lead.exchangeProducts?.firstOrNull?.evaluationPendingAging
                    ?.toString(),
        show:
            (user?.isEvaluator ?? false) &&
            !lead.isEC &&
            !(lead.exchangeProducts?.firstOrNull?.evaluationPendingAging
                    ?.toString()
                    .isNullOrEmpty ??
                true),
      ),

      MenuItem(
        title: "Evaluator Name: ",
        subtitle:
            lead.exchangeProducts?.firstOrNull?.evaluatorName.isNullOrEmpty ??
                    true
                ? ''
                : lead.exchangeProducts?.firstOrNull?.evaluatorName,
        show:
            (user?.isEvaluator ?? false) &&
            !(lead.exchangeProducts?.firstOrNull?.evaluatorName.isNullOrEmpty ??
                true),
      ),
      MenuItem(
        title: "${LocaleKeys.lblLostReason.tr()}:",
        subtitle:
            (lead.lostResponse?.isNotEmpty == true)
                ? lead.lostResponse!
                    .map((e) => e.lostReason)
                    .where((e) => e != null && e.isNotEmpty)
                    .join(", ")
                : '',
        show:
            lead.workflow.isLPA ||
            lead.workflow.isLost ||
            lead.workflow.isClosed,
      ),
      MenuItem(
        title: "Lost Vehicle:",
        subtitle:
            lead.workflow?.isCompetitor == true
                ? lead.workflow?.lostToProduct?.carName ?? ""
                : '',
        show:
            (lead.workflow?.isLPA ?? false) || (lead.workflow?.isLost ?? false),
      ),
      MenuItem(
        title: (lead.workflow?.followupType ?? ""),
        subtitle: lead.workflow?.followupDate ?? "",
        show:
            lead.workflow?.followupType != null &&
            lead.workflow?.followupDate != null,
      ),
      MenuItem(
        title:
            (lead.followups?.isNotEmpty == true &&
                    lead.followups!.first.followupType?.toLowerCase() == 'call')
                ? 'Call on'
                : lead.followups?.firstOrNull?.followupType ?? "",
        subtitle:
            lead.followups?.firstOrNull?.followupDueAt?.formatDateTime() ?? "",
        show: lead.isItCCLead,
      ),
      MenuItem(
        title: "",
        subtitle: lead.campaign?.campaignName ?? "",
        show: (lead.campaign?.campaignName ?? "").isNotEmpty,
      ),
      MenuItem(
        title: "${LocaleKeys.lblReferral.tr()} By:",
        subtitle: lead.reference?.fullName ?? "",
        show: (lead.reference?.firstName ?? "").isNotEmpty,
      ),
    ];
  }

  static List<Price> getFinalPrices(
    List<Price> prices,
    Quotation? quotation,
    QuotationConfig? quotationConfig,
    List<Scheme> scheme,
    List<Accessory> accessories,
  ) {
    final configs =
        (quotationConfig?.pricesConfig ?? []) +
        (quotationConfig?.schemeConfig ?? []);
    if (quotation == null) return prices;

    Loggy("").debug(prices, configs);
    final finalPrices = prices.toList();
    finalPrices.removeWhere(
      (price) =>
          (price.priceGroup == 'scheme' || price.priceGroup == 'accessories'),
    );
    final newPrices =
        finalPrices.map((price) {
          final discount =
              price.discount ??
              quotation.quotationFields
                  ?.firstWhereOrNull((field) => field.description == price.name)
                  ?.discount ??
              0;

          final isFree =
              price.free ??
              quotation.quotationFields
                      ?.firstWhereOrNull(
                        (field) => field.description == price.name,
                      )
                      ?.freeFlag ==
                  1;
          Loggy("").debug(quotation.quotationFields);
          return price.copyWith(
            discount: discount == 0 ? null : discount,
            config: configs.firstWhereOrNull(
              (config) => config.key == price.name,
            ),
            free: isFree,
          );
        }).toList();

    for (var scheme in scheme) {
      final schemePrice = Price(
        id: scheme.id,
        name: scheme.schemeName,
        amount: scheme.schemeMrp,
        discount: scheme.schemeMrp,
        priceGroup: 'scheme',
        upfront:
            (quotation.quotationFields
                    ?.firstWhereOrNull(
                      (field) => field.description == scheme.schemeName,
                    )
                    ?.schemeType ??
                0) ==
            1,
        scheme: scheme,
      );
      newPrices.add(schemePrice);
    }

    for (var accessory in accessories) {
      final discount =
          quotation.quotationFields
              ?.firstWhereOrNull((field) => field.description == accessory.name)
              ?.discount;
      final accessoryPrice = Price(
        id: accessory.id,
        name: accessory.name,
        amount: accessory.priceMrp,
        priceGroup: 'accessories',
        discount: discount == 0 ? null : discount,
        accessory: accessory,
      );
      newPrices.add(accessoryPrice);
    }

    return newPrices;
  }

  static List<MenuItem> getExchangeDetailItems({
    Lead? lead,
    ExchangeHouseRequest? exchangeHouse,
  }) {
    final exchangeProduct = lead?.exchangeProducts?.lastOrNull;
    final isInHouseExchange =
        exchangeHouse?.exchangeType == ExchangeType.inHouse.value;
    final isOutHouseExchange =
        exchangeHouse?.exchangeType == ExchangeType.outHouse.value;

    if (lead?.isExchange == 0) {
      return [MenuItem(title: '${LocaleKeys.interestedInExchange.tr()}: ', subtitle: LocaleKeys.lblNo.tr())];
    }
    if (lead?.isExchange == 2) {
      return [MenuItem(title: 'Interested In Exchange: ', subtitle: "")];
    }
    if (exchangeProduct == null) {
      return [MenuItem(title: '${LocaleKeys.interestedInExchange.tr()}: ', subtitle: LocaleKeys.lblYes.tr())];
    }

    return [
      MenuItem(title: '${LocaleKeys.exchangeType.tr()}: ', subtitle: exchangeHouse?.exchangeType),
      MenuItem(
        title: '${LocaleKeys.purchaseValue.tr()}: ',
        subtitle:
            isInHouseExchange
                ? exchangeHouse?.purchasePrice?.formatIndianCommas
                : null,
      ),
      MenuItem(
        title: '${LocaleKeys.adjust.tr()}: ',
        subtitle:
            isInHouseExchange
                ? (exchangeHouse?.adjust ?? false)
                    ? 'Yes'
                    : 'No'
                : null,
      ),
      MenuItem(
        title: 'Out-House Reason: ',
        subtitle: isOutHouseExchange ? exchangeHouse?.reason : null,
      ),
      MenuItem(
        title: '${LocaleKeys.approxValue.tr()}: ',
        subtitle:
            isOutHouseExchange
                ? exchangeHouse?.approxValue?.formatIndianCommas
                : null,
      ),
      MenuItem(
        title: '${LocaleKeys.manufacture.tr()}: ',
        subtitle: exchangeProduct.variant?.product?.brand?.name,
      ),
      MenuItem(
        title: '${LocaleKeys.lblModel.tr()}: ',
        subtitle: exchangeProduct.variant?.product?.name,
      ),
      MenuItem(title: '${LocaleKeys.lblColor.tr()}: ', subtitle: exchangeProduct.color),
      MenuItem(
        title: '${LocaleKeys.lblModelYear.tr()}: ',
        subtitle:
            exchangeProduct.modelYear != 0
                ? exchangeProduct.modelYear?.toString()
                : null,
      ),
      MenuItem(title: '${LocaleKeys.ownership.tr()}: ', subtitle: exchangeProduct.ownership),
      MenuItem(
        title: '${LocaleKeys.lblInsuranceValidity.tr()}: ',
        subtitle: exchangeProduct.insuranceValidity?.formatDateTime(),
      ),
      MenuItem(
        title: '${LocaleKeys.lblRegistrationNo.tr()}: ',
        subtitle: exchangeProduct.registrationNumber,
      ),
      MenuItem(
        title: '${LocaleKeys.expectedPrice.tr()}: ',
        subtitle:
            exchangeProduct.expectedPrice != 0
                ? exchangeProduct.expectedPrice?.toString()
                : null,
      ),
      MenuItem(
        title: '${LocaleKeys.quotedPrice.tr()}: ',
        subtitle:
            exchangeProduct.quotedPrice != 0
                ? exchangeProduct.quotedPrice?.toString()
                : null,
      ),
      MenuItem(
        title: '${LocaleKeys.mileageKm.tr()}: ',
        subtitle:
            exchangeProduct.millage != 0
                ? exchangeProduct.millage?.toString()
                : null,
      ),
      MenuItem(
        title: '${LocaleKeys.lblTyreReplacement.tr()}: ',
        subtitle: exchangeProduct.tyreReplacement
            ?.split(",")
            .map((value) => value.formatTyreText)
            .join(", "),
      ),
    ].filteredNonEmptyItems;
  }

  static ({FirstTimeBuyer? exchangeCar, bool usedFallback}) resolveExchangeCar({
    required Lead? lead,
    required FirstTimeBuyer? firstTimeBuyer,
  }) {
    final exchangeCarFromLead = lead?.exchangeCarDetails;
    final usedFallback =
        exchangeCarFromLead?.oldVehicleId == null &&
        exchangeCarFromLead?.oldVehicleVariantId == null &&
        firstTimeBuyer?.isExistingVehicle == 1 &&
        firstTimeBuyer?.oldVehicleId != null;
    final exchangeCar = usedFallback
        ? FirstTimeBuyer(
            isExistingVehicle: firstTimeBuyer?.isExistingVehicle,
            oldVehicleId: firstTimeBuyer?.oldVehicleId,
            oldVehicleName: firstTimeBuyer?.oldVehicleName,
            oldVehicleVariantId: firstTimeBuyer?.oldVehicleVariantId,
            oldVehicleVariantName: firstTimeBuyer?.oldVehicleVariantName,
          )
        : exchangeCarFromLead;
    return (exchangeCar: exchangeCar, usedFallback: usedFallback);
  }

  static bool canBookFrom(Lead? lead, DiscountApproval? approval) {
    final approvalStatus = approval?.approvalStatus;
    final profile = CacheManager.getModel(
      keyProfile,
      (json) => User.fromJson(json),
    );

    if (approvalStatus == null) return true;

    if (approvalStatus > 1) {
      return true;
    } else {
      if (approvalStatus == 0) {
        if (lead?.workflow?.isBPR ?? false) {
          return false;
        } else {
          if (profile?.isOwner == 1) {
            return false;
          } else {
            return true;
          }
        }
      } else if (approvalStatus == 2) {
        if (profile?.isOwner == 1) {
          return false;
        } else {
          return true;
        }
      }
    }

    return false;
  }

  static bool canEditBooking(Lead? lead) {
    final workflow = lead?.workflow;
    if (workflow == null) return false;

    // Allow editing BPR leads only if SM has rejected them
    if (workflow.isBPR) {
      // If cancellationReason exists, SM has rejected - allow editing
      return !(lead?.cancellationReason?.isEmpty ?? true);
    }

    if (workflow.isCPA ||
        workflow.isBooked ||
        workflow.isCancelled) {
      return false;
    }

    return true;
  }

  static bool canEditDelivery(Lead? lead) {
    final workflow = lead?.workflow;
    Loggy("canEditDelivery").debug(workflow);
    if (workflow == null) return false;

    // Allow editing DPR leads only if SM has rejected them
    if (workflow.isDPR) {
      // If cancellationReason exists, SM has rejected - allow editing
      return !(lead?.cancellationReason?.isEmpty ?? true);
    }

    if (workflow.isDelivered || workflow.isCancelled) {
      return false;
    }

    return true;
  }

  static bool canEditProspectSheet(Lead? lead) {
    if (lead?.workflow.isClosed == true || lead?.workflow.isLost == true) {
      return false;
    }
    return true;
  }

  static String bookingTitle(Lead lead) {
    final workflow = lead.workflow;
    if (workflow != null && (workflow.isBooked)) {
      return "Booking Detail";
    }

    return LocaleKeys.booking.tr();
  }

  static String deliveryTitle(Lead lead) {
    final workflow = lead.workflow;
    if (workflow != null && (workflow.isDelivered)) {
      return "Delivery Detail";
    }

    return LocaleKeys.lblDelivery.tr();
  }

  static CreateLeadRequest get defaultCreateLeadRequest {
    return CreateLeadRequest(
      salutation: CommonString.salutations.first,
      contactDetails: [ContactDetails(type: ContactType.mobile.value)],
      isExchange: 0,
      purchaseMode: PurchaseMode.cash.value,
      followUpPlan: FollowUpPlanType.call.value,
      dateOfEnquiry: DateTime.now().formatDateTime(),
    );
  }
}
