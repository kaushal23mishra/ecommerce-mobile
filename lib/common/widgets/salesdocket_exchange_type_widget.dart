import 'package:easy_localization/easy_localization.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/interested_in_exchange_state.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketExchangeTypeWidget extends SalesdocketStatelessWidget {
  final ExchangeHouseRequest? exchangeHouse;
  final Map<LeadFormFields, FormFieldError?> errors;
  final Function(LeadFormFields, dynamic, dynamic)? onChanged;
  final bool showOutHouseReasonWidget;

  const SalesdocketExchangeTypeWidget({
    super.key,
    this.exchangeHouse,
    this.errors = const {},
    this.onChanged,
    this.showOutHouseReasonWidget = true,
  });

  @override
  Widget build(BuildContext context) {
    final typeList = exchangeTypeList;
    final selected = typeList.firstWhereOrNull(
      (type) => type.value == exchangeHouse?.exchangeType,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesDocketChipWidget<String>(
          label: LocaleKeys.exchangeType.tr(),
          isRequired: true,
          chips: typeList.map((type) => type.value).toList(),
          selectedChips: selected == null ? [] : [selected.value],
          onSelected: (selected) {
            final newValue =
                typeList
                    .firstWhereOrNull(
                      (type) => type.value == selected?.firstOrNull,
                    )
                    ?.value;
            if (newValue != null && onChanged != null) {
              onChanged!(LeadFormFields.exchangeType, newValue, null);
            }
          },
          errorText: errors[LeadFormFields.exchangeType]?.message,
        ),
        _exchangeDetailsWidget(context, selected?.value),
      ],
    );
  }

  Widget _exchangeDetailsWidget(BuildContext context, String? exchangeType) {
    if (exchangeType == ExchangeType.inHouse.value) {
      return _inHouseWidget(context);
    }
    if (showOutHouseReasonWidget &&
        exchangeType == ExchangeType.outHouse.value) {
      return _outHouseWidget(context);
    }

    return const SizedBox.shrink();
  }

  Widget _inHouseWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
      child: Row(
        spacing: 4.w,
        children: [
          Expanded(
            child: SalesDocketInputWidget(
              label: LocaleKeys.purchaseValue.tr(),
              hint: LocaleKeys.purchaseValue.tr(),
              isRequired: true,
              initialValue: "${exchangeHouse?.purchasePrice ?? ""}",
              inputType: TextInputType.number,
              onChanged: (value) {
                if (onChanged != null) {
                  onChanged!(
                    LeadFormFields.exchangePurchasePrice,
                    int.tryParse(value),
                    null,
                  );
                }
              },
              errorMsg: errors[LeadFormFields.exchangePurchasePrice]?.message,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.5.h),
            child: SalesdocketSwitchWidget(
              label: LocaleKeys.adjust.tr(),
              value: exchangeHouse?.adjust ?? false,
              onChanged: (value) {
                if (onChanged != null) {
                  onChanged!(
                    LeadFormFields.exchangePurchasePriceAdjust,
                    value,
                    null,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _outHouseWidget(BuildContext context) {
    final reasons =
        exchangeOuthouseReasonList.map((reason) => reason.value).toList();
    final reason = exchangeHouse?.reason;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpacing(1.h),
        SalesDocketDropDownWidget(
          text: LocaleKeys.lblReason.tr(),
          isRequired: true,
          itemList: reasons,
          itemValue: exchangeHouse?.reason,
          imagePath: Assets.svg.arrowDown.path,
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(LeadFormFields.exchangeReason, value, null);
            }
          },
          errorText: errors[LeadFormFields.exchangeReason]?.message,
        ),
        if (reason == ExchangeOuthouseReason.other.value)
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: SalesDocketInputWidget(
              label: LocaleKeys.enterReason.tr(),
              hint: LocaleKeys.enterReason.tr(),
              isRequired: true,
              initialValue: exchangeHouse?.otherReason,
              onChanged: (value) {
                if (onChanged != null) {
                  onChanged!(LeadFormFields.exchangeOtherReason, value, null);
                }
              },
              errorMsg: errors[LeadFormFields.exchangeOtherReason]?.message,
            ),
          ),
        if (reason == ExchangeOuthouseReason.betterValueOutside.value)
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: SalesDocketInputWidget(
              label: LocaleKeys.approxValue.tr(),
              hint: LocaleKeys.approxValue.tr(),
              isRequired: true,
              inputType: TextInputType.number,
              initialValue: "${exchangeHouse?.approxValue ?? ""}",
              onChanged: (value) {
                if (onChanged != null) {
                  onChanged!(
                    LeadFormFields.exchangeApproxValue,
                    int.tryParse(value),
                    null,
                  );
                }
              },
              errorMsg: errors[LeadFormFields.exchangeApproxValue]?.message,
            ),
          ),
      ],
    );
  }
}
