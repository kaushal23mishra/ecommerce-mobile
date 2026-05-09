import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/follow_up_plan_type.dart';
import 'package:salesdocket_mobile/common/constants/widget.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/context_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/common/extensions/string_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketPlanFollowUpWidget extends SalesdocketStatelessWidget {
  final String? selectedPlanFollowup;
  final Function(String?)? onPlanSelected;
  final String? selectedFollowUpDateTime;
  final Function(String?)? onDateTimeSelected;
  final FormFieldError? followupPlanError;
  final FormFieldError? followupDateTimeError;
  final bool isPlanDisabled;
  final List<String> disabledChips;

  const SalesdocketPlanFollowUpWidget({
    super.key,
    this.selectedPlanFollowup,
    this.onPlanSelected,
    this.selectedFollowUpDateTime,
    this.onDateTimeSelected,
    this.followupPlanError,
    this.followupDateTimeError,
    this.disabledChips = const [],
    this.isPlanDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IgnorePointer(
          ignoring: isPlanDisabled,
          child: SalesDocketChipWidget<String>(
            label: LocaleKeys.lblPlanFollowUp.tr(),
            isRequired: true,
            chips: FollowUpPlanType.values.map((type) => type.value).toList(),
            selectedChips:
                (selectedPlanFollowup ?? "").isNotEmpty
                    ? [selectedPlanFollowup!]
                    : [],
            onSelected: (selected) {
              final selectedValue = selected?.firstOrNull;

              if (selectedValue != null) {
                if (!disabledChips.contains(selectedValue)) {
                  onPlanSelected?.call(selectedValue);
                } else {
                  context.showSnackBar(
                    "This option is disabled!",
                    type: SnackBarType.warning,
                  );
                }
              }
            },
            errorText: followupPlanError?.message,
            disabledChips: disabledChips,
          ),
        ),
        verticalSpacing(2.h),
        SalesdocketTimePickerSpinnerPopUp(
          label: LocaleKeys.msgFollowupDateTime.tr(),
          minTime: DateTime.now(),
          mode: CupertinoDatePickerMode.dateAndTime,
          isRequired: true,
          errorText: followupDateTimeError?.message,
          initTime:
              selectedFollowUpDateTime == null
                  ? null
                  : DateTime.parse(selectedFollowUpDateTime!),
          onChange: (newDateTime) {
            onDateTimeSelected?.call(newDateTime.formatDateTime());
          },
        ),
      ],
    );
  }
}
