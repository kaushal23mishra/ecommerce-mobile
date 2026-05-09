import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/test_drive_given_constants.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/common/extensions/lead_history_extensions.dart';
import 'package:salesdocket_mobile/common/providers/form_fields_error_notifier.dart';

class FormsUtils {
  static get createLeadFormFields {
    return [
      LeadFormFields.selectModel,
      LeadFormFields.selectEngineType,
      LeadFormFields.selectVariant,
      LeadFormFields.leadSource,
      LeadFormFields.sourceOfLead,
      LeadFormFields.othersReason,
      LeadFormFields.fullName,
      LeadFormFields.contactDetails,
      LeadFormFields.district,
      LeadFormFields.location,
      LeadFormFields.state,
      LeadFormFields.addressLineOne,
      LeadFormFields.addressLineTwo,
      LeadFormFields.planFollowUp,
      LeadFormFields.followUpDateTime,
      LeadFormFields.dateOfEnquiry,
      LeadFormFields.exchange,
      LeadFormFields.financeType,
    ];
  }

  static List<LeadFormFields> get testDriveFormFields {
    return [
      LeadFormFields.testDriveGiven,
      LeadFormFields.testDriveGivenWhen,
      LeadFormFields.testDriveGivenVehicle,
      LeadFormFields.testDriveGivenToWhom,
      LeadFormFields.notGivenReason,
      LeadFormFields.notGivenOtherReason,
    ];
  }

  static void onTestDriveValueChanged({
    required LeadFormFields field,
    required dynamic key,
    required WidgetRef ref,
    required Lead? lead,
    required StateProvider<TestDriveGiven?> testDriveGivenProvider,
    required StateNotifierProvider<FormFieldsErrorNotifier, List<FormFieldError>>
        formErrorsProvider,
  }) {
    ref.read(formErrorsProvider.notifier).remove(field);
    switch (field) {
      case LeadFormFields.testDriveGiven:
        final testDrive =
            key == TestDriveGivenState.no.value
                ? TestDriveGiven(given: key)
                : TestDriveGiven(given: key).defaultTestDriveGivenValues(lead);
        ref.read(testDriveGivenProvider.notifier).update((state) => testDrive);
        break;
      case LeadFormFields.testDriveGivenWhen:
        ref
            .read(testDriveGivenProvider.notifier)
            .update((state) => state?.copyWith(when: key));
        break;
      case LeadFormFields.testDriveGivenVehicle:
        ref
            .read(testDriveGivenProvider.notifier)
            .update((state) => state?.copyWith(vehicleUsed: key));
        break;
      case LeadFormFields.testDriveGivenToWhom:
        ref
            .read(testDriveGivenProvider.notifier)
            .update((state) => state?.copyWith(toWhom: key));
        break;
      case LeadFormFields.notGivenReason:
        ref.read(testDriveGivenProvider.notifier).update(
              (state) => state?.copyWith(
                whyNotGiven: key,
                whyNotGivenReason: null,
              ),
            );
        break;
      case LeadFormFields.notGivenOtherReason:
        ref
            .read(testDriveGivenProvider.notifier)
            .update((state) => state?.copyWith(whyNotGivenReason: key));
        break;
      default:
        break;
    }
  }
}
