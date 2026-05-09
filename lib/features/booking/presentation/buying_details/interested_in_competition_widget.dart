import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_interested_in_competition_widget.dart';
import 'package:salesdocket_mobile/features/booking/view_model/booking_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class InterestedInCompetitionWidget extends SalesdocketConsumerWidget {
  const InterestedInCompetitionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interestedInComp = ref.watch(selectedInterestedInCompProvider);
    final errors = <LeadFormFields, FormFieldError?>{};
    for (var field in _formFields) {
      errors[field] = ref.watch(bookingFormErrorsProvider).get(field);
    }

    return SalesdocketInterestedInCompetitionWidget(
      interestedInComp: interestedInComp,
      errors: errors,
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
    ref.read(bookingFormErrorsProvider.notifier).remove(field);
    switch (field) {
      case LeadFormFields.interestedInComp:
        ref
            .read(selectedInterestedInCompProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(
                    status: key,
                    model: null,
                    brand: null,
                  ),
            );
        break;
      case LeadFormFields.compBrand:
        ref
            .read(selectedInterestedInCompProvider.notifier)
            .update(
              (toUpdate) =>
                  toUpdate = toUpdate?.copyWith(brand: key, model: null),
            );
        break;
      case LeadFormFields.compModel:
        ref
            .read(selectedInterestedInCompProvider.notifier)
            .update((toUpdate) => toUpdate = toUpdate?.copyWith(model: key));
        break;
      default:
        break;
    }
  }

  get _formFields => [
    LeadFormFields.interestedInComp,
    LeadFormFields.compBrand,
    LeadFormFields.compModel,
  ];
}
