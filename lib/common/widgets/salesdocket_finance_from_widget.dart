import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/input_formatters.dart';
import 'package:salesdocket_mobile/common/constants/purchase_mode.dart';
import 'package:salesdocket_mobile/common/entity/check_list_item.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/events/lead_events.dart';
import 'package:salesdocket_mobile/common/extensions/dynamic_extensions.dart';
import 'package:salesdocket_mobile/common/shapes/slider_thumb_shaps.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_checklist_widget.dart';
import 'package:salesdocket_mobile/features/lead/view_model/lead_view_model.dart';
import 'package:salesdocket_mobile/generated/assets.gen.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class SalesdocketFinanceFromWidget extends SalesdocketConsumerStatefulWidget {
  final Booking? booking;
  final Delivery? delivery;
  final Map<LeadFormFields, FormFieldError?> errors;
  final Function(LeadFormFields, dynamic, dynamic)? onChanged;
  final bool isDelivery;

  final bool showDisbursalAmount;

  const SalesdocketFinanceFromWidget.delivery({
    super.key,
    this.delivery,
    this.errors = const {},
    this.onChanged,
    this.showDisbursalAmount = false,
  }) : isDelivery = true,
       booking = null;

  const SalesdocketFinanceFromWidget.booking({
    super.key,
    this.booking,
    this.errors = const {},
    this.onChanged,
    this.showDisbursalAmount = false,
  }) : isDelivery = false,
       delivery = null;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalesdocketFinanceFromWidgetState();
}

class _SalesdocketFinanceFromWidgetState
    extends SalesdocketConsumerState<SalesdocketFinanceFromWidget>
    with LeadEvents {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedFinanceType =
        widget.isDelivery
            ? widget.delivery?.financeType
            : widget.booking?.financeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesDocketChipWidget(
          label: LocaleKeys.financeForm.tr(),
          isRequired: true,
          chips: financeFormList.map((source) => source.value).toList(),
          selectedChips:
              selectedFinanceType == null ? [] : [selectedFinanceType],
          onSelected: (selected) {
            final newValue = selected?.firstOrNull;
            if (widget.onChanged != null) {
              widget.onChanged!(LeadFormFields.financeType, newValue, null);
            }
          },
          errorText: widget.errors[LeadFormFields.financeType]?.message,
        ),
        if (selectedFinanceType != null) _formWidget,
      ],
    );
  }

  Widget get _formWidget {
    final financeType =
        _isDelivery ? widget.delivery?.financeType : widget.booking?.financeType;
    return Column(
      children: [
        if (widget.showDisbursalAmount) ...[
          verticalSpacing(2.h),
          _disbursalAmountWidget,
        ],
        if (financeType == FinanceForm.dO.value) ...[
          verticalSpacing(2.h),
          _payoutAmountWidget,
        ],
        if (financeType == FinanceForm.self.value) ...[
          verticalSpacing(2.h),
          _financeReasonsWidget,
        ],
        verticalSpacing(2.h),
      ],
    );
  }

  Widget get _payoutAmountWidget {
    final payoutPercentage = double.tryParse(
      _isDelivery
          ? widget.delivery?.payoutPercentage ?? "0"
          : widget.booking?.payoutPercentage ?? "0",
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.payoutPercentage.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        verticalSpacing(1.h),
        Container(
          padding: EdgeInsets.only(
            top: 4.h,
            bottom: 1.h,
            left: 1.5.w,
            right: 1.5.w,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: appColors.inputBorder, width: 0.1.w),
            borderRadius: BorderRadius.all(Radius.circular(2.w)),
          ),
          child: SfSliderTheme(
            data: SfSliderThemeData(
              activeTrackHeight: 0,
              inactiveTrackHeight: 0,
              tickSize: Size(0.3.w, 1.5.h),
              tooltipBackgroundColor: Colors.transparent,
            ),
            child: SfSlider(
              min: 0,
              max: 2.5,
              value: payoutPercentage,
              shouldAlwaysShowTooltip: false,
              showTicks: true,
              enableTooltip: true,
              stepSize: 0.1,
              interval: 0.5,
              minorTicksPerInterval: 4,
              activeColor: appColors.primary,
              inactiveColor: appColors.primaryLight,
              tooltipTextFormatterCallback: (_, value) => "",
              thumbShape: SliderThumbShape(
                buildContext: context,
                value: "${(payoutPercentage ?? 0).toStringAsFixed(1)}%",
              ),
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(LeadFormFields.bankPayout, "$value", null);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget get _financeReasonsWidget {
    final selectedItems =
        _isDelivery
            ? (widget.delivery?.deliveryReasons ?? [])
                .map((reason) => reason.reason ?? "")
                .where((reason) => reason.isNotEmpty)
                .toList()
            : (widget.booking?.bookingReasons ?? [])
                .map((reason) => reason.reason ?? "")
                .where((reason) => reason.isNotEmpty)
                .toList();

    final items =
        (_isDelivery
                    ? widget.delivery?.financeType
                    : widget.booking?.financeType) ==
                FinanceForm.self.value
            ? selfFinanceReasonsList
            : otherFinanceReasonsList;

    final error = widget.errors[LeadFormFields.financeReason]?.message;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.lblReason.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text: ' *',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: appColors.accent),
              ),
            ],
          ),
        ),
        CheckListWidget<String>(
          items:
              items
                  .map(
                    (item) => CheckListItem(key: item.key, value: item.value),
                  )
                  .toList(),
          selectedItems: selectedItems,
          onChanged: (selected) {
            if (widget.onChanged != null) {
              widget.onChanged!(LeadFormFields.financeReason, selected, null);
            }
          },
          enableScroll: false,
        ),
        if (error != null && error.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
            child: Text(
              error,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: appColors.error),
            ),
          ),
      ],
    );
  }

  Widget get _dsaDetailsWidget {
    return Row(mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      spacing: 4.w,
      children: [
        Expanded(
          child: SalesDocketInputWidget(
            initialValue:
                _isDelivery
                    ? widget.delivery?.dsaName
                    : widget.booking?.dsaName,
            label: LocaleKeys.dsaName.tr(),
            hint: LocaleKeys.dsaName.tr(),
            isRequired: true,
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(LeadFormFields.dsaName, value.trim(), null);
              }
            },
            errorMsg: widget.errors[LeadFormFields.dsaName]?.message,
          ),
        ),
        Expanded(
          child: SalesDocketInputWidget(
            initialValue:
                _isDelivery
                    ? widget.delivery?.dsaMobile
                    : widget.booking?.dsaMobile,
            label: LocaleKeys.dsaMobile.tr(),
            hint: LocaleKeys.dsaMobile.tr(),
            isRequired: true,
            inputType: TextInputType.phone,
            inputFormatters: InputFormatters.mobile,
            maxLength: 10,
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(LeadFormFields.dsaMobile, value.trim(), null);
              }
            },
            errorMsg: widget.errors[LeadFormFields.dsaMobile]?.message,
          ),
        ),
      ],
    );
  }

  Widget get _disbursalAmountWidget {
    return SalesDocketInputWidget(
      label: LocaleKeys.disbursalAmount.tr(),
      hint: LocaleKeys.disbursalAmount.tr(),
      isRequired: true,
      initialValue:
          "${(_isDelivery ? widget.delivery?.disbursalAmount : widget.booking?.disbursalAmount) ?? ""}",
      inputType: TextInputType.number,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(
            LeadFormFields.disbursalAmount,
            int.tryParse(value.trim()),
            null,
          );
        }
      },
      errorMsg: widget.errors[LeadFormFields.disbursalAmount]?.message,
    );
  }

  bool get _isDelivery => widget.isDelivery;

  @override
  WidgetRef get eventRef => ref;
}
