import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import '../../../../common/classes/salesdocket_consumer_state.dart';
import '../../../../common/constants/widget.dart';
import '../../../../common/events/lead_events.dart';
import '../../view_model/followup_view_model.dart';

class HomeVisitFollowupDateTimeWidget extends SalesdocketConsumerStatefulWidget {
  const HomeVisitFollowupDateTimeWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FollowupDateTimeWidgetState();
}

class _FollowupDateTimeWidgetState
    extends SalesdocketConsumerState<HomeVisitFollowupDateTimeWidget> with LeadEvents {
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
            label: LocaleKeys.msgFollowupDateTime.tr(),
            minTime: DateTime.now().subtract(const Duration(days: 7)),
            mode: CupertinoDatePickerMode.dateAndTime,
            errorText: followupPlanDateTimeError?.message,
            initTime: selectedFollowUpDateTime != null &&
                selectedFollowUpDateTime.isNotEmpty
                ? DateTime.tryParse(selectedFollowUpDateTime)
                : null,
            onChange: (newDateTime) {
              final formattedDateTime = newDateTime.formatDateTime();
              ref.read(followupRequestProvider.notifier).update(
                    (followup) => followup?.copyWith(when: formattedDateTime),
              );
              ref
                  .read(createFollowUpFormErrorsProvider.notifier)
                  .remove(CreateFollowUpFormFields.when);
            },
          ),
          verticalSpacing(2.h),
        ],
      ),
    );
  }

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.error}) {
    context.showSnackBar(message, type: type);
  }

  @override
  WidgetRef get eventRef => ref;
}
