import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketExchangeCarOtherDetailsWidget
    extends SalesdocketStatelessWidget {
  final bool? isInEditMode;
  final bool? isExchangeStatus;
  final ExchangeProduct? exchangeCar;
  final Map<LeadFormFields, FormFieldError?> errors;
  final Function(LeadFormFields, dynamic, dynamic)? onChanged;

  const SalesdocketExchangeCarOtherDetailsWidget({
    super.key,
    this.exchangeCar,
    this.isInEditMode = true,
    this.isExchangeStatus = true,
    this.errors = const {},
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 3.h,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.w,
          children: [
            Expanded(child: _colorWidget),
            Expanded(child: _mileageWidget),
          ],
        ),
        _registrationNoWidget,
      ],
    );
  }

  Widget get _colorWidget {
    return SalesDocketInputWidget(
      label: LocaleKeys.color.tr(),
      initialValue: exchangeCar?.color,
      isRequired: true,
      onChanged: (newValue) {
        if (onChanged != null) {
          onChanged!(LeadFormFields.selectCarColor, newValue.trim(), null);
        }
      },
      errorMsg: errors[LeadFormFields.selectCarColor]?.message,
    );
  }

  Widget get _mileageWidget {
    return SalesDocketInputWidget(
      label: LocaleKeys.mileageKm.tr(),
      initialValue: (exchangeCar?.millage ?? "").toString(),
      inputType: TextInputType.number,
      isRequired: true,
      onChanged: (newValue) {
        if (onChanged != null) {
          onChanged!(
            LeadFormFields.mileage,
            int.tryParse(newValue.trim()),
            null,
          );
        }
      },
      errorMsg: errors[LeadFormFields.mileage]?.message,
    );
  }

  Widget get _registrationNoWidget {
    return SalesDocketInputWidget(
      enable: isInEditMode ?? true,
      label: LocaleKeys.registrationNo.tr(),
      initialValue: exchangeCar?.registrationNumber,
      isRequired: true,
      onChanged: (newValue) {
        if (onChanged != null) {
          onChanged!(
            LeadFormFields.registrationNumber,
            newValue.trim().toUpperCase(),
            null,
          );
        }
      },
      textCapitalization: TextCapitalization.characters,
      errorMsg: errors[LeadFormFields.registrationNumber]?.message,
    );
  }
}
