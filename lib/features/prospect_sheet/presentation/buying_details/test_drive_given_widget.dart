import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/common/extensions/lead_history_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_test_drive_given_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

import 'package:salesdocket_mobile/utility/forms_utils.dart';

class TestDriveGivenWidget extends SalesdocketConsumerWidget {
  const TestDriveGivenWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testDriveGiven = ref.watch(selectedTestDriveGivenProvider);

    final errors = <LeadFormFields, FormFieldError?>{};
    for (var field in FormsUtils.testDriveFormFields) {
      errors[field] = ref.watch(prospectFormErrorsProvider).get(field);
    }

    return SalesdocketTestDriveGivenWidget(
      errors: errors,
      testDriveGiven: testDriveGiven,
      isRequired: true,
      onChanged: (field, key, value) {
        FormsUtils.onTestDriveValueChanged(
          field: field,
          key: key,
          ref: ref,
          lead: ref.read(prospectLeadRequestProvider),
          testDriveGivenProvider: selectedTestDriveGivenProvider,
          formErrorsProvider: prospectFormErrorsProvider,
        );
      },
    );
  }
}
