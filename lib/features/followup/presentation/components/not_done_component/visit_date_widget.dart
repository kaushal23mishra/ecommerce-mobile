import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/features/followup/view_model/followup_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import '../../../../../common/classes/salesdocket_consumer_state.dart';
import '../../../../../generated/locale_keys.g.dart';

class VisitDateWidget extends SalesdocketConsumerStatefulWidget {
  const VisitDateWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FollowupDateTimeWidgetState();
}

class _FollowupDateTimeWidgetState
    extends SalesdocketConsumerState<VisitDateWidget>
    with LeadEvents {
  @override
  Widget build(BuildContext context) {
    final selectedFollowUpDateTime = ref.watch(
      followupRequestProvider.select((followup) => followup?.when),
    );

    final followupPlanDateTimeError = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.when);



    return Padding(
      padding: EdgeInsets.only(top: 2.0.h),
      child: Column(
        children: [
          SalesdocketTimePickerSpinnerPopUp(
            label: LocaleKeys.lblVisitDate.tr(),
        minTime: DateTime.now(),
            maxTime: DateTimeConstants.currentMaxDateTime,
            mode: CupertinoDatePickerMode.date,
            errorText: followupPlanDateTimeError?.message,
            initTime:
                selectedFollowUpDateTime != null &&
                        selectedFollowUpDateTime.isNotEmpty
                    ? DateTime.tryParse(selectedFollowUpDateTime)
                    : null,
            onChange: (newDateTime) {
              final formattedDateTime = newDateTime.formatDateTime();
              ref
                  .read(followupRequestProvider.notifier)
                  .update(
                    (followup) => followup?.copyWith(when: formattedDateTime),
                  );
              ref
                  .read(createFollowUpFormErrorsProvider.notifier)
                  .remove(CreateFollowUpFormFields.visitDate);
            },
          ),
          verticalSpacing(2.h),
        ],
      ),
    );
  }

  @override
  WidgetRef get eventRef => ref;
}
