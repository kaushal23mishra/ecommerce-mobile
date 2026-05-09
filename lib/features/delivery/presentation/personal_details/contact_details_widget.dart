import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salesdocket_mobile/common/classes/salesdocket_consumer_state.dart';
import 'package:salesdocket_mobile/common/constants/form_fields.dart';
import 'package:salesdocket_mobile/common/entity/form_error.dart';
import 'package:salesdocket_mobile/common/widgets/salesdocket_contact_details_widget.dart';
import 'package:salesdocket_mobile/features/delivery/view_model/delivery_view_model.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';

class ContactDetailsWidget extends SalesdocketConsumerWidget {
  const ContactDetailsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactDetails = ref.watch(contactDetailsProvider) ?? [];
    final contactDetailErrors =
        ref
            .watch(deliveryFormErrorsProvider)
            .getAll(LeadFormFields.contactDetails) ??
        [];
    return SalesdocketContactDetailsWidget(
      contactDetails: contactDetails,
      contactDetailErrors: contactDetailErrors,
      canEditFirstContact: true,
      updateContactDetails: (details) {
        ref
            .read(contactDetailsProvider.notifier)
            .update((toUpdate) => toUpdate = details);
      },
      removeContactError: (index) {
        ref
            .read(deliveryFormErrorsProvider.notifier)
            .removeWhere((element) => element.index == index);
      },
      checkContact: false,
      nonRemovableIndices: const [1], // Email field at index 1 is required
    );
  }
}
