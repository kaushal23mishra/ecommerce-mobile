import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/customer_quote_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/customer_quote.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/date_time_extensions.dart';
import 'package:salesdocket_mobile/generated/locale_keys.g.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class SalesdocketCustomerQuoteWidget extends SalesdocketStatelessWidget {
  final CustomerQuote? customerQuote;
  final Map<LeadFormFields, FormFieldError?> errors;
  final Function(LeadFormFields, dynamic, dynamic)? onChanged;
  final bool isRequired;

  const SalesdocketCustomerQuoteWidget({
    super.key,
    this.customerQuote,
    this.errors = const {},
    this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final selected = getCustomerQuoteLabel(customerQuote?.tookQuote);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.didCustomerTakeQuote.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: appColors.accent),
                  ),
            ],
          ),
        ),
        verticalSpacing(0.25.h),
        SalesDocketChipWidget<String>(
          chips: customerQuoteStateList.map((value) => value.label).toList(),
          selectedChips: selected == null ? [] : [selected],
          onSelected: (selected) {
            final newValue = selected?.firstOrNull;
            if (newValue != null && onChanged != null) {
              final value = getCustomerQuoteValue(newValue);
              onChanged!(LeadFormFields.customerTookQuote, value, null);
            }
          },
          errorText: errors[LeadFormFields.customerTookQuote]?.message,
        ),
        if (customerQuote?.tookQuote == CustomerQuoteState.yes.value)
          _quoteDateWidget(context),
      ],
    );
  }

  Widget _quoteDateWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: LocaleKeys.quoteDate.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: appColors.accent),
                  ),
              ],
            ),
          ),
          verticalSpacing(1.h),
          SalesdocketTimePickerSpinnerPopUp(
            mode: CupertinoDatePickerMode.date,
            initTime: _parseQuoteDate(),
            onChange: (newDate) {
              if (onChanged != null) {
                onChanged!(
                  LeadFormFields.quoteDate,
                  newDate.formatDateTime(),
                  null,
                );
              }
            },
            maxTime: DateTimeConstants.currentMaxDateTime,
            errorText: errors[LeadFormFields.quoteDate]?.message,
          ),
        ],
      ),
    );
  }

  DateTime? _parseQuoteDate() {
    final quoteDate = customerQuote?.quoteDate;
    if (quoteDate == null ||
        quoteDate.isEmpty ||
        quoteDate == "0000-00-00 00:00:00") {
      return null;
    }
    try {
      return DateTime.parse(quoteDate);
    } catch (_) {
      return null;
    }
  }
}
