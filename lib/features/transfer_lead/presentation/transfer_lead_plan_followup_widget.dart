import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/features/transfer_lead/view_model/transfer_lead_view_model.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class TransferLeadPlanFollowupWidget extends SalesdocketConsumerWidget {
  const TransferLeadPlanFollowupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFollowUpDateTime = ref.watch(
      transferLeadFollowupRequestProvider.select(
        (lead) => lead?.followUpDateTime,
      ),
    );
    final error = ref
        .watch(transferLeadFormErrorsProvider)
        .get(LeadFormFields.followUpDateTime);
    final formattedDateTime =
        selectedFollowUpDateTime == null
            ? null
            : DateTime.parse(selectedFollowUpDateTime);

    return SalesdocketTimePickerSpinnerPopUp(
      label: LocaleKeys.chooseFollowupDateAndTime.tr(),
      minTime: formattedDateTime,
      mode: CupertinoDatePickerMode.dateAndTime,
      errorText: error?.message,
      initTime: formattedDateTime,
      onChange: (newDateTime) {
        ref
            .read(transferLeadFollowupRequestProvider.notifier)
            .update(
              (lead) =>
                  lead = lead?.copyWith(
                    followUpDateTime: newDateTime.formatDateTime(),
                  ),
            );
      },
    );
  }
}
