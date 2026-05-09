import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_core/salesdocket_core.dart';

import 'package:salesdocket_mobile/common/constants/cancel_booking_reasons.dart';
import 'package:salesdocket_mobile/common/constants/contact_type.dart';
import 'package:salesdocket_mobile/common/constants/customer_type.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/inactive_booking_reasons.dart';

import 'package:salesdocket_mobile/common/constants/interested_in_comp_state.dart';
import 'package:salesdocket_mobile/common/constants/interested_in_exchange_state.dart';
import 'package:salesdocket_mobile/common/constants/lead_source_type.dart';
import 'package:salesdocket_mobile/common/constants/profession.dart';
import 'package:salesdocket_mobile/features/followup/presentation/components/call_status_mode.dart';
import 'package:salesdocket_mobile/common/constants/more_discount_reasons.dart';
import 'package:salesdocket_mobile/common/constants/purchase_mode.dart';
import 'package:salesdocket_mobile/common/constants/receipt.dart';

import 'package:salesdocket_mobile/common/constants/select_brand_reason.dart';
import 'package:salesdocket_mobile/common/constants/test_drive_given_constants.dart';
import 'package:salesdocket_mobile/common/constants/customer_quote_state.dart';
import 'package:salesdocket_mobile/common/entity/credit_given.dart';
import 'package:salesdocket_mobile/common/entity/customer_quote.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/entity/followup_data_given.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/interested_in_comp.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/common/extensions/auth_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/discount_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/lead_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_mobile/utility/validation_utils.dart';

import '../constants/lead_state.dart';
import '../entity/old_car_payment.dart';

extension CreateLeadValidationExtension on CreateLeadRequest {
  List<FormFieldError> validationErrors({bool isAddedFullAddress = false}) {
    final errors = <FormFieldError>[];
    final primaryVehicle = variants?.firstOrNull;

    if (primaryVehicle?.product?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectModel,
          message: LocaleKeys.errSelectModel.tr(),
        ),
      );
    }
    if (primaryVehicle?.engineType == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectEngineType,
          message: LocaleKeys.errSelectEngineType.tr(),
        ),
      );
    }
    if (primaryVehicle?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectVariant,
          message: LocaleKeys.errSelectVariant.tr(),
        ),
      );
    }

    if (leadSource == null || leadSource!.isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.leadSource,
          message: LocaleKeys.errLeadSource.tr(),
        ),
      );
    } else {
      if (sourceOfInformation == null || sourceOfInformation!.isEmpty) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.sourceOfLead,
            message: LocaleKeys.errSourceOfLead.tr(),
          ),
        );
      } else if (sourceOfInformation == SourceOfInformationReasons.othersValue &&
          (otherSourceOfInformation ?? "").trim().isEmpty) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.othersReason,
            message: LocaleKeys.errEnterReason.tr(),
          ),
        );
      }
    }

    final nameValue = firstName ?? "";
    String? nameErrorMsg;
    if (nameValue.isEmpty) {
      nameErrorMsg = LocaleKeys.errEnterFullName.tr();
    } else if (nameValue.length < 2) {
      nameErrorMsg = LocaleKeys.errMinTwoCharacters.tr();
    } else if (nameValue.length > 50) {
      nameErrorMsg = LocaleKeys.errMaxFiftyCharacters.tr();
    }
    // Additional validations you could add:
    else if (nameValue.trim().isEmpty) {
      nameErrorMsg = LocaleKeys.errEnterFullName.tr();
    } else if (RegExp(r'^\s+$').hasMatch(nameValue)) {
      nameErrorMsg = "Name cannot contain only spaces";
    } else if (RegExp(r'^[0-9\s]+$').hasMatch(nameValue)) {
      nameErrorMsg = "Name cannot contain only numbers";
    } else if (RegExp(r'[0-9]').hasMatch(nameValue)) {
      nameErrorMsg = "Name should not contain numbers";
    } else if (RegExp(
      r'[!@#$%^&*()_+={}\[\]:;"<>,?/\\|~`]',
    ).hasMatch(nameValue)) {
      nameErrorMsg = "Name should not contain special characters";
    }

    if (nameErrorMsg != null) {
      errors.add(
        FormFieldError(field: LeadFormFields.fullName, message: nameErrorMsg),
      );
    }

    if (contactDetails == null || contactDetails!.isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.contactDetails,
          message: LocaleKeys.errMobileNoMandatory.tr(),
        ),
      );
    } else {
      for (var index = 0; index < contactDetails!.length; index++) {
        final contact = contactDetails![index];
        if (contact.type == ContactType.email.value &&
            validateEmail(contact.value) != null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.contactDetails,
              message: LocaleKeys.errInvalidEmail.tr(),
              index: index,
            ),
          );
        } else if (contact.type != ContactType.email.value && validateMobile(contact.value) != null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.contactDetails,
              message:
                  "${LocaleKeys.invalid.tr()} ${contact.type ?? LocaleKeys.lblMobile.tr()}!",
              index: index,
            ),
          );
        }
      }
    }

    if (cityId == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.district,
          message: LocaleKeys.errEnterValidDistrict.tr(),
        ),
      );
    }

    if (localityId == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.location,
          message: LocaleKeys.errSelectLocation.tr(),
        ),
      );
    }

    if (followUpPlan == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.planFollowUp,
          message: LocaleKeys.errMsgFollowupPlan.tr(),
        ),
      );
    }

    if (followUpDateTime == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.followUpDateTime,
          message: LocaleKeys.errFollowUpDateTime.tr(),
        ),
      );
    }

    if (dateOfEnquiry == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.dateOfEnquiry,
          message: LocaleKeys.errDateOfEnquiry.tr(),
        ),
      );
    }

    return errors;
  }
}

extension FollowupValidationExtension on FollowupDataGiven {
  List<FormFieldError> followupNewLeadStatusValidationErrors() {
    final errors = <FormFieldError>[];

    if (remarks == null || remarks!.trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.remarks,
          message: "Enter Remarks!",
        ),
      );
    }
    if (expectedMonthOfConversion == null ||
        expectedMonthOfConversion!.isEmpty) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.expectedMonthOfConversion,
          message: "Enter Expected Month of Conversion!",
        ),
      );
    } else {
      // Check if selected month is in the past
      try {
        final selectedDate = DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).parse(expectedMonthOfConversion!);
        final now = DateTime.now();
        final currentMonthStart = DateTime(now.year, now.month, 1);
        final selectedMonthStart = DateTime(
          selectedDate.year,
          selectedDate.month,
          1,
        );

        if (selectedMonthStart.isBefore(currentMonthStart)) {
          errors.add(
            FormFieldError(
              field: CreateFollowUpFormFields.expectedMonthOfConversion,
              message:
                  "Cannot select a previous month for Expected Month of Conversion!",
            ),
          );
        }
      } catch (e) {
        // If parsing fails, the date format might be invalid
        // Skip validation in this case as it will be caught by other validations
      }
    }
    if (leadCategory == null) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.leadCategory,
          message: "Select Lead Status!",
        ),
      );
    }
    if (nextFollowup == null) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.nextFollowup,
          message: "Select Next Follow-up!",
        ),
      );
    }
    if (when == null) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.when,
          message: "Select Follow-up Date & Time!",
        ),
      );
    }

    return errors;
  }

  List<FormFieldError> followupClosedValidationErrors() {
    final errors = <FormFieldError>[];

    if (closedReason == null || closedReason!.isEmpty) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.closedReason,
          message: "Please Select a Reason!",
        ),
      );
    } else if (closedReason == FollowupReasonState.other.value) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.otherClosedReason,
          message: LocaleKeys.errEnterOtherReason.tr(),
        ),
      );
    }

    return errors;
  }

  List<FormFieldError> followupLostCompetitorValidationErrors() {
    final errors = <FormFieldError>[];

    if (lostToCompetitionReason == null) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.lostToCompetitionReason,
          message: "Please Select a Reason!",
        ),
      );
    } else if ((lostToCompetitionReason ?? []).any((r) => r == RejectReasonType.other.value)) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.otherCompetitionReason,
          message: LocaleKeys.errEnterOtherReason.tr(),
        ),
      );
    }
    if (productId == null) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.selectBrand,
          message: "Please Select a Brand!",
        ),
      );
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.selectModel,
          message: "Please Select a Model!",
        ),
      );
    }

    return errors;
  }

  List<FormFieldError> followupLostCoDealerValidationErrors() {
    final errors = <FormFieldError>[];

    if (lostToCompetitionReason == null) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.lostToCompetitionReason,
          message: "Please Select a Reason!",
        ),
      );
    } else if ((lostToCompetitionReason ?? []).any((r) => r == RejectReasonType.other.value)) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.otherCompetitionReason,
          message: LocaleKeys.errEnterOtherReason.tr(),
        ),
      );
    }
    if (lostToCoDealerName == null || lostToCoDealerName!.isEmpty) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.coDealerName,
          message: "Please Provide Co-Dealer name!",
        ),
      );
    }

    return errors;
  }

  List<FormFieldError> followupDetailsValidationErrors({
    TestDriveGiven? newTestDrive,
    FollowupDataGiven? followupData,
  }) {
    final errors = <FormFieldError>[];

    if (newTestDrive == null || newTestDrive.given == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.testDriveGiven,
          message: "Invalid Test Drive Given!",
        ),
      );
      return errors; // Return early to avoid further checks on null values
    }

    if (newTestDrive.given == 1) {
      if (newTestDrive.when.isNullOrEmpty) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.testDriveGivenWhen,
            message: "Select When Date!",
          ),
        );
      }
      if (newTestDrive.vehicleUsed == null) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.testDriveGivenVehicle,
            message: "Select Vehicle Used!",
          ),
        );
      }
      if (newTestDrive.toWhom.isNullOrEmpty) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.testDriveGivenToWhom,
            message: "To whom should be filled!",
          ),
        );
      }
    } else {
      if (newTestDrive.whyNotGiven == null) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.notGivenReason,
            message: "Select why not given!",
          ),
        );
      }
      if (newTestDrive.whyNotGiven == TestDriveWhyNotGivenState.others.value &&
          newTestDrive.whyNotGivenReason.isNullOrEmpty) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.notGivenOtherReason,
            message: "Enter other reason!",
          ),
        );
      }
    }
    if (followupData!.when == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.testDriveGiven,
          message: "Invalid Test Drive Given!",
        ),
      );
    }
    if (followupData.remarks == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.testDriveGiven,
          message: "Invalid Test Drive Given!",
        ),
      );
    }
    if (followupData.expectedMonthOfConversion == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.testDriveGiven,
          message: "Invalid Test Drive Given!",
        ),
      );
    }

    return errors;
  }

  List<FormFieldError> followupCallLetterValidationErrors() {
    final errors = <FormFieldError>[];

    if (when == null) {
      errors.add(
        FormFieldError(
          field: CreateFollowUpFormFields.when,
          message: "Select Follow-up Date & Time!",
        ),
      );
    }

    return errors;
  }
}

extension ProspectValidationExtension on Lead {
  List<FormFieldError> prospectPersonalDetailsValidationErrors({
    List<ContactDetails> newContactDetails = const [],
    LeadLocality? newLocality,
    LeadAddress? newAddress,
  }) {
    final errors = <FormFieldError>[];

    if (newContactDetails.isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.contactDetails,
          message: LocaleKeys.errMobileNoMandatory.tr(),
        ),
      );
    } else {
      for (var index = 0; index < newContactDetails.length; index++) {
        final contact = newContactDetails[index];
        if (contact.type == ContactType.email.value &&
            validateEmail(contact.value) != null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.contactDetails,
              message: LocaleKeys.errInvalidEmail.tr(),
              index: index,
            ),
          );
        } else if (contact.type != ContactType.email.value && validateMobile(contact.value) != null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.contactDetails,
              message:
                  "${LocaleKeys.invalid.tr()} ${contact.type ?? LocaleKeys.lblMobile.tr()}!",
              index: index,
            ),
          );
        }
      }
    }

    if (newLocality?.city?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.district,
          message: LocaleKeys.errEnterValidDistrict.tr(),
        ),
      );
    }

    if (newLocality?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.location,
          message: LocaleKeys.errSelectLocation.tr(),
        ),
      );
    }

    if (customerType == null || customerType!.trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.typeOfCustomer,
          message: LocaleKeys.errSelectTypeOfCustomer.tr(),
        ),
      );
    }

    if (customerType == CustomerType.corporate.value &&
        (corporateName == null || corporateName!.trim().isEmpty)) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.corporateName,
          message: LocaleKeys.errCorporateName.tr(),
        ),
      );
    }

    if (profession == null || profession!.trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.profession,
          message: LocaleKeys.errSelectProfession.tr(),
        ),
      );
    } else if (profession == Profession.other.value &&
        (otherProfession ?? "").trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.profession,
          message: LocaleKeys.errEnterProfession.tr(),
        ),
      );
    }

    final addressLine1 = (newAddress?.line1 ?? "").trim();
    if (addressLine1.isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.addressLineOne,
          message: "Enter Address Line 1!",
        ),
      );
    } else if (addressLine1.length < 5) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.addressLineOne,
          message: "Address Line 1 should be at least 5 characters!",
        ),
      );
    }

    return errors;
  }

  List<FormFieldError> prospectBuyingDetailsValidationErrors({
    List<InterestedVariant> newCarDetails = const [],
    InterestedColor? newCarColor,
    TestDriveGiven? newTestDrive,
    FirstTimeBuyer? newFirstTimeBuyer,
    InterestedInComp? newInterestedInComp,
    CustomerQuote? newCustomerQuote,
  }) {
    final errors = <FormFieldError>[];

    if (newCarDetails.firstOrNull?.product?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectModel,
          message: LocaleKeys.errSelectModel.tr(),
        ),
      );
    }

    if (newCarDetails.firstOrNull?.engineType == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectEngineType,
          message: LocaleKeys.errSelectEngineType.tr(),
        ),
      );
    }

    if (newCarDetails.firstOrNull?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectVariant,
          message: LocaleKeys.errSelectVariant.tr(),
        ),
      );
    }

    if (newCarColor?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectCarColor,
          message: LocaleKeys.errSelectColor.tr(),
        ),
      );
    }

    if (newTestDrive?.given == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.testDriveGiven,
          message: LocaleKeys.errInvalidTestDriveGiven.tr(),
        ),
      );
    } else {
      if (newTestDrive?.given == 1) {
        if ((newTestDrive?.when ?? "").isNullOrEmpty) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.testDriveGivenWhen,
              message: LocaleKeys.errSelectWhenDate.tr(),
            ),
          );
        }
        if (newTestDrive?.vehicleUsed == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.testDriveGivenVehicle,
              message: LocaleKeys.errSelectVehicleUsed.tr(),
            ),
          );
        }
        if ((newTestDrive?.toWhom ?? "").isNullOrEmpty) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.testDriveGivenToWhom,
              message: LocaleKeys.errToWhomShouldBeFilled.tr(),
            ),
          );
        }
      } else {
        if (newTestDrive?.whyNotGiven == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.notGivenReason,
              message: LocaleKeys.errSelectWhyNotGiven.tr(),
            ),
          );
        }
        if (newTestDrive?.whyNotGiven ==
                TestDriveWhyNotGivenState.others.value &&
            (newTestDrive?.whyNotGivenReason ?? "").isNullOrEmpty) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.notGivenOtherReason,
              message: LocaleKeys.errEnterOtherReason.tr(),
            ),
          );
        }
      }
    }

    if (purchaseMode == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.modeOfPurchase,
          message: "Mode of Purchase can't be empty!",
        ),
      );
    }

    if (newInterestedInComp?.status == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.interestedInComp,
          message: LocaleKeys.errInvalidInterestedInComp.tr(),
        ),
      );
    } else {
      if (newInterestedInComp?.status == InterestedInCompState.yes.value) {
        if (newInterestedInComp?.brand == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.compBrand,
              message: LocaleKeys.errSelectBrand.tr(),
            ),
          );
        }
        if (newInterestedInComp?.model == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.compModel,
              message: LocaleKeys.errSelectModel.tr(),
            ),
          );
        }
      }
    }

    if (newFirstTimeBuyer?.isExistingVehicle == 2) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.firstTimeBuyerStatus,
          message: LocaleKeys.errInvalidFirstTimeBuyer.tr(),
        ),
      );
    }

    if (newCustomerQuote?.tookQuote == CustomerQuoteState.yes.value &&
        (newCustomerQuote?.quoteDate ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.quoteDate,
          message: LocaleKeys.errSelectQuoteDate.tr(),
        ),
      );
    }

    return errors;
  }

  List<FormFieldError> prospectExchangeDetailsValidationErrors({
    FirstTimeBuyer? newFirstTimeBuyer,
    ExchangeProduct? newExchangeProduct,
    User? user,
  }) {
    final errors = <FormFieldError>[];
    if (isExchange == null || isExchange == InterestedInExchangeState.none.value) {
      return [
        FormFieldError(
          field: LeadFormFields.exchange,
          message: LocaleKeys.errSelectInterestedInExchange.tr(),
        ),
      ];
    }

    if (isExchange == InterestedInExchangeState.no.value) {
      return errors;
    }

    if (newFirstTimeBuyer?.oldVehicleId == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectBrand,
          message: LocaleKeys.errSelectManufacture.tr(),
        ),
      );
    }

    if (newFirstTimeBuyer?.oldVehicleVariantId == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectBrandModel,
          message: LocaleKeys.errSelectBrandModel.tr(),
        ),
      );
    }

    if ((newExchangeProduct?.color ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectCarColor,
          message: LocaleKeys.errEnterColor.tr(),
        ),
      );
    }

    if (("${newExchangeProduct?.millage ?? ""}").isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.mileage,
          message: LocaleKeys.errEnterMileage.tr(),
        ),
      );
    }

    if (newExchangeProduct?.registrationNumber == null ||
        newExchangeProduct!.registrationNumber!.trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.registrationNumber,
          message: LocaleKeys.errEnterRegistrationNumber.tr(),
        ),
      );
    }

    // Evaluator-specific validations (for EPE leads being evaluated, or EC leads maintaining data integrity)
    if (user?.isEvaluator == true) {
      if (newExchangeProduct?.dateOfEvaluation == null ||
          newExchangeProduct!.dateOfEvaluation!.isEmpty ||
          newExchangeProduct.dateOfEvaluation == "0000-00-00 00:00:00") {
        errors.add(
          FormFieldError(
            field: LeadFormFields.dateOfEvaluation,
            message: LocaleKeys.errDateOfEvaluation.tr(),
          ),
        );
      }

      if (newExchangeProduct?.expectedPrice == null ||
          newExchangeProduct?.expectedPrice == 0) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.expectedPrice,
            message: LocaleKeys.errEnterExpectedPrice.tr(),
          ),
        );
      }

      if (newExchangeProduct?.quotedPrice == null ||
          newExchangeProduct?.quotedPrice == 0) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.quotedPrice,
            message: LocaleKeys.errEnterQuotedPrice.tr(),
          ),
        );
      }
    }
    return errors;
  }

  List<FormFieldError> prospectPlanFollowupValidationErrors({
    CreateLeadHistoryRequest? followupPlanRequest,
    bool isReschedulingFollowup = false,
    LeadFollowupRequest? reschedulingFollowup,
  }) {
    final errors = <FormFieldError>[];

    final validLeadStates = [
      LeadState.hot.value.toUpperCase(),
      LeadState.warm.value.toUpperCase(),
      LeadState.cold.value.toUpperCase(),
    ];

    final currentLeadState = leadState?.trim().toUpperCase();

    if (currentLeadState == null ||
        currentLeadState.isEmpty ||
        !validLeadStates.contains(currentLeadState)) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.leadStatus,
          message: LocaleKeys.errLeadCategory.tr(),
        ),
      );
    }

    if (isReschedulingFollowup && reschedulingFollowup?.followUpPlan == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.planFollowUp,
          message: LocaleKeys.errMsgFollowupPlan.tr(),
        ),
      );
    }

    if (isReschedulingFollowup &&
        (reschedulingFollowup?.editReason ?? "").trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.rescheduleReason,
          message: LocaleKeys.errEnterReason.tr(),
        ),
      );
    }

    if (followupPlanRequest?.remarks == null ||
        followupPlanRequest!.remarks!.isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.remarks,
          message: LocaleKeys.errEnterCustomerRemarks.tr(),
        ),
      );
    }

    return errors;
  }
}

extension BookingValidationExtension on Lead {
  List<FormFieldError> bookingPersonalDetailsValidationErrors({
    List<ContactDetails> newContactDetails = const [],
    LeadLocality? newLocality,
    Booking? selectedBooking,
    LeadAddress? newAddress,
  }) {
    final errors = <FormFieldError>[];

    if ((selectedBooking?.firstName ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.contactDetails,
          message: LocaleKeys.errNameCannotBeEmpty.tr(),
        ),
      );
    }

    if (newContactDetails.isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.contactDetails,
          message: LocaleKeys.errMobileNoMandatory.tr(),
        ),
      );
    } else {
      for (var index = 0; index < newContactDetails.length; index++) {
        final contact = newContactDetails[index];
        if (contact.type == ContactType.email.value &&
            validateEmail(contact.value) != null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.contactDetails,
              message: LocaleKeys.errInvalidEmail.tr(),
              index: index,
            ),
          );
        } else if (contact.type != ContactType.email.value && validateMobile(contact.value) != null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.contactDetails,
              message:
                  "${LocaleKeys.invalid.tr()} ${contact.type ?? LocaleKeys.lblMobile.tr()}!",
              index: index,
            ),
          );
        }
      }
    }

    if (newLocality?.city?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.district,
          message: LocaleKeys.errEnterValidDistrict.tr(),
        ),
      );
    }

    if (newLocality?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.location,
          message: LocaleKeys.errSelectLocation.tr(),
        ),
      );
    }

    if (customerType == null || customerType!.trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.typeOfCustomer,
          message: LocaleKeys.errSelectTypeOfCustomer.tr(),
        ),
      );
    }

    if (customerType == CustomerType.corporate.value &&
        (corporateName == null || corporateName!.trim().isEmpty)) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.corporateName,
          message: LocaleKeys.errEnterCorporateName.tr(),
        ),
      );
    }

    if (selectedBooking?.profession == null ||
        (selectedBooking?.profession ?? "").trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.profession,
          message: LocaleKeys.errSelectProfession.tr(),
        ),
      );
    } else if (selectedBooking?.profession == Profession.other.value &&
        (selectedBooking?.otherProfession ?? "").trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.profession,
          message: LocaleKeys.errEnterProfession.tr(),
        ),
      );
    }

    final addressLine1 = (newAddress?.line1 ?? "").trim();
    if (addressLine1.isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.addressLineOne,
          message: "Enter Address Line 1!",
        ),
      );
    } else if (addressLine1.length < 5) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.addressLineOne,
          message: "Address Line 1 should be at least 5 characters!",
        ),
      );
    }

    return errors;
  }

  List<FormFieldError> bookingBuyingDetailsValidationErrors({
    List<InterestedVariant> newCarDetails = const [],
    InterestedColor? newCarColor,
    TestDriveGiven? newTestDrive,
    FirstTimeBuyer? newFirstTimeBuyer,
    InterestedInComp? newInterestedInComp,
    Booking? newBookingDetails,
    CustomerQuote? newCustomerQuote,
  }) {
    final errors = <FormFieldError>[];

    if (newCarDetails.firstOrNull?.product?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectModel,
          message: LocaleKeys.errSelectBrandModel.tr(),
        ),
      );
    }

    if (newCarDetails.firstOrNull?.engineType == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectEngineType,
          message: LocaleKeys.errSelectEngineType.tr(),
        ),
      );
    }

    if (newCarDetails.firstOrNull?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectVariant,
          message: LocaleKeys.errSelectVariant.tr(),
        ),
      );
    }

    if (newCarColor?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectCarColor,
          message: LocaleKeys.errSelectCarColor.tr(),
        ),
      );
    }

    if (newTestDrive?.given == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.testDriveGiven,
          message: LocaleKeys.errInvalidTestDriveGiven.tr(),
        ),
      );
    } else {
      if (newTestDrive?.given == 1) {
        if ((newTestDrive?.when ?? "").isNullOrEmpty) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.testDriveGivenWhen,
              message: LocaleKeys.errSelectWhenDate.tr(),
            ),
          );
        }
        if (newTestDrive?.vehicleUsed == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.testDriveGivenVehicle,
              message: LocaleKeys.errSelectVehicleUsed.tr(),
            ),
          );
        }
        if ((newTestDrive?.toWhom ?? "").isNullOrEmpty) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.testDriveGivenToWhom,
              message: LocaleKeys.errToWhomShouldBeFilled.tr(),
            ),
          );
        }
      } else {
        if (newTestDrive?.whyNotGiven == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.notGivenReason,
              message: LocaleKeys.errSelectWhyNotGiven.tr(),
            ),
          );
        }
        if (newTestDrive?.whyNotGiven ==
                TestDriveWhyNotGivenState.others.value &&
            (newTestDrive?.whyNotGivenReason ?? "").isNullOrEmpty) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.notGivenOtherReason,
              message: LocaleKeys.errEnterOtherReason.tr(),
            ),
          );
        }
      }
    }

    if (purchaseMode == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.modeOfPurchase,
          message: "Mode of Purchase can't be empty!",
        ),
      );
    }

    if (newInterestedInComp?.status == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.interestedInComp,
          message: LocaleKeys.errInvalidInterestedInComp.tr(),
        ),
      );
    } else {
      if (newInterestedInComp?.status == InterestedInCompState.yes.value) {
        if (newInterestedInComp?.brand == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.compBrand,
              message: LocaleKeys.errSelectBrand.tr(),
            ),
          );
        }
        if (newInterestedInComp?.model == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.compModel,
              message: LocaleKeys.errSelectBrandModel.tr(),
            ),
          );
        }
      }
    }

    if (newFirstTimeBuyer?.isExistingVehicle == 2) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.firstTimeBuyerStatus,
          message: LocaleKeys.errInvalidFirstTimeBuyer.tr(),
        ),
      );
    }

    if (purchaseMode == PurchaseMode.finance.value) {
      if (newBookingDetails?.financeType == null) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.financeType,
            message: LocaleKeys.errSelectFinanceForm.tr(),
          ),
        );
      }
    }

    if (newCustomerQuote?.tookQuote == CustomerQuoteState.yes.value &&
        (newCustomerQuote?.quoteDate ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.quoteDate,
          message: LocaleKeys.errSelectQuoteDate.tr(),
        ),
      );
    }

    return errors;
  }

  List<FormFieldError> bookingExchangeDetailsValidationErrors({
    FirstTimeBuyer? newFirstTimeBuyer,
    ExchangeProduct? newExchangeProduct,
    ExchangeHouseRequest? newExchangeHouseDetails,
    User? user,
  }) {
    final errors = <FormFieldError>[];
    if (isExchange == null || isExchange == InterestedInExchangeState.none.value) {
      return [
        FormFieldError(
          field: LeadFormFields.exchange,
          message: LocaleKeys.errSelectInterestedInExchange.tr(),
        ),
      ];
    }

    if (isExchange == InterestedInExchangeState.no.value) {
      return errors;
    }

    if (newExchangeHouseDetails?.exchangeType == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.exchangeType,
          message: LocaleKeys.errSelectExchangeType.tr(),
        ),
      );
    } else {
      if (newExchangeHouseDetails?.exchangeType == ExchangeType.inHouse.value) {
        if (newExchangeHouseDetails?.purchasePrice == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.exchangePurchasePrice,
              message: LocaleKeys.errEnterPurchaseValue.tr(),
            ),
          );
        }
      }
    }

    if (newFirstTimeBuyer?.oldVehicleId == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectBrand,
          message: LocaleKeys.errSelectManufacture.tr(),
        ),
      );
    }

    if (newFirstTimeBuyer?.oldVehicleVariantId == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectBrandModel,
          message: LocaleKeys.errSelectBrandModel.tr(),
        ),
      );
    }

    if ((newExchangeProduct?.color ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectCarColor,
          message: LocaleKeys.errEnterColor.tr(),
        ),
      );
    }

    if (("${newExchangeProduct?.millage ?? ""}").isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.mileage,
          message: LocaleKeys.errEnterMileage.tr(),
        ),
      );
    }

    if (newExchangeProduct?.registrationNumber == null ||
        newExchangeProduct!.registrationNumber!.trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.registrationNumber,
          message: LocaleKeys.errEnterRegistrationNumber.tr(),
        ),
      );
    }

    if (user?.isEvaluator == true) {
      if (newExchangeProduct?.dateOfEvaluation == null ||
          newExchangeProduct!.dateOfEvaluation!.isEmpty ||
          newExchangeProduct.dateOfEvaluation == "0000-00-00 00:00:00") {
        errors.add(
          FormFieldError(
            field: LeadFormFields.dateOfEvaluation,
            message: LocaleKeys.errDateOfEvaluation.tr(),
          ),
        );
      }

      if (newExchangeProduct?.expectedPrice == null ||
          newExchangeProduct?.expectedPrice == 0) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.expectedPrice,
            message: LocaleKeys.errEnterExpectedPrice.tr(),
          ),
        );
      }

      if (newExchangeProduct?.quotedPrice == null ||
          newExchangeProduct?.quotedPrice == 0) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.quotedPrice,
            message: LocaleKeys.errEnterQuotedPrice.tr(),
          ),
        );
      }

      if (newExchangeProduct?.registrationNumber == null ||
          newExchangeProduct!.registrationNumber!.trim().isEmpty) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.registrationNumber,
            message: LocaleKeys.errEnterRegistrationNumber.tr(),
          ),
        );
      }
    }

    return errors;
  }

  List<FormFieldError> bookingFormValidationErrors({
    Booking? newBookingDetails,
  }) {
    final errors = <FormFieldError>[];
    if (newBookingDetails?.expectedDelivery == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.expectedDeliveryDate,
          message: LocaleKeys.errExpectedDeliveryDate.tr(),
        ),
      );
    }
    if ((newBookingDetails?.amountCollected ?? 0) == 0) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.amountCollected,
          message: LocaleKeys.errAmountCollected.tr(),
        ),
      );
    }
    if (newBookingDetails?.bookingDate == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.dateOfBooking,
          message: LocaleKeys.errDateOfBooking.tr(),
        ),
      );
    }

    return errors;
  }
}

extension DeliveryValidationExtension on Lead {
  List<FormFieldError> deliveryPersonalDetailsValidationErrors({
    List<ContactDetails> newContactDetails = const [],
    LeadLocality? newLocality,
    LeadAddress? newAddress,
    Delivery? selectedDelivery,
  }) {
    final errors = <FormFieldError>[];
    if ((selectedDelivery?.firstName ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.contactDetails,
          message: LocaleKeys.errNameCannotBeEmpty.tr(),
        ),
      );
    }

    if (newContactDetails.isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.contactDetails,
          message: LocaleKeys.errMobileNoMandatory.tr(),
        ),
      );
    } else {
      // Check if email exists in contact details
      final hasEmail = newContactDetails.any(
        (contact) =>
            contact.type == ContactType.email.value &&
            (contact.value?.trim().isNotEmpty ?? false),
      );

      if (!hasEmail) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.contactDetails,
            message: LocaleKeys.errEmailRequired.tr(),
          ),
        );
      }

      // Validate each contact detail
      for (var index = 0; index < newContactDetails.length; index++) {
        final contact = newContactDetails[index];
        if (contact.type == ContactType.email.value &&
            validateEmail(contact.value) != null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.contactDetails,
              message: LocaleKeys.errInvalidEmail.tr(),
              index: index,
            ),
          );
        } else if (contact.type != ContactType.email.value && validateMobile(contact.value) != null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.contactDetails,
              message:
                  "${LocaleKeys.invalid.tr()} ${contact.type ?? LocaleKeys.lblMobile.tr()}!",
              index: index,
            ),
          );
        }
      }
    }

    if (newLocality?.city?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.district,
          message: LocaleKeys.errEnterValidDistrict.tr(),
        ),
      );
    }

    if (newLocality?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.location,
          message: LocaleKeys.errSelectLocation.tr(),
        ),
      );
    }

    if (customerType == null || customerType!.trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.typeOfCustomer,
          message: LocaleKeys.errSelectTypeOfCustomer.tr(),
        ),
      );
    }

    if (customerType == CustomerType.corporate.value &&
        (corporateName == null || corporateName!.trim().isEmpty)) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.corporateName,
          message: LocaleKeys.errEnterCorporateName.tr(),
        ),
      );
    }

    if (selectedDelivery?.profession == null ||
        (selectedDelivery?.profession ?? "").trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.profession,
          message: LocaleKeys.errSelectProfession.tr(),
        ),
      );
    } else if (selectedDelivery?.profession == Profession.other.value &&
        (selectedDelivery?.otherProfession ?? "").trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.profession,
          message: LocaleKeys.errEnterProfession.tr(),
        ),
      );
    }

    final addressLine1 = (newAddress?.line1 ?? "").trim();
    if (addressLine1.isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.addressLineOne,
          message: "Enter Address Line 1!",
        ),
      );
    } else if (addressLine1.length < 5) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.addressLineOne,
          message: "Address Line 1 should be at least 5 characters!",
        ),
      );
    }

    if (dob == null || dob!.trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.dateOfBirth,
          message: "Date of Birth is required!",
        ),
      );
    }

    return errors;
  }

  List<FormFieldError> deliveryBuyingDetailsValidationErrors({
    List<InterestedVariant> newCarDetails = const [],
    InterestedColor? newCarColor,
    TestDriveGiven? newTestDrive,
    FirstTimeBuyer? newFirstTimeBuyer,
    InterestedInComp? newInterestedInComp,
    Booking? newBookingDetails,
    CustomerQuote? newCustomerQuote,
  }) {
    final errors = <FormFieldError>[];

    if (newCarDetails.firstOrNull?.product?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectModel,
          message: LocaleKeys.errSelectBrandModel.tr(),
        ),
      );
    }

    if (newCarDetails.firstOrNull?.engineType == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectEngineType,
          message: LocaleKeys.errSelectEngineType.tr(),
        ),
      );
    }

    if (newCarDetails.firstOrNull?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectVariant,
          message: LocaleKeys.errSelectVariant.tr(),
        ),
      );
    }

    if (newCarColor?.id == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectCarColor,
          message: LocaleKeys.errSelectCarColor.tr(),
        ),
      );
    }

    if (newTestDrive?.given == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.testDriveGiven,
          message: LocaleKeys.errInvalidTestDriveGiven.tr(),
        ),
      );
    } else {
      if (newTestDrive?.given == 1) {
        if ((newTestDrive?.when ?? "").isNullOrEmpty) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.testDriveGivenWhen,
              message: LocaleKeys.errSelectWhenDate.tr(),
            ),
          );
        }
        if (newTestDrive?.vehicleUsed == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.testDriveGivenVehicle,
              message: LocaleKeys.errSelectVehicleUsed.tr(),
            ),
          );
        }
        if ((newTestDrive?.toWhom ?? "").isNullOrEmpty) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.testDriveGivenToWhom,
              message: LocaleKeys.errToWhomShouldBeFilled.tr(),
            ),
          );
        }
      } else {
        if (newTestDrive?.whyNotGiven == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.notGivenReason,
              message: LocaleKeys.errSelectWhyNotGiven.tr(),
            ),
          );
        }
        if (newTestDrive?.whyNotGiven ==
                TestDriveWhyNotGivenState.others.value &&
            (newTestDrive?.whyNotGivenReason ?? "").isNullOrEmpty) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.notGivenOtherReason,
              message: LocaleKeys.errEnterOtherReason.tr(),
            ),
          );
        }
      }
    }

    if (purchaseMode == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.modeOfPurchase,
          message: "Mode of Purchase can't be empty!",
        ),
      );
    }

    if (newInterestedInComp?.status == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.interestedInComp,
          message: LocaleKeys.errInvalidInterestedInComp.tr(),
        ),
      );
    } else {
      if (newInterestedInComp?.status == InterestedInCompState.yes.value) {
        if (newInterestedInComp?.brand == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.compBrand,
              message: LocaleKeys.errSelectBrand.tr(),
            ),
          );
        }
        if (newInterestedInComp?.model == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.compModel,
              message: LocaleKeys.errSelectBrandModel.tr(),
            ),
          );
        }
      }
    }

    if (newFirstTimeBuyer?.isExistingVehicle == 2) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.firstTimeBuyerStatus,
          message: LocaleKeys.errInvalidFirstTimeBuyer.tr(),
        ),
      );
    }

    if (purchaseMode == PurchaseMode.finance.value) {
      if (newBookingDetails?.financeType == null) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.financeType,
            message: LocaleKeys.errSelectFinanceForm.tr(),
          ),
        );
      }
      if (newBookingDetails?.disbursalAmount == null) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.disbursalAmount,
            message: LocaleKeys.errDisbursalAmount.tr(),
          ),
        );
      }
    }

    if (newCustomerQuote?.tookQuote == CustomerQuoteState.yes.value &&
        (newCustomerQuote?.quoteDate ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.quoteDate,
          message: LocaleKeys.errSelectQuoteDate.tr(),
        ),
      );
    }

    if (purchaseMode == PurchaseMode.po.value &&
        (newBookingDetails?.poPhoto ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.poPhoto,
          message: LocaleKeys.errPoPhotoRequired.tr(),
        ),
      );
    }

    if (purchaseMode == PurchaseMode.finance.value &&
        newBookingDetails?.financeType == FinanceForm.dO.value &&
        (newBookingDetails?.doPhoto ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.doPhoto,
          message: LocaleKeys.errDoPhotoRequired.tr(),
        ),
      );
    }

    return errors;
  }

  List<FormFieldError> deliveryExchangeDetailsValidationErrors({
    FirstTimeBuyer? newFirstTimeBuyer,
    ExchangeProduct? newExchangeProduct,
    ExchangeHouseRequest? newExchangeHouseDetails,
    User? user,
  }) {
    final errors = <FormFieldError>[];
    if (isExchange == null || isExchange == InterestedInExchangeState.none.value) {
      return [
        FormFieldError(
          field: LeadFormFields.exchange,
          message: LocaleKeys.errSelectInterestedInExchange.tr(),
        ),
      ];
    }

    if (isExchange == InterestedInExchangeState.no.value) {
      return errors;
    }

    if (newExchangeHouseDetails?.exchangeType == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.exchangeType,
          message: LocaleKeys.errSelectExchangeType.tr(),
        ),
      );
    } else {
      if (newExchangeHouseDetails?.exchangeType == ExchangeType.inHouse.value) {
        if (newExchangeHouseDetails?.purchasePrice == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.exchangePurchasePrice,
              message: LocaleKeys.errEnterPurchaseValue.tr(),
            ),
          );
        }
      } else {
        if (newExchangeHouseDetails?.reason == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.exchangeReason,
              message: LocaleKeys.errSelectReason.tr(),
            ),
          );
        } else {
          if (newExchangeHouseDetails?.reason ==
              ExchangeOuthouseReason.betterValueOutside.value) {
            if (newExchangeHouseDetails?.approxValue == null) {
              errors.add(
                FormFieldError(
                  field: LeadFormFields.exchangeApproxValue,
                  message: LocaleKeys.errEnterApproxValue.tr(),
                ),
              );
            }
          } else if (newExchangeHouseDetails?.reason ==
              ExchangeOuthouseReason.other.value) {
            if ((newExchangeHouseDetails?.otherReason ?? "").isEmpty) {
              errors.add(
                FormFieldError(
                  field: LeadFormFields.exchangeOtherReason,
                  message: LocaleKeys.errEnterReason.tr(),
                ),
              );
            }
          }
        }
      }
    }

    if (newFirstTimeBuyer?.oldVehicleId == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectBrand,
          message: LocaleKeys.errSelectManufacture.tr(),
        ),
      );
    }

    if (newFirstTimeBuyer?.oldVehicleVariantId == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectBrandModel,
          message: LocaleKeys.errSelectBrandModel.tr(),
        ),
      );
    }

    if ((newExchangeProduct?.color ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.selectCarColor,
          message: LocaleKeys.errEnterColor.tr(),
        ),
      );
    }

    if (("${newExchangeProduct?.millage ?? ""}").isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.mileage,
          message: LocaleKeys.errEnterMileage.tr(),
        ),
      );
    }

    if (newExchangeProduct?.registrationNumber == null ||
        newExchangeProduct!.registrationNumber!.trim().isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.registrationNumber,
          message: LocaleKeys.errEnterRegistrationNumber.tr(),
        ),
      );
    }

    if (user?.isEvaluator == true) {
      if (newExchangeProduct?.dateOfEvaluation == null ||
          newExchangeProduct!.dateOfEvaluation!.isEmpty ||
          newExchangeProduct.dateOfEvaluation == "0000-00-00 00:00:00") {
        errors.add(
          FormFieldError(
            field: LeadFormFields.dateOfEvaluation,
            message: LocaleKeys.errDateOfEvaluation.tr(),
          ),
        );
      }

      if (newExchangeProduct?.expectedPrice == null ||
          newExchangeProduct?.expectedPrice == 0) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.expectedPrice,
            message: LocaleKeys.errEnterExpectedPrice.tr(),
          ),
        );
      }

      if (newExchangeProduct?.quotedPrice == null ||
          newExchangeProduct?.quotedPrice == 0) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.quotedPrice,
            message: LocaleKeys.errEnterQuotedPrice.tr(),
          ),
        );
      }

      if (newExchangeProduct?.registrationNumber == null ||
          newExchangeProduct!.registrationNumber!.trim().isEmpty) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.registrationNumber,
            message: LocaleKeys.errEnterRegistrationNumber.tr(),
          ),
        );
      }
    }

    return errors;
  }

  List<FormFieldError> deliveryPaymentDetailsValidationErrors({
    Booking? newBooking,
    CreditGiven? creditGiven,
    OldCarPayment? oldCarPayment,
    int pendingAmount = 0,
    ExchangeProduct? exchangeProduct,
  }) {
    final errors = <FormFieldError>[];

    // Validate: Old Vehicle Price (pendingAmount) + Customer Credit (pendingAmount) >= Pending Amount
    final oldVehiclePendingAmount = (oldCarPayment?.isGiven ?? false) ? (oldCarPayment?.amountPending ?? 0) : 0;
    final creditGivenPendingAmount = (creditGiven?.isGiven ?? false) ? (creditGiven?.amountPending ?? 0) : 0;
    final totalPendingAmount = oldVehiclePendingAmount + creditGivenPendingAmount;
    final absPendingAmount = pendingAmount.abs();


    if ((oldCarPayment?.isGiven ?? false) || (creditGiven?.isGiven ?? false)) {
      if (totalPendingAmount < absPendingAmount) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.amountPending,
            message: LocaleKeys.errPendingLessThanBalance.tr(),
          ),
        );
      }
    }

    // Validate Credit Given fields
    if ((creditGiven?.isGiven ?? false)) {
      if ((creditGiven?.permittedBy ?? "").isEmpty) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.permittedBy,
            message: LocaleKeys.errPermittedBy.tr(),
          ),
        );
      }
      if (creditGiven?.expectedDateOfPayment == null) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.expectedDateOfPayment,
            message: LocaleKeys.errExpectedDateOfPayment.tr(),
          ),
        );
      }
    }
    return errors;
  }

  List<FormFieldError> deliveryFormValidationErrors({
    Delivery? newDeliveryDetails,
  }) {
    final errors = <FormFieldError>[];

    if ((newDeliveryDetails?.reasonForSelectingBrand ?? []).isEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.reasonToSelectBrand,
          message: LocaleKeys.errReasonToSelectBrand.tr(),
        ),
      );
    } else {
      if ((newDeliveryDetails?.reasonForSelectingBrand ?? []).contains(
            SelectBrandReason.other.value,
          ) &&
          (newDeliveryDetails?.reasonForSelectingBrandOther ?? "").isEmpty) {
        errors.add(
          FormFieldError(
            field: LeadFormFields.reasonToSelectBrandOther,
            message: LocaleKeys.errReasonToSelectBrand.tr(),
          ),
        );
      }
    }

    if (newDeliveryDetails?.deliveryDate == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.dateOfDelivery,
          message: LocaleKeys.errDateOfDelivery.tr(),
        ),
      );
    }


    return errors;
  }
}

extension BrokerageValidationExtension on Brokerage {
  List<FormFieldError> brokerDetailsValidationErrors() {
    final errors = <FormFieldError>[];

    if (brokerName == null || brokerName!.isEmpty) {
      errors.add(
        FormFieldError(
          field: BrokerFormFields.name,
          message: LocaleKeys.errBrokerName.tr(),
        ),
      );
    }

    if (brokerCity == null || brokerCity!.isEmpty) {
      errors.add(
        FormFieldError(
          field: BrokerFormFields.city,
          message: LocaleKeys.errBrokerCity.tr(),
        ),
      );
    }

    if (validateMobile(brokerMobile) != null) {
      errors.add(
        FormFieldError(
          field: BrokerFormFields.mobile,
          message: LocaleKeys.errBrokerMobile.tr(),
        ),
      );
    }

    if (brokerAmount == null || brokerAmount == 0) {
      errors.add(
        FormFieldError(
          field: BrokerFormFields.amount,
          message: LocaleKeys.errBrokerAmount.tr(),
        ),
      );
    }

    return errors;
  }
}

extension TestDriveGivenExtension on TestDriveGiven {
  List<FormFieldError> testDriveGivenValidationErrors() {
    final errors = <FormFieldError>[];

    if (given == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.testDriveGiven,
          message: LocaleKeys.errInvalidTestDriveGiven.tr(),
        ),
      );
    } else {
      if (given == 1) {
        if ((when ?? "").isNullOrEmpty) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.testDriveGivenWhen,
              message: LocaleKeys.errSelectWhenDate.tr(),
            ),
          );
        }
        if (vehicleUsed == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.testDriveGivenVehicle,
              message: LocaleKeys.errSelectVehicleUsed.tr(),
            ),
          );
        }
        if ((toWhom ?? "").isNullOrEmpty) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.testDriveGivenToWhom,
              message: LocaleKeys.errToWhomShouldBeFilled.tr(),
            ),
          );
        }
      } else {
        if (whyNotGiven == null) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.notGivenReason,
              message: LocaleKeys.errSelectWhyNotGiven.tr(),
            ),
          );
        }
        if (whyNotGiven == TestDriveWhyNotGivenState.others.value &&
            (whyNotGivenReason ?? "").isNullOrEmpty) {
          errors.add(
            FormFieldError(
              field: LeadFormFields.notGivenOtherReason,
              message: LocaleKeys.errEnterOtherReason.tr(),
            ),
          );
        }
      }
    }

    return errors;
  }
}

extension ReceiptExtension on Receipt {
  List<FormFieldError> addReceiptValidationErrors() {
    final errors = <FormFieldError>[];

    if ((receiptNo ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: ReceiptFormFields.receiptName,
          message: LocaleKeys.errReceiptName.tr(),
        ),
      );
    }
    if (date == null) {
      errors.add(
        FormFieldError(
          field: ReceiptFormFields.receiptDate,
          message: LocaleKeys.errReceiptDate.tr(),
        ),
      );
    }
    if (amount == null) {
      errors.add(
        FormFieldError(
          field: ReceiptFormFields.receiptAmount,
          message: LocaleKeys.errReceiptAmount.tr(),
        ),
      );
    }
    if (paymentMode == null) {
      errors.add(
        FormFieldError(
          field: ReceiptFormFields.receiptModeOfPayment,
          message: LocaleKeys.errReceiptModeOfPayment.tr(),
        ),
      );
    }
    if (paymentMode == ReceiptPurchaseMode.cheque.value &&
        (permittedBy ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: ReceiptFormFields.receiptPermittedBy,
          message: LocaleKeys.errReceiptPermittedBy.tr(),
        ),
      );
    }

    if (type == ReceiptType.postDelivery.value && (paymentType ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: ReceiptFormFields.receiptPaymentType,
          message: LocaleKeys.errReceiptPaymentType.tr(),
        ),
      );
    }

    return errors;
  }
}

extension RequestApprovalExtension on DiscountApproval {
  List<FormFieldError> bookingDiscountApprovalValidationErrors({
    List<String> approvalReasons = const [],
  }) {
    final errors = <FormFieldError>[];
    if (approvalReasons.isEmpty) {
      errors.add(
        FormFieldError(
          field: DiscountFormFields.discountReasons,
          message: LocaleKeys.errDiscountReasons.tr(),
        ),
      );
    } else {
      if (approvalReasons.contains(MoreDiscountReasons.noneOfAbove.value) &&
          (discountReason ?? "").isEmpty) {
        errors.add(
          FormFieldError(
            field: DiscountFormFields.otherDiscountReason,
            message: LocaleKeys.errEnterOtherReason.tr(),
          ),
        );
      }
    }
    if (sentTo == null) {
      errors.add(
        FormFieldError(
          field: DiscountFormFields.sentTo,
          message: LocaleKeys.errSentTo.tr(),
        ),
      );
    }

    return errors;
  }

  List<FormFieldError> deliveryDiscountApprovalValidationErrors({
    List<String> approvalReasons = const [],
    Delivery? deliveryApproval,
  }) {
    final errors = <FormFieldError>[];

    if (discountGivenInExcess) {
      if (approvalReasons.isEmpty) {
        errors.add(
          FormFieldError(
            field: DiscountFormFields.discountReasons,
            message: LocaleKeys.errDiscountReasons.tr(),
          ),
        );
      } else {
        if (approvalReasons.contains(MoreDiscountReasons.noneOfAbove.value) &&
            (discountReason ?? "").isEmpty) {
          errors.add(
            FormFieldError(
              field: DiscountFormFields.otherDiscountReason,
              message: LocaleKeys.errEnterOtherReason.tr(),
            ),
          );
        }
      }

      if ((deliveryApproval?.discountPermittedBy ?? "").isEmpty) {
        errors.add(
          FormFieldError(
            field: DiscountFormFields.discountPermittedBy,
            message: LocaleKeys.errDiscountPermittedBy.tr(),
          ),
        );
      }
    }

    if ((deliveryApproval?.pendingCommitment ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: DiscountFormFields.pendingCommitments,
          message: LocaleKeys.errPendingCommitments.tr(),
        ),
      );
    }

    if (sentTo == null) {
      errors.add(
        FormFieldError(
          field: DiscountFormFields.sentTo,
          message: LocaleKeys.errSentTo.tr(),
        ),
      );
    }

    return errors;
  }
}

extension SendApprovalExtension on DiscountApprovalRequest {
  List<FormFieldError> bookingRejectDiscountApprovalValidationErrors() {
    final errors = <FormFieldError>[];
    if ((requestResponse ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: DiscountFormFields.rejectReason,
          message: LocaleKeys.errEnterReason.tr(),
        ),
      );
    }

    return errors;
  }

  List<FormFieldError> deliveryRejectDiscountApprovalValidationErrors() {
    final errors = <FormFieldError>[];
    if ((requestResponse ?? "").isEmpty) {
      errors.add(
        FormFieldError(
          field: DiscountFormFields.rejectReason,
          message: LocaleKeys.errEnterReason.tr(),
        ),
      );
    }

    return errors;
  }
}

extension ChangeLeadStatusRequestExtension on ChangeLeadStatusRequest {
  List<FormFieldError> inactiveBookingValidationErrors() {
    final errors = <FormFieldError>[];
    if ((bookingInactiveReasons ?? []).isEmpty) {
      errors.add(
        FormFieldError(
          field: InactiveBookingFormFields.inactiveBookingReasons,
          message: LocaleKeys.errSelectReason.tr(),
        ),
      );
    } else {
      if ((bookingInactiveReasons ?? []).contains(
            InactiveBookingReasons.others.value,
          ) &&
          (otherInactiveReason ?? "").isEmpty) {
        errors.add(
          FormFieldError(
            field: InactiveBookingFormFields.otherInactiveBookingReason,
            message: LocaleKeys.errEnterOtherReason.tr(),
          ),
        );
      }
    }

    return errors;
  }

  List<FormFieldError> cancelBookingValidationErrors() {
    final errors = <FormFieldError>[];
    if (bookingCancelReason == null) {
      errors.add(
        FormFieldError(
          field: CancelBookingFormFields.reasonOfCancellation,
          message: LocaleKeys.errReasonOfCancellation.tr(),
        ),
      );
    } else {
      if (bookingCancelReason == CancelBookingReasons.others.value &&
          (otherCancelledReason ?? "").isEmpty) {
        errors.add(
          FormFieldError(
            field: CancelBookingFormFields.otherCancellationReason,
            message: LocaleKeys.errEnterOtherReason.tr(),
          ),
        );
      }
    }

    if (sentTo == null) {
      errors.add(
        FormFieldError(
          field: CancelBookingFormFields.sentTo,
          message: LocaleKeys.errSentTo.tr(),
        ),
      );
    }

    return errors;
  }
}

extension LeadFollowupRequestExtension on LeadFollowupRequest {
  List<FormFieldError> get validationErrors {
    final errors = <FormFieldError>[];
    if (followUpPlan.isNullOrEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.planFollowUp,
          message: LocaleKeys.errMsgFollowupPlan.tr(),
        ),
      );
    }
    if (followUpDateTime == null) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.followUpDateTime,
          message: LocaleKeys.errFollowUpDateTime.tr(),
        ),
      );
    }
    return errors;
  }
}

extension CreateLeadHistoryRequestExtension on CreateLeadHistoryRequest {
  List<FormFieldError> get validationErrors {
    final errors = <FormFieldError>[];
    if (remarks.isNullOrEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.remarks,
          message: LocaleKeys.errMsgRemarks.tr(),
        ),
      );
    }
    if (leadStatus.isNullOrEmpty) {
      errors.add(
        FormFieldError(
          field: LeadFormFields.leadStatus,
          message: LocaleKeys.errMsgLeadStatus.tr(),
        ),
      );
    }
    return errors;
  }
}
