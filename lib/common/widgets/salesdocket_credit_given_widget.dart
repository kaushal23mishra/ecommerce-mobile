import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/constants/input_formatters.dart';
import 'package:salesdocket_mobile/common/entity/credit_given.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketCreditGivenWidget extends SalesdocketStatefulWidget {
  final CreditGiven? creditGiven;
  final bool canEdit;
  final Map<LeadFormFields, FormFieldError?> errors;
  final Function(LeadFormFields, dynamic, dynamic)? onChanged;
  final List<LeadFormFields> disabledFields;

  const SalesdocketCreditGivenWidget({
    super.key,
    this.creditGiven,
    this.errors = const {},
    this.onChanged,
    this.canEdit = true,
    this.disabledFields = const [],
  });

  @override
  State<SalesdocketCreditGivenWidget> createState() =>
      _SalesdocketCreditGivenWidgetState();
}

class _SalesdocketCreditGivenWidgetState
    extends SalesdocketState<SalesdocketCreditGivenWidget> {
  late TextEditingController _amountPendingController;

  @override
  void initState() {
    _amountPendingController = TextEditingController(
      text: "${widget.creditGiven?.amountPending ?? ""}",
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
  void didUpdateWidget(SalesdocketCreditGivenWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newAmountPendingValue = widget.creditGiven?.amountPending;
    final oldAmountPendingValue = oldWidget.creditGiven?.amountPending;
    if (newAmountPendingValue != oldAmountPendingValue &&
        newAmountPendingValue.toString() != _amountPendingController.text) {
      _amountPendingController.removeListener(_onAmountChangeListener);
      _amountPendingController.text =
          "${newAmountPendingValue ?? ""}"; 
      _amountPendingController.addListener(_onAmountChangeListener);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.canEdit)
          SalesdocketSwitchWidget(
            value: widget.creditGiven?.isGiven ?? false,
            label: LocaleKeys.creditGivenToCustomer.tr(),
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(
                  LeadFormFields.creditGivenToTheCustomer,
                  value,
                  null,
                );
              }
            },
            hasSpace: true,
            errorText:
                widget.errors[LeadFormFields.creditGivenToTheCustomer]?.message,
          ),
        if (widget.creditGiven?.isGiven ?? false) _creditGivenWidget,
      ],
    );
  }

  Widget get _creditGivenWidget {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2.h,
        children: [
          _pendingAmountWidget,
          _permittedByWidget,
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
      enable:
          widget.canEdit &&
          !widget.disabledFields.contains(
            LeadFormFields.amountPending,
          ),
      errorMsg: widget.errors[LeadFormFields.amountPending]?.message,
    );
  }

  Widget get _permittedByWidget {
    return SalesDocketInputWidget(
      label: LocaleKeys.permittedBy.tr(),
      hint: LocaleKeys.permittedBy.tr(),
      initialValue: widget.creditGiven?.permittedBy ?? "",
      enable: widget.canEdit,
      onChanged: (newValue) {
        if (widget.onChanged != null) {
          widget.onChanged!(LeadFormFields.permittedBy, newValue.trim(), null);
        }
      },
      errorMsg: widget.errors[LeadFormFields.permittedBy]?.message,
    );
  }

  Widget get _expectedDateOfPaymentWidget {
    final selectedDate = widget.creditGiven?.expectedDateOfPayment;

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
