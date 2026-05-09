import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/input_formatters.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/entity/old_car_payment.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class OldCarPaymentWidget extends SalesdocketStatefulWidget {
  final OldCarPayment? oldCarPayment;
  final bool canEdit;
  final Map<LeadFormFields, FormFieldError?> errors;
  final Function(LeadFormFields, dynamic, dynamic)? onChanged;
  final List<LeadFormFields> disabledFields;

  const OldCarPaymentWidget({
    super.key,
    this.oldCarPayment,
    this.errors = const {},
    this.onChanged,
    this.canEdit = true,
    this.disabledFields = const [],
  });

  @override
  State<OldCarPaymentWidget> createState() => _OldCarPaymentWidgetState();
}

class _OldCarPaymentWidgetState extends SalesdocketState<OldCarPaymentWidget> {
  late TextEditingController _amountPendingController;

  @override
  void initState() {
    _amountPendingController = TextEditingController(
      text: "${widget.oldCarPayment?.amountPending ?? ""}",
    );
    _amountPendingController.addListener(_onAmountChangeListener);
    super.initState();
  }

  @override
  void dispose() {
    _amountPendingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(OldCarPaymentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newAmountPendingValue = widget.oldCarPayment?.amountPending;
    final oldAmountPendingValue = oldWidget.oldCarPayment?.amountPending;
    if (newAmountPendingValue != oldAmountPendingValue &&
        newAmountPendingValue.toString() != _amountPendingController.text) {
      _amountPendingController.text =
          "${newAmountPendingValue ?? ""}".toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.canEdit)
          SalesdocketSwitchWidget(
            value: widget.oldCarPayment?.isGiven ?? false,
            label: LocaleKeys.oldCarPaymentPendingFromAgent.tr(),
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(
                  LeadFormFields.oldCarPayment,
                  value,
                  null,
                );
              }
            },
            hasSpace: true,
            errorText:
                widget.errors[LeadFormFields.oldCarPayment]?.message,
          ),
        if (widget.oldCarPayment?.isGiven ?? false) _contentWidget,
      ],
    );
  }

  Widget get _contentWidget {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2.h,
        children: [
          _pendingAmountWidget,
          _agentNameWidget,
          _agentNumberWidget,
          _expectedDateOfPaymentWidget,
        ],
      ),
    );
  }

  Widget get _pendingAmountWidget {
    return SalesDocketInputWidget(
      label: LocaleKeys.amountPending.tr(),
      hint: LocaleKeys.amountPending.tr(),
      controller: _amountPendingController,
      inputType: TextInputType.number,
      inputFormatters: InputFormatters.digitsOnly,
      enable: widget.canEdit,
      errorMsg: widget.errors[LeadFormFields.amountPending]?.message,
    );
  }

  Widget get _agentNameWidget {
    return SalesDocketInputWidget(
      label: LocaleKeys.agentName.tr(),
      hint: LocaleKeys.agentName.tr(),
      initialValue: widget.oldCarPayment?.agentName ?? "",
      enable: widget.canEdit,
      onChanged: (newValue) {
        if (widget.onChanged != null) {
          widget.onChanged!(LeadFormFields.agentName, newValue.trim(), null);
        }
      },
      errorMsg: widget.errors[LeadFormFields.agentName]?.message,
    );
  }

  Widget get _agentNumberWidget {
    return SalesDocketInputWidget(
      label: LocaleKeys.agentNumber.tr(),
      hint: LocaleKeys.agentNumber.tr(),
      initialValue: widget.oldCarPayment?.agentNumber ?? "",
      inputType: TextInputType.phone,
      inputFormatters: InputFormatters.digitsOnly,
      maxLength: 15,
      enable: widget.canEdit,
      onChanged: (newValue) {
        if (widget.onChanged != null) {
          widget.onChanged!(LeadFormFields.agentNumber, newValue.trim(), null);
        }
      },
      errorMsg: widget.errors[LeadFormFields.agentNumber]?.message,
    );
  }

  Widget get _expectedDateOfPaymentWidget {
    final selectedDate = widget.oldCarPayment?.expectedDateOfPayment;

    return SalesdocketTimePickerSpinnerPopUp(
      label: LocaleKeys.expectedDateOfPayment.tr(),
      mode: CupertinoDatePickerMode.date,
      initTime:
          selectedDate == null || selectedDate == "0000-00-00 00:00:00"
              ? null
              : DateTime.parse(selectedDate),
      enable: widget.canEdit,
      onChange: (newDateTime) {
        if (widget.onChanged != null) {
          widget.onChanged!(
            LeadFormFields.expectedDateOfPayment,
            newDateTime.formatDateTime(),
            null,
          );
        }
      },
      errorText: widget.errors[LeadFormFields.expectedDateOfPayment]?.message,
    );
  }

  void _onAmountChangeListener() {
    final newValue = _amountPendingController.text;
    if (widget.onChanged != null) {
      final amount = int.tryParse(newValue.trim());
      widget.onChanged!(LeadFormFields.amountPending, amount, null);
    }
  }
}
