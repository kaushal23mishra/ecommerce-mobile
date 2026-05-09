import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/first_time_buyer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/first_time_buyer.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_exchange_car_widget.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_searchable_dropdown_widget.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketFirstTimeBuyerWidget extends SalesdocketStatelessWidget {
  final FirstTimeBuyer? firstTimeBuyer;
  final bool canEditExistingVehicle;
  final Function(bool)? onEditChanged;
  final Map<LeadFormFields, FormFieldError?> errors;
  final Function(LeadFormFields, dynamic, dynamic)? onChanged;
  final bool isRequired;

  const SalesdocketFirstTimeBuyerWidget({
    super.key,
    this.firstTimeBuyer,
    this.canEditExistingVehicle = false,
    this.onEditChanged,
    this.errors = const {},
    this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.titleMedium;
    final selected = getFirstTimeBuyerLabel(firstTimeBuyer?.isExistingVehicle);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.firstTimeBuyer.tr(),
                style: defaultStyle,
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: defaultStyle?.copyWith(color: appColors.accent),
                ),
            ],
          ),
        ),
        verticalSpacing(0.25.h),
        SalesDocketChipWidget<String>(
          chips: firstTimeBuyerStateList.map((value) => value.label).toList(),
          selectedChips: selected == null ? [] : [selected],
          onSelected: (selected) {
            final newValue = selected?.firstOrNull;
            if (newValue != null && onChanged != null) {
              final value = getFirstTimeBuyerValue(newValue);
              onChanged!(LeadFormFields.firstTimeBuyerStatus, value, null);
            }
          },
          errorText: errors[LeadFormFields.firstTimeBuyerStatus]?.message,
        ),
        [
              FirstTimeBuyerState.none.value,
              FirstTimeBuyerState.yes.value,
              null,
            ].contains(firstTimeBuyer?.isExistingVehicle)
            ? const SizedBox.shrink()
            : _brandModelWidget(context),
      ],
    );
  }

  Widget _brandModelWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: Column(
        spacing: 2.h,
        children: [
          SalesdocketExchangeCarWidget(
            errors: errors,
            onChanged: onChanged,
            exchangeCar: firstTimeBuyer,
            titles: {LeadFormFields.selectModel: LocaleKeys.selectModel.tr()},
          ),
          _makeYearWidget(context),
        ],
      ),
    );
  }

  Widget _makeYearWidget(BuildContext context) {
    final allItems = List.generate(
      DateTime.now().year - 1900 + 1,
      (index) => (1900 + index).toString(),
    ).reversed.toList();

    return SalesdocketSearchableDropdownWidget<String>(
      label: LocaleKeys.modelYear.tr(),
      isRequired: false,
      selectedItem: firstTimeBuyer?.oldVehicleMakeYear?.toString(),
      items: firstTimeBuyer?.oldVehicleVariantId == null ? [] : allItems,
      itemAsString: (item) => item,
      compareFn: (a, b) => a == b,
      errorText: errors[LeadFormFields.selectModelYear]?.message,
      onChanged: (value) {
        final selectedYear = int.tryParse(value ?? '');
        if (selectedYear != null && onChanged != null) {
          onChanged!(LeadFormFields.selectModelYear, selectedYear, null);
        }
      },
    );
  }
}
