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

class FollowupDateTimeWidget extends SalesdocketConsumerStatefulWidget {
  final bool hasThreeFailedCalls;
  const FollowupDateTimeWidget({super.key, this.hasThreeFailedCalls = true});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FollowupDateTimeWidgetState();
}

class _FollowupDateTimeWidgetState
    extends SalesdocketConsumerState<FollowupDateTimeWidget>
    with LeadEvents {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDefaultDateTime();
    });
  }

  void _initializeDefaultDateTime() {
    final followupRequest = ref.read(followupRequestProvider);
    if (followupRequest?.when == null || followupRequest!.when!.isEmpty) {
      final defaultDateTime =
      widget.hasThreeFailedCalls
          ? DateTime.now()
          : DateTimeConstants.currentMaxDateTime;
      final formattedDateTime = defaultDateTime.formatDateTime();
      ref
          .read(followupRequestProvider.notifier)
          .update((followup) => followup?.copyWith(when: formattedDateTime));
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedFollowUpDateTime = ref.watch(
      followupRequestProvider.select((followup) => followup?.when),
    );

    final followupPlanDateTimeError = ref
        .watch(createFollowUpFormErrorsProvider)
        .get(CreateFollowUpFormFields.when);

    final now = DateTime.now();
    final todayStart = DateTimeConstants.currentMinDateTime;
    final todayEnd = DateTimeConstants.currentMaxDateTime;

    // When hasThreeFailedCalls is true, allow future dates (30 days from now)
    // When false, only allow today
    final maxTime = widget.hasThreeFailedCalls
        ? DateTime(now.year, now.month, now.day, 23, 59, 59).add(const Duration(days: 30))
        : todayEnd;

    final initDateTime =
    selectedFollowUpDateTime != null && selectedFollowUpDateTime.isNotEmpty
        ? DateTime.tryParse(selectedFollowUpDateTime)
        : now;
    return Padding(
      padding: EdgeInsets.only(top: 2.0.h),
      child: Column(
        children: [
          SalesdocketTimePickerSpinnerPopUp(
            label: LocaleKeys.msgFollowupDateTime.tr(),
            isRequired: true,
            minTime: todayStart,
            maxTime: maxTime,
            mode: CupertinoDatePickerMode.dateAndTime,
            errorText: followupPlanDateTimeError?.message,
            initTime:
            initDateTime!.isBefore(todayStart)
                ? todayStart
                : initDateTime.isAfter(maxTime)
                ? maxTime
                : initDateTime,
            onChange: (newDateTime) {
              // When hasThreeFailedCalls is true, allow any date within range
              // When false, restrict to today only
              final adjustedDateTime = widget.hasThreeFailedCalls
                  ? newDateTime
                  : DateTime(
                      now.year,
                      now.month,
                      now.day,
                      newDateTime.hour,
                      newDateTime.minute,
                    );

              final formattedDateTime = adjustedDateTime.formatDateTime();
              ref
                  .read(followupRequestProvider.notifier)
                  .update(
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
