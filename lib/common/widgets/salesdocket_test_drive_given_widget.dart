import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/test_drive_given_constants.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/test_drive_given.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_select_model_widget.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketTestDriveGivenWidget extends SalesdocketStatelessWidget {
  final TestDriveGiven? testDriveGiven;
  final Map<LeadFormFields, FormFieldError?> errors;
  final Function(LeadFormFields, dynamic, dynamic)? onChanged;
  final bool isRequired;

  const SalesdocketTestDriveGivenWidget({
    super.key,
    this.testDriveGiven,
    this.errors = const {},
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.testDriveGiven.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: appColors.accent),
                ),
            ],
          ),
        ),
        verticalSpacing(0.25.h),
        SalesDocketChipWidget<String>(
          chips: testDriveGivenStateList.map((value) => value.label).toList(),
          selectedChips:
              testDriveGiven?.given == null
                  ? []
                  : [
                    testDriveGiven?.given == TestDriveGivenState.yes.value
                        ? TestDriveGivenState.yes.label
                        : TestDriveGivenState.no.label,
                  ],
          onSelected: (selected) {
            if (selected?.firstOrNull != null) {
              final newValue =
                  selected?.firstOrNull == TestDriveGivenState.yes.label
                      ? 1
                      : 0;
              if (onChanged != null) {
                onChanged!(LeadFormFields.testDriveGiven, newValue, null);
              }
            }
          },
          errorText: errors[LeadFormFields.testDriveGiven]?.message,
        ),
        if (testDriveGiven != null && testDriveGiven?.given == 1)
          _givenReasonWidget(context),
        if (testDriveGiven != null && testDriveGiven?.given == 0)
          _notGivenReasonWidget(context),
      ],
    );
  }

  Widget _givenReasonWidget(BuildContext context) {
    return Column(
      children: [
        verticalSpacing(2.h),
        Row(crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.w,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.when.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  verticalSpacing(1.h),
                  SalesdocketTimePickerSpinnerPopUp(
                    mode: CupertinoDatePickerMode.date,
                    maxTime: DateTimeConstants.currentMaxDateTime,
                    initTime:
                        testDriveGiven?.when == null
                            ? null
                            : DateTime.parse(testDriveGiven?.when ?? ""),
                    onChange: (newDate) {
                      if (onChanged != null) {
                        onChanged!(
                          LeadFormFields.testDriveGivenWhen,
                          newDate.formatDateTime(),
                          null,
                        );
                      }
                    },
                    errorText:
                        errors[LeadFormFields.testDriveGivenWhen]?.message,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SalesdocketSelectModelWidget(
                selectedModel: testDriveGiven?.vehicleUsed,
                label: LocaleKeys.vehicleUsed.tr(),
                onModelSelected: (_, selected) {
                  if (onChanged != null) {
                    onChanged!(
                      LeadFormFields.testDriveGivenVehicle,
                      selected,
                      null,
                    );
                  }
                },
                onlyModel: true,
                error: errors[LeadFormFields.testDriveGivenVehicle],
              ),
            ),
          ],
        ),
        verticalSpacing(2.h),
        SalesDocketInputWidget(
          maxLength: 15,
          inputType: TextInputType.text,
          label: LocaleKeys.toWhom.tr(),
          initialValue: testDriveGiven?.toWhom ?? "",
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(
                LeadFormFields.testDriveGivenToWhom,
                value.trim(),
                null,
              );
            }
          },
          errorMsg: errors[LeadFormFields.testDriveGivenToWhom]?.message,
        ),
      ],
    );
  }

  Widget _notGivenReasonWidget(BuildContext context) {
    return Column(
      children: [
        verticalSpacing(2.h),
        SalesDocketDropDownWidget(
          text: LocaleKeys.whyNotGiven.tr(),
          itemList: testDriveWhyNotGivenStateList,
          itemValue: testDriveGiven?.whyNotGiven,
          imagePath: Assets.svg.arrowDown.path,
          isRequired: true,
          onChanged: (selected) {
            if (onChanged != null) {
              onChanged!(LeadFormFields.notGivenReason, selected, null);
            }
          },
          errorText: errors[LeadFormFields.notGivenReason]?.message,
        ),
        verticalSpacing(2.h),
        if (testDriveGiven?.whyNotGiven ==
            TestDriveWhyNotGivenState.others.value)
          SalesDocketInputWidget(
            maxLength: 50,
            inputType: TextInputType.text,
            label: LocaleKeys.lblReason.tr(),
            initialValue: testDriveGiven?.whyNotGivenReason ?? "",
            onChanged: (value) {
              if (onChanged != null) {
                onChanged!(
                  LeadFormFields.notGivenOtherReason,
                  value.trim(),
                  null,
                );
              }
            },
            errorMsg: errors[LeadFormFields.notGivenOtherReason]?.message,
          ),
      ],
    );
  }
}
