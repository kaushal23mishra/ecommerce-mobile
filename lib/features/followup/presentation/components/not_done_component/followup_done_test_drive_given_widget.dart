import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/common/extensions/lead_history_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_test_drive_given_widget.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import '../../../../../common/constants/test_drive_given_constants.dart';

class FollowupDoneTestDriveGivenWidget extends SalesdocketConsumerWidget {
  const FollowupDoneTestDriveGivenWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testDriveGiven = ref.watch(followupTestDriveGivenProvider);

    final errors = <LeadFormFields, FormFieldError?>{};
    for (var field in _formFields) {
      errors[field] = ref.watch(createFollowUpFormErrorsProvider).get(field);
    }

    return SalesdocketTestDriveGivenWidget(
      errors: errors,
      testDriveGiven: testDriveGiven,
      onChanged: (field, key, value) => _onValueChanged(field, key, value, ref),
    );
  }

  void _onValueChanged(
    LeadFormFields field,
    dynamic key,
    dynamic value,
    WidgetRef ref,
  ) {
    final lead = ref.read(followupLeadRequestProvider);
    ref.read(createFollowUpFormErrorsProvider.notifier).remove(field);
    switch (field) {
      case LeadFormFields.testDriveGiven:
        final currentTestDrive = ref.read(followupTestDriveGivenProvider);
        final testDrive =
            key == TestDriveGivenState.no.value
                ? TestDriveGiven(given: key)
                : (currentTestDrive?.copyWith(given: key) ??
                        TestDriveGiven(given: key))
                    .defaultTestDriveGivenValues(lead);
        ref
            .read(followupTestDriveGivenProvider.notifier)
            .update((toUpdate) => toUpdate = testDrive);
        break;
      case LeadFormFields.testDriveGivenWhen:
        ref
            .read(followupTestDriveGivenProvider.notifier)
            .update((toUpdate) => toUpdate = toUpdate?.copyWith(when: key));
        break;
      case LeadFormFields.testDriveGivenVehicle:
        ref
            .read(followupTestDriveGivenProvider.notifier)
            .update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(vehicleUsed: key),
            );
        break;
      case LeadFormFields.testDriveGivenToWhom:
        ref
            .read(followupTestDriveGivenProvider.notifier)
            .update((toUpdate) => toUpdate = toUpdate?.copyWith(toWhom: key));
        break;
      case LeadFormFields.notGivenReason:
        ref
            .read(followupTestDriveGivenProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    whyNotGiven: key,
                    whyNotGivenReason: null,
                  ),
            );
        break;
      case LeadFormFields.notGivenOtherReason:
        ref
            .read(followupTestDriveGivenProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(whyNotGivenReason: key),
            );
        break;
      default:
        break;
    }
  }

  get _formFields => [
    LeadFormFields.testDriveGiven,
    LeadFormFields.testDriveGivenWhen,
    LeadFormFields.testDriveGivenVehicle,
    LeadFormFields.testDriveGivenToWhom,
    LeadFormFields.notGivenReason,
    LeadFormFields.notGivenOtherReason,
  ];
}
