import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_credit_given_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class CreditGivenWidget extends SalesdocketConsumerWidget {
  const CreditGivenWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditGiven = ref.watch(creditGivenProvider);
    final errors = <LeadFormFields, FormFieldError?>{};
    final canEdit = ref.watch(canEditDeliveryProvider);

    for (var field in _formFields) {
      errors[field] = ref.watch(deliveryFormErrorsProvider).get(field);
    }

    return IgnorePointer(
      ignoring: !canEdit,
      child: SalesdocketCreditGivenWidget(
        creditGiven: creditGiven,
        onChanged:
            (field, key, value) => _onValueChanged(field, key, value, ref),
        errors: errors,
        disabledFields: const [],
      ),
    );
  }

  void _onValueChanged(
    LeadFormFields field,
    dynamic key,
    dynamic value,
    WidgetRef ref,
  ) {
    ref.read(deliveryFormErrorsProvider.notifier).remove(field);
    switch (field) {
      case LeadFormFields.creditGivenToTheCustomer:
        final pendingAmount =
            ref
                .read(deliveryViewModelProvider.notifier)
                .calculatePendingAmountForCreditGiven();
        ref
            .read(creditGivenProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    isGiven: key,
                    amountPending: pendingAmount > 0 ? pendingAmount : null,
                    permittedBy: null,
                    expectedDateOfPayment: null,
                  ),
            );
        break;
      case LeadFormFields.permittedBy:
        ref
            .read(creditGivenProvider.notifier)
            .update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(permittedBy: key),
            );
        break;
      case LeadFormFields.expectedDateOfPayment:
        ref
            .read(creditGivenProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(expectedDateOfPayment: key),
            );
        break;
      case LeadFormFields.amountPending:
        ref.read(creditGivenProvider.notifier).update(
              (toUpdate) => toUpdate = toUpdate?.copyWith(amountPending: key),
            );
        break;
      default:
        break;
    }
  }

  get _formFields => [
    LeadFormFields.creditGivenToTheCustomer,
    LeadFormFields.amountPending,
    LeadFormFields.expectedDateOfPayment,
    LeadFormFields.permittedBy,
  ];
}
