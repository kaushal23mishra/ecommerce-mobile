import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/extensions/customer_quote_extensions.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_customer_quote_widget.dart';
import 'package:salesdocket_mobile/features/prospect_sheet/view_model/prospect_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class CustomerQuoteWidget extends SalesdocketConsumerWidget {
  const CustomerQuoteWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerQuote = ref.watch(selectedCustomerQuoteProvider);
    final errors = <LeadFormFields, FormFieldError?>{};
    for (var field in _formFields) {
      errors[field] = ref.watch(prospectFormErrorsProvider).get(field);
    }

    return SalesdocketCustomerQuoteWidget(
      errors: errors,
      customerQuote: customerQuote,
      isRequired: true,
      onChanged: (field, key, value) => _onValueChanged(field, key, value, ref),
    );
  }

  void _onValueChanged(
    LeadFormFields field,
    dynamic key,
    dynamic value,
    WidgetRef ref,
  ) {
    ref.read(prospectFormErrorsProvider.notifier).remove(field);
    applyCustomerQuoteFieldChange(
      field,
      key,
      ref.read(selectedCustomerQuoteProvider.notifier),
    );
  }

  get _formFields => [
    LeadFormFields.customerTookQuote,
    LeadFormFields.quoteDate,
  ];
}
